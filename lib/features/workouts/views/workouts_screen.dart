// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/workout_request.dart';
import '../models/workout_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class WorkoutPlanPage extends StatefulWidget {
  const WorkoutPlanPage({super.key});

  @override
  State<WorkoutPlanPage> createState() => _WorkoutPlanPageState();
}

class _WorkoutPlanPageState extends State<WorkoutPlanPage> {
  WorkoutResponse? _workoutResponse;
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedDayIndex = 0; // Добавляем состояние для выбранного дня

  final WorkoutRequest _requestData = WorkoutRequest(
    heightCm: 180,
    weightKg: 80,
    age: 21,
    gender: "male",
    goal: "weight_loss",
    menstrualPhase: "",
    bodyFatPercentage: 38.0,
    days: 7,
  );

  Future<void> _fetchWorkoutPlan() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String baseUrl = dotenv.env['FASTAPI_URL'] ?? 'http://127.0.0.1:8000';
    const String endpoint = '/workout-calories/generate';
    final String apiUrl = '$baseUrl$endpoint';

    print('Attempting to connect to: $apiUrl');
    print('ALISHER: ${workoutRequestToJson(_requestData)}');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: workoutRequestToJson(_requestData),
      );

      if (response.statusCode == 200) {
        setState(() {
          _workoutResponse = workoutResponseFromJson(response.body);
          // Сбросим выбранный день, если количество дней изменилось
          if (_selectedDayIndex >= (_workoutResponse?.workoutPlan.length ?? 0)) {
            _selectedDayIndex = 0;
          }
        });
      } else {
        setState(() {
          _errorMessage = 'Ошибка ${response.statusCode}: ${response.reasonPhrase}\n${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not connect to server: $e';
      });
      print('Network/Connection error: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchWorkoutPlan();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Workout Plan'),
        backgroundColor: Theme.of(context).primaryColor,
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
    final List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Блоки BMI и BFP
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(child: _buildInfoCard('BMI', response.bmiCase, Icons.accessibility, _getBMIDescription(response.bmiCase))),
                const SizedBox(width: 2), // Сокращаем расстояние
                Expanded(child: _buildInfoCard('BFP', response.bfpCase, Icons.monitor_weight, _getBFPDescription(response.bfpCase))),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Заголовок "Your workout plan" и селектор дней в одной карточке
          _buildDaySelectorCard(weekdays, response.workoutPlan.length),
          const SizedBox(height: 16),

          // Отображение плана для выбранного дня
          if (response.workoutPlan.isNotEmpty && _selectedDayIndex < response.workoutPlan.length)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildDayWorkoutCard(response.workoutPlan[_selectedDayIndex]),
            )
          else
            const Center(child: Text('Workout plan for selected day not available.')),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // Новый компактный виджет для отображения BMI/BFP с кнопкой информации
  Widget _buildInfoCard(String title, String? value, IconData icon, String description) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(icon, color: Theme.of(context).primaryColor, size: 28),
            const SizedBox(height: 4),
            Text(
              title,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min, // Добавляем MainAxisSize.min
              children: [
                Flexible( // Использование Flexible для предотвращения переполнения
                  child: Text(
                    value ?? 'N/A',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center, // Центрируем текст
                  ),
                ),
                if (value != null && value != 'N/A')
                  GestureDetector(
                    onTap: () {
                      _showInfoDialog(context, title, description);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(left: 4.0), // Отступ для иконки
                      child: Icon(Icons.info_outline, size: 18, color: Colors.grey[600]),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showInfoDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(content),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String _getBMIDescription(String? bmiCase) {
    switch (bmiCase?.toLowerCase()) {
      case 'mild thinness':
        return 'Your BMI is less than 18.5, indicating that you are underweight. This might be due to various factors and could lead to health issues. Consider consulting a healthcare professional or nutritionist.';
      case 'moderate thinness':
        return 'Your BMI is between 18.5 and 24.9, which is considered a healthy weight range for your height. Maintain a balanced diet and regular exercise to stay healthy.';
      case 'normal':
        return 'Your BMI is between 18.5 and 24.9. This is considered a healthy weight range for your height. Maintain a balanced diet and regular exercise to stay healthy.';
      case 'overweight':
        return 'Your BMI is between 25 and 29.9, indicating that you are overweight. This can increase the risk of various health problems. Focus on healthy eating and increased physical activity.';
      case 'obese':
        return 'Your BMI is 30 or higher, classifying you as obese. Obesity significantly increases the risk of serious health conditions. It\'s highly recommended to seek professional medical advice for weight management.';
      case 'sever thinness':
        return 'Your BMI is 35 or higher, indicating severe obesity. This condition poses serious health risks and requires immediate medical attention. Consult a healthcare professional for a personalized plan.';
      case 'severe obese':
        return 'Your BMI is 40 or higher, indicating very severe obesity. This condition poses significant health risks and requires immediate medical attention. Consult a healthcare professional for a personalized plan.';
      default:
        return 'BMI (Body Mass Index) is a measure that uses your height and weight to work out if your weight is healthy. It\'s a screening tool, not a diagnostic one. Consult a doctor for personalized advice.';
    }
  }

  String _getBFPDescription(String? bfpCase) {
    switch (bfpCase?.toLowerCase()) {
      case 'athletes':
        return 'Body fat percentage typical for athletes. It\'s low but generally healthy for individuals with high levels of physical activity.';
      case 'fitness':
        return 'Body fat percentage common among individuals who are in good shape and regularly exercise. It\'s considered healthy and desirable.';
      case 'acceptable':
        return 'This range is considered acceptable for most people, representing a moderate amount of body fat. It\'s a healthy range for general population.';
      case 'obese':
        return 'Body fat percentage in this range indicates obesity, which significantly increases the risk of various health problems. It is advisable to consult a healthcare professional.';
      default:
        return 'BFP (Body Fat Percentage) is the total mass of fat divided by total body mass. It includes essential body fat and storage body fat. Healthy ranges vary by age and gender. Consult a professional for an accurate measurement.';
    }
  }

  // Объединенная карточка для заголовка и селектора дней
  Widget _buildDaySelectorCard(List<String> weekdays, int numberOfDays) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      width: double.infinity, // Расширяем на всю доступную ширину
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 8.0),
            child: Text(
              'Your workout plan:',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(numberOfDays, (index) {
                final bool isSelected = _selectedDayIndex == index;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDayIndex = index;
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 6.0),
                    child: Column(
                      children: [
                        Text(
                          weekdays[index % weekdays.length],
                          style: TextStyle(
                            fontSize: 12,
                            color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium?.color,
                          ),
                        ),
                        const SizedBox(height: 4),
                        CircleAvatar(
                          radius: 18,
                          backgroundColor: isSelected
                              ? Theme.of(context).primaryColor
                              : Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                          child: Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.onPrimary
                                  : Theme.of(context).textTheme.bodyLarge?.color,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDayWorkoutCard(WorkoutPlan dayPlan) {
    return Card(
      elevation: 4,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Day ${dayPlan.day}: ${dayPlan.workoutName}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold, color: Theme.of(context).primaryColor),
            ),
            const SizedBox(height: 8),
            Text(
              dayPlan.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey[700]),
            ),
            const Divider(height: 24, thickness: 1),
            // Условие для скрытия упражнений, если workoutName = "Rest or Active Recovery"
            if (dayPlan.workoutName != "Rest or Active Recovery")
              ...dayPlan.exercises.map((exercise) => _buildExerciseTile(exercise))
            else
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Center(
                  child: Column(
                    children: [
                      Icon(Icons.self_improvement, size: 40, color: Theme.of(context).primaryColor),
                      const SizedBox(height: 8),
                      Text(
                        'Enjoy your rest or active recovery!',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontStyle: FontStyle.italic, color: Colors.grey[700]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildExerciseTile(Exercise exercise) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.fitness_center, color: Theme.of(context).primaryColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  exercise.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildInfoRow(Icons.repeat, 'Sets: ${exercise.sets}', context),
                _buildInfoRow(Icons.directions_run, 'Reps: ${exercise.reps}', context),
                _buildInfoRow(Icons.flag, 'Goal: ${exercise.target}', context),
                _buildInfoRow(Icons.notes, 'Notes: ${exercise.notes}', context),
                _buildInfoRow(Icons.local_fire_department, 'Calories Burned: ${exercise.caloriesBurned.toStringAsFixed(2)} kcal', context),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: Colors.grey[700]),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}