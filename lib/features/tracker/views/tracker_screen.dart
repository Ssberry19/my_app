import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
// import 'package:provider/provider.dart';
// import 'package:my_app/features/diet/models/diet_plan_provider.dart';
// import 'package:my_app/features/workouts/models/workout_plan_provider.dart';
import 'package:my_app/features/profile/views/edit_profile_screen.dart';

// Обновленная модель данных для трекера, чтобы хранить детали для каждой тренировки/приема пищи
class DailyTrackerData {
  final DateTime date;
  final int workoutsCompleted;
  final int caloriesBurned;
  final int mealsEaten;
  final int caloriesConsumed;
  final int totalDailyCalories;
  final int totalDailyMeals;

  // Дополнительные поля для отслеживания состояния отдельных активностей
  final List<bool> workoutStatus; // Например, [true, false] для двух тренировок
  final Map<String, bool> mealStatus; // {'Breakfast': true, 'Lunch': false}

  DailyTrackerData({
    required this.date,
    this.workoutsCompleted = 0,
    this.caloriesBurned = 0,
    this.mealsEaten = 0,
    this.caloriesConsumed = 0,
    this.totalDailyCalories = 0,
    this.totalDailyMeals = 4,
    List<bool>? workoutStatus,
    Map<String, bool>? mealStatus,
  }) : this.workoutStatus = workoutStatus ?? [],
       this.mealStatus = mealStatus ?? {};

