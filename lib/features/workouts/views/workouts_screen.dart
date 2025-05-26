import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/workout_request.dart'; // Убедитесь, что путь верен
import '../models/workout_response.dart'; // Убедитесь, что путь верен

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
    heightCm: 170,
    weightKg: 60,
    age: 18,
    gender: "female",
    goal: "weight_loss",
    menstrualPhase: "luteal",
    bodyFatPercentage: 26.1,
    days: 7,
  );

  Future<void> _fetchWorkoutPlan() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    const String apiUrl = 'http://10.0.2.2:8000/workout-calories/generate'; // Ваш эндпоинт FastAPI

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
        // Успешный ответ
        setState(() {
          _workoutResponse = workoutResponseFromJson(response.body);
        });
      } else {
        // Ошибка сервера или невалидный ответ
        setState(() {
          _errorMessage =
              'Ошибка ${response.statusCode}: ${response.reasonPhrase}\n${response.body}';
        });
      }
    } catch (e) {
      // Ошибка сети (например, сервер недоступен)
      setState(() {
        _errorMessage = 'Не удалось подключиться к серверу: $e';
      });
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
        title: const Text('План Тренировок'),
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
                        Icon(Icons.error_outline, color: Colors.red, size: 60),
                        SizedBox(height: 10),
                        Text(
                          'Ошибка загрузки: $_errorMessage',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _fetchWorkoutPlan,
                          child: const Text('Повторить попытку'),
                        ),
                      ],
                    ),
                  ),
                )
              : _workoutResponse == null
                  ? const Center(child: Text('Нет данных для отображения.'))
                  : _buildWorkoutPlanDisplay(_workoutResponse!),
    );
  }

  Widget _buildWorkoutPlanDisplay(WorkoutResponse response) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInfoCard('Статус', response.status, Colors.green),
          _buildInfoCard('BMI Категория', response.bmiCase, Colors.blue),
          _buildInfoCard('BFP Категория', response.bfpCase, Colors.teal),
          const SizedBox(height: 20),
          const Text(
            'Ваш План Тренировок:',
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
      color: color.withOpacity(0.1),
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
              'День ${dayPlan.day}: ${dayPlan.workoutName}',
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
          Text('Подходы: ${exercise.sets}, Повторения: ${exercise.reps}'),
          Text('Цель: ${exercise.target}'),
          Text('Заметки: ${exercise.notes}'),
          Text('Сожжено калорий: ${exercise.caloriesBurned.toStringAsFixed(2)}'),
          if (exercise.caloriesBurned == 0) // Пример выделения
            Text(' (Значение 0.00 может указывать на placeholder)', style: TextStyle(color: Colors.orange)),
          const SizedBox(height: 8),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';

// class WorkoutsScreen extends StatelessWidget {
//   const WorkoutsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Тренировки'), // Стиль берется из темы
//         // backgroundColor: Colors.deepPurple, // Удаляем
//         // elevation: 0, // Удаляем
//       ),
//       // Убираем Container с градиентом
//       // body: Container(
//       //   decoration: const BoxDecoration(
//       //     gradient: LinearGradient(
//       //       begin: Alignment.topCenter,
//       //       end: Alignment.bottomCenter,
//       //       colors: [
//       //         Color(0xFFE6E6FA),
//       //         Color(0xFFD8BFD8),
//       //       ],
//       //     ),
//       //   ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             _buildWeeklyPlan(context), // Передаем context
//             const SizedBox(height: 20),
//             _buildWorkoutList(context), // Передаем context
//             const SizedBox(height: 20),
//             _buildPerformanceSection(context), // Передаем context
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWeeklyPlan(BuildContext context) {
//     // Card автоматически возьмет стиль из theme.dart
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSectionHeader(context, 'План тренировок на неделю'), // Передаем context
//             const Divider(color: Colors.deepPurple), // Цвет из темы
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceAround,
//               children: List.generate(7, (index) {
//                 final day = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'][index];
//                 return Column(
//                   children: [
//                     Text(day, style: Theme.of(context).textTheme.bodyMedium), // Стиль из темы
//                     const SizedBox(height: 4),
//                     CircleAvatar(
//                       radius: 18,
//                       backgroundColor: index == 0 ? Theme.of(context).primaryColor : Colors.grey[200], // Цвет из темы
//                       child: Text(
//                         (index + 1).toString(),
//                         style: TextStyle(
//                             color: index == 0 ? Colors.white : Colors.black87,
//                             fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   ],
//                 );
//               }),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWorkoutList(BuildContext context) {
//     // Card автоматически возьмет стиль из theme.dart
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSectionHeader(context, 'Предстоящие тренировки'), // Передаем context
//             const Divider(color: Colors.deepPurple), // Цвет из темы
//             _buildWorkoutItem(context, 'Силовая тренировка', 'Завтра, 18:00', Icons.run_circle),
//             _buildWorkoutItem(context, 'Кардио', 'Среда, 07:00', Icons.directions_bike),
//             _buildWorkoutItem(context, 'Растяжка', 'Пятница, 20:00', Icons.self_improvement),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildWorkoutItem(BuildContext context, String title, String time, IconData icon) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: Row(
//         children: [
//           Icon(icon, color: Theme.of(context).iconTheme.color), // Цвет иконки из темы
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   title,
//                   style: Theme.of(context).textTheme.titleMedium, // Стиль из темы
//                 ),
//                 Text(
//                   time,
//                   style: Theme.of(context).textTheme.bodySmall, // Стиль из темы
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: Icon(Icons.check_circle_outline, color: Theme.of(context).hintColor), // Цвет иконки из темы
//             onPressed: () {
//               // TODO: Mark workout as complete
//             },
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildPerformanceSection(BuildContext context) {
//     // Card автоматически возьмет стиль из theme.dart
//     return Card(
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildSectionHeader(context, 'Запись результатов тренировок'), // Передаем context
//             const Divider(color: Colors.deepPurple), // Цвет из темы
//             _buildPerformanceField(context, 'Упражнение', 'Например: Приседания со штангой'),
//             _buildPerformanceField(context, 'Вес (кг)', 'Например: 80'),
//             _buildPerformanceField(context, 'Повторения', 'Например: 10'),
//             _buildPerformanceField(context, 'Подходы', 'Например: 3'),
//             const SizedBox(height: 16),
//             ElevatedButton.icon(
//               icon: Icon(Icons.add, size: Theme.of(context).iconTheme.size), // Размер иконки из темы
//               label: const Text('Добавить запись'), // Стиль из темы
//               onPressed: () {
//                 // TODO: Add performance record
//               },
//               // Стили кнопки берутся из ElevatedButtonThemeData в theme.dart
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildPerformanceField(BuildContext context, String label, String hint) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8),
//       child: TextFormField(
//         decoration: InputDecoration(
//           labelText: label,
//           hintText: hint,
//           // floatingLabelStyle: TextStyle(color: Colors.deepPurple[800]), // Удаляем, берется из темы
//           // border: OutlineInputBorder( // Удаляем, берется из темы
//           //   borderRadius: BorderRadius.circular(8),
//           //   borderSide: BorderSide(color: Colors.deepPurple),
//           // ),
//           // focusedBorder: OutlineInputBorder( // Удаляем, берется из темы
//           //   borderSide: BorderSide(color: Colors.deepPurple, width: 2),
//           // ),
//           // Остальные стили берутся из InputDecorationTheme в theme.dart
//         ),
//       ),
//     );
//   }

//   Widget _buildSectionHeader(BuildContext context, String title) {
//     return Row(
//       children: [
//         Icon(Icons.sports_gymnastics, color: Theme.of(context).iconTheme.color), // Цвет иконки из темы
//         const SizedBox(width: 8),
//         Text(
//           title,
//           style: Theme.of(context).textTheme.titleLarge, // Стиль из темы
//         ),
//       ],
//     );
//   }
// }