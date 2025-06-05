// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/workout_request.dart'; // Убедитесь, что путь верен
import '../models/workout_response.dart'; // Убедитесь, что путь верен
import 'package:flutter_dotenv/flutter_dotenv.dart'; // <-- Добавлен импорт для dotenv

class WorkoutPlanPage extends StatefulWidget {
  const WorkoutPlanPage({super.key});

  @override
  State<WorkoutPlanPage> createState() => _WorkoutPlanPageState();
}

class _WorkoutPlanPageState extends State<WorkoutPlanPage> {
  WorkoutResponse? _workoutResponse;
  bool _isLoading = false;
  String? _errorMessage;

  // Примерные данные для отправки, как в вашем запросе
  final WorkoutRequest _requestData = WorkoutRequest(
    heightCm: 175,
    weightKg: 75,
    age: 21,
    gender: "female",
    goal: "weight_loss",
    menstrualPhase: "luteal",
    bodyFatPercentage: 18.0,
    days: 7,
  );

  Future<void> _fetchWorkoutPlan() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Получаем базовый URL из .env файла.
    // Если .env файл не загружен или переменная отсутствует, используем localhost как запасной вариант.
    final String baseUrl = dotenv.env['FASTAPI_URL'] ?? 'http://127.0.0.1:8000'; 
    const String endpoint = '/workout-calories/generate';
    final String apiUrl = '$baseUrl$endpoint'; // Комбинируем базовый URL и эндпоинт
    
    print('Attempting to connect to: $apiUrl'); // Для отладки, чтобы видеть, куда идет запрос
    print('ALISHER: $workoutRequestToJson(_requestData)'); // Выводим данные запроса для отладки

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: workoutRequestToJson(_requestData), // Здесь данные запроса преобразуются в JSON
      );

      if (response.statusCode == 200) {
        // Успешный ответ
        setState(() {
          _workoutResponse = workoutResponseFromJson(response.body); // Здесь JSON-ответ от FastAPI преобразуется в Dart-объекты
        });
      } else {
        // Ошибка сервера или невалидный ответ
        setState(() {
          _errorMessage =
              'Ошибка ${response.statusCode}: ${response.reasonPhrase}\n${response.body}';
        });
      }
    } catch (e) {
      // Ошибка сети (например, сервер недоступен, брандмауэр блокирует, таймаут)
      setState(() {
        _errorMessage = 'Could not connect to server: $e';
      });
      print('Network/Connection error: $e'); // Дополнительный вывод ошибки в консоль
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWorkoutPlan(); // Автоматически запрашиваем данные при загрузке страницы
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Workout Plan'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 60),
                        const SizedBox(height: 10),
                        Text(
                          'Loading error: $_errorMessage',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _fetchWorkoutPlan,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _workoutResponse == null
                  ? const Center(child: Text('No workout plan available'))
                  : _buildWorkoutPlanDisplay(_workoutResponse!),
    );
  }

  Widget _buildWorkoutPlanDisplay(WorkoutResponse response) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Status', response.status, Colors.green),
          _buildInfoCard('BMI Category', response.bmiCase, Colors.blue),
          _buildInfoCard('BFP Category', response.bfpCase, Colors.teal),
          const SizedBox(height: 20),
          const Text(
            'Your workout plan:',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          ...response.workoutPlan.map((dayPlan) =>
              _buildDayWorkoutCard(dayPlan)),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: color,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$title:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayWorkoutCard(WorkoutPlan dayPlan) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Day ${dayPlan.day}: ${dayPlan.workoutName}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 8),
            Text(
              dayPlan.description,
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey[700]),
            ),
            const Divider(height: 20, thickness: 1),
            ...dayPlan.exercises.map((exercise) =>
                _buildExerciseTile(exercise)),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseTile(Exercise exercise) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            exercise.name,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text('Sets: ${exercise.sets}, Reps: ${exercise.reps}'),
          Text('Goal: ${exercise.target}'),
          Text('Notes: ${exercise.notes}'),
          Text('Calories Burned: ${exercise.caloriesBurned.toStringAsFixed(2)}'),
          if (exercise.caloriesBurned == 0) // Пример выделения
            const Text(' (Value 0.00 may show on placeholder)', style: TextStyle(color: Colors.orange)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}