  // Метод для создания копии с измененными данными
  DailyTrackerData copyWith({
    int? workoutsCompleted,
    int? caloriesBurned,
    int? mealsEaten,
    int? caloriesConsumed,
    List<bool>? workoutStatus,
    Map<String, bool>? mealStatus,
  }) {
    return DailyTrackerData(
      date: this.date,
      workoutsCompleted: workoutsCompleted ?? this.workoutsCompleted,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      mealsEaten: mealsEaten ?? this.mealsEaten,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      totalDailyCalories: this.totalDailyCalories,
      totalDailyMeals: this.totalDailyMeals,
      workoutStatus: workoutStatus ?? this.workoutStatus,
      mealStatus: mealStatus ?? this.mealStatus,
    );
  }
}

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  DateTime? _selectedWeekDay; // Для выбора дня в еженедельном трекере
  int _currentWeekOffset = 0; // 0 = текущая неделя, -1 = прошлая неделя, и т.д.

  // Хранилище данных для имитации (в реальном приложении это будет Provider/Bloc/Backend)
  final Map<DateTime, DailyTrackerData> _mockDailyData = {};

  @override
  void initState() {
    super.initState();
    _selectedWeekDay = DateTime.now();
    _generateMockDataForCurrentWeek(); // Генерируем данные для текущей недели при запуске
  }

  // Генерация имитированных данных для текущей недели и соседних недель
  void _generateMockDataForCurrentWeek() {
    for (int offset = -1; offset <= 1; offset++) {
      List<DailyTrackerData> weekData = _getDailyTrackerDataForWeek(offset);
      for (var data in weekData) {
        DateTime normalizedDate = DateTime(data.date.year, data.date.month, data.date.day);
        if (!_mockDailyData.containsKey(normalizedDate)) {
          _mockDailyData[normalizedDate] = data;
        }
      }
    }
    DateTime normalizedSelectedDay = DateTime(_selectedWeekDay!.year, _selectedWeekDay!.month, _selectedWeekDay!.day);
    if (!_mockDailyData.containsKey(normalizedSelectedDay)) {
      _mockDailyData[normalizedSelectedDay] = _getDailyTrackerDataForDate(normalizedSelectedDay);
    }
  }

  // Пример получения данных за неделю
  List<DailyTrackerData> _getDailyTrackerDataForWeek(int weekOffset) {
    List<DailyTrackerData> weekData = [];
    DateTime now = DateTime.now();
    DateTime startOfWeek = _getStartOfWeek(now.add(Duration(days: weekOffset * 7)));

    for (int i = 0; i < 7; i++) {
      DateTime day = startOfWeek.add(Duration(days: i));
      DateTime normalizedDay = DateTime(day.year, day.month, day.day);

      if (_mockDailyData.containsKey(normalizedDay)) {
        weekData.add(_mockDailyData[normalizedDay]!);
      } else {
        // Имитируем данные, если их нет
        List<bool> workoutStatus = List.generate(5, (index) => false); // 5 тренировок по умолчанию
        if (normalizedDay.day % 3 == 0) workoutStatus[0] = true; // Первая тренировка выполнена
        if (normalizedDay.day % 5 == 0) workoutStatus[1] = true; // Вторая тренировка выполнена

        Map<String, bool> mealStatus = {
          'Breakfast': normalizedDay.day % 2 == 0,
          'Lunch': normalizedDay.day % 2 != 0,
          'Dinner': normalizedDay.day % 2 == 0,
          'Snack': normalizedDay.day % 4 == 0,
        };

        DailyTrackerData data = DailyTrackerData(
          date: normalizedDay,
          workoutsCompleted: workoutStatus.where((status) => status).length,
          caloriesBurned: workoutStatus.where((status) => status).length * 300, // Пример: 300 ккал за каждую тренировку
          mealsEaten: mealStatus.values.where((status) => status).length,
          caloriesConsumed: mealStatus.values.where((status) => status).length * 500, // Пример: 500 ккал за каждый прием пищи
          totalDailyCalories: 2200,
          totalDailyMeals: 4,
          workoutStatus: workoutStatus,
          mealStatus: mealStatus,
        );
        _mockDailyData[normalizedDay] = data;
        weekData.add(data);
      }
    }
    return weekData;
  }

  DailyTrackerData _getDailyTrackerDataForDate(DateTime date) {
    DateTime normalizedDate = DateTime(date.year, date.month, date.day);
    if (_mockDailyData.containsKey(normalizedDate)) {
      return _mockDailyData[normalizedDate]!;
    } else {
      List<bool> workoutStatus = List.generate(5, (index) => false); // 5 тренировок по умолчанию
      Map<String, bool> mealStatus = {
        'Breakfast': false,
        'Lunch': false,
        'Dinner': false,
        'Snack': false,
      };

      DailyTrackerData newData = DailyTrackerData(
        date: normalizedDate,
        workoutsCompleted: 0,
        caloriesBurned: 0,
        mealsEaten: 0,
        caloriesConsumed: 0,
        totalDailyCalories: 2200,
        totalDailyMeals: 4,
        workoutStatus: workoutStatus,
        mealStatus: mealStatus,
      );
      _mockDailyData[normalizedDate] = newData;
      return newData;
    }
  }

  DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracker'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildWeeklyActivityOverview(context),
            const SizedBox(height: 20),
            if (_selectedWeekDay != null)
              _buildDailyDetailsWidget(context, _getDailyTrackerDataForDate(_selectedWeekDay!)),
            const SizedBox(height: 20),
            _buildWeightProgressChart(),
            const SizedBox(height: 20),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyActivityOverview(BuildContext context) {
    List<DailyTrackerData> weekData = _getDailyTrackerDataForWeek(_currentWeekOffset);
    DateTime startOfWeek = weekData.isNotEmpty ? weekData.first.date : DateTime.now();
    DateTime endOfWeek = weekData.isNotEmpty ? weekData.last.date : DateTime.now();

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionHeader(context, 'Weekly Activity'),
            const Divider(color: Colors.deepPurple),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back_ios),
                  onPressed: () {
                    setState(() {
                      _currentWeekOffset--;
                      _selectedWeekDay = _getStartOfWeek(DateTime.now().add(Duration(days: _currentWeekOffset * 7)));
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    '${_getMonthAbbreviation(startOfWeek.month)} ${startOfWeek.day} - ${_getMonthAbbreviation(endOfWeek.month)} ${endOfWeek.day}',
                    style: Theme.of(context).textTheme.titleMedium,
                    textAlign: TextAlign.center,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward_ios),
                  onPressed: () {
                    setState(() {
                      _currentWeekOffset++;
                      _selectedWeekDay = _getStartOfWeek(DateTime.now().add(Duration(days: _currentWeekOffset * 7)));
                    });
                  },
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: weekData.map((data) {
                bool isSelected = _selectedWeekDay != null && isSameDay(_selectedWeekDay!, data.date);
                return Expanded(
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedWeekDay = data.date;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 2),
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                      decoration: BoxDecoration(
                        color: isSelected ? Theme.of(context).primaryColor.withOpacity(0.2) : Colors.transparent,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _getWeekdayAbbreviation(data.date.weekday),
                            style: Theme.of(context).textTheme.bodySmall!.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Text(
                            '${data.date.day}',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyDetailsWidget(BuildContext context, DailyTrackerData data) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionHeader(context, 'Details for ${_getMonthAbbreviation(data.date.month)} ${data.date.day}, ${data.date.year}'),
            const Divider(color: Colors.deepPurple),
            _buildDetailRow(context, Icons.fitness_center, 'Workouts Completed', '${data.workoutsCompleted}'),
            _buildDetailRow(context, Icons.local_fire_department, 'Calories Burned', '${data.caloriesBurned} kcal', Colors.red),
            const Divider(),
            _buildDetailRow(context, Icons.restaurant_menu, 'Meals Eaten', '${data.mealsEaten}/${data.totalDailyMeals}'),
            _buildDetailRow(context, Icons.fastfood, 'Calories Consumed', '${data.caloriesConsumed}/${data.totalDailyCalories} kcal', Colors.orange),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => _showAddNotesDialog(context, data),
                icon: const Icon(Icons.add_task),
                label: const Text('ADD NOTES'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddNotesDialog(BuildContext context, DailyTrackerData currentData) {
    // Создаем копии для редактирования в диалоге, чтобы не изменять исходные данные напрямую до сохранения
    List<bool> tempWorkoutStatus = List.from(currentData.workoutStatus);
    // Убедимся, что у нас есть 5 элементов в списке, если их меньше
    while (tempWorkoutStatus.length < 5) { // Добавим до 5 тренировок
      tempWorkoutStatus.add(false);
    }
    Map<String, bool> tempMealStatus = Map.from(currentData.mealStatus);
    
    // Инициализируем отсутствующие приемы пищи
    final List<String> allMealNames = ['Breakfast', 'Lunch', 'Dinner', 'Snack'];
    for (var mealName in allMealNames) {
      if (!tempMealStatus.containsKey(mealName)) {
        tempMealStatus[mealName] = false;
      }
    }


    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStateDialog) {
            return AlertDialog(
              title: Text('Add Notes for ${_getMonthAbbreviation(currentData.date.month)} ${currentData.date.day}'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Workouts:', style: Theme.of(context).textTheme.titleMedium),
                    // Генерируем 5 чекбоксов для тренировок
                    ...List.generate(5, (index) {
                      return CheckboxListTile(
                        title: Text('Workout ${index + 1}'),
                        value: tempWorkoutStatus[index],
                        onChanged: (bool? value) {
                          setStateDialog(() {
                            tempWorkoutStatus[index] = value!;
                          });
                        },
                      );
                    }),
                    
                    const SizedBox(height: 20),
                    Text('Meals:', style: Theme.of(context).textTheme.titleMedium),
                    ...allMealNames.map((mealName) { // Используем allMealNames для гарантированного порядка
                      return CheckboxListTile(
                        title: Text(mealName),
                        value: tempMealStatus[mealName],
                        onChanged: (bool? value) {
                          setStateDialog(() {
                            tempMealStatus[mealName] = value!;
                          });
                        },
                      );
                    }).toList(),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // Обновляем данные в _mockDailyData
                    setState(() {
                      int newWorkoutsCompleted = tempWorkoutStatus.where((status) => status).length;
                      int newCaloriesBurned = newWorkoutsCompleted * 300; // Пример: 300 ккал за каждую выполненную тренировку
                      
                      int newMealsEaten = tempMealStatus.values.where((status) => status).length;
                      // Пример расчета калорий: 500 ккал за каждый отмеченный прием пищи
                      int newCaloriesConsumed = newMealsEaten * 500; 

                      _mockDailyData[DateTime(currentData.date.year, currentData.date.month, currentData.date.day)] = currentData.copyWith(
                        workoutsCompleted: newWorkoutsCompleted,
                        caloriesBurned: newCaloriesBurned,
                        mealsEaten: newMealsEaten,
                        caloriesConsumed: newCaloriesConsumed,
                        workoutStatus: tempWorkoutStatus,
                        mealStatus: tempMealStatus,
                      );
                    });
                    Navigator.of(dialogContext).pop();
                  },
                  child: const Text('Save'),
                ),
              ],
            );
          },
        );
      },
    );
  }


  Widget _buildDetailRow(BuildContext context, IconData icon, String label, String value, [Color? iconColor]) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: iconColor ?? Theme.of(context).primaryColor, size: 24),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }


  String _getWeekdayAbbreviation(int weekday) {
    switch (weekday) {
      case 1: return 'Mon';
      case 2: return 'Tue';
      case 3: return 'Wed';
      case 4: return 'Thu';
      case 5: return 'Fri';
      case 6: return 'Sat';
      case 7: return 'Sun';
      default: return '';
    }
  }

   Widget _buildWeightProgressChart() {
    // Пример данных (замените на данные из бэкенда)
    final weightData = [
      {'date': DateTime(2024, 1, 11), 'weight': 65.5},
      {'date': DateTime(2024, 1, 25), 'weight': 71.0},
      {'date': DateTime(2024, 2, 15), 'weight': 76.0},
      {'date': DateTime(2024, 3, 1), 'weight': 73.0},
      {'date': DateTime(2024, 3, 27), 'weight': 70.3},
    ];

    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(25),
        child: Column(
          children: [
            Text('Weight Trend',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple[800])),
            const SizedBox(height: 20),
            SizedBox(
              height: 300,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      axisNameWidget: Text('Date',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[800])),
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final index = value.toInt();
                          if (index >= 0 && index < weightData.length) {
                            final date = weightData[index]['date'] as DateTime;
                            return Padding(
                              padding: const EdgeInsets.only(top: 8.0),
                              child: Text(
                                '${date.day} ${_getMonthAbbreviation(date.month)}',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Colors.deepPurple[800],
                                ),
                              ),
                            );
                          }
                          return const Text('');
                        },
                        interval: 1,
                        reservedSize: 40,
                      ),
                    ),
                    leftTitles: AxisTitles(
                      axisNameWidget: Text('Weight (kg)',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple[800])),
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) => Padding(
                          padding: const EdgeInsets.only(right: 8.0, left: 10.0),
                          child: Text(
                            '${value.toInt()}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.deepPurple[800],
                            ),
                          ),
                        ),
                        interval: _calculateYInterval(weightData),
                        reservedSize: 40,
                      ),
                    ),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: weightData.asMap().entries.map((entry) {
                        final index = entry.key.toDouble();
                        final weight = entry.value['weight'] as double;
                        return FlSpot(index, weight);
                      }).toList(),
                      color: Colors.deepPurple,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(show: false),
                    ),
                  ],
                  minX: 0,
                  maxX: weightData.length.toDouble() - 1,
                  minY: weightData.map((e) => e['weight'] as double).reduce(min) - 2,
                  maxY: weightData.map((e) => e['weight'] as double).reduce(max) + 2,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateYInterval(List<dynamic> data) {
    final minWeight = data.map((e) => e['weight'] as double).reduce(min);
    final maxWeight = data.map((e) => e['weight'] as double).reduce(max);
    final range = maxWeight - minWeight;

    final double roughStep = range / 5;
    final int magnitude = pow(10, (roughStep.floor().toString().length - 1)).toInt();
    final double step = (roughStep / magnitude).ceilToDouble() * magnitude;

    return step;
  }

  String _getMonthAbbreviation(int month) {
    return [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ][month - 1];
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Icon(
          Icons.insights,
          color: Theme.of(context).iconTheme.color,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ],
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Column(
      children: [
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.calendar_month, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Update Menstrual Cycle',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EditProfileScreen()),
              );
            },
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(Icons.monitor_weight, color: Theme.of(context).primaryColor),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Text(
                      'Update Weight',
                      style: Theme.of(context).textTheme.bodyLarge!.copyWith(fontWeight: FontWeight.w500),
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[600]),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}