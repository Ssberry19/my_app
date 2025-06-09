import 'package:flutter/material.dart';
// import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';
import 'package:my_app/features/diet/views/diet_screen.dart';
import 'package:my_app/features/workouts/views/workouts_screen.dart';
// import 'package:my_app/features/tracker/views/tracker_screen.dart';
import 'package:my_app/features/diet/models/diet_plan_provider.dart';
import 'package:my_app/features/workouts/models/workout_plan_provider.dart';
import 'package:my_app/features/diet/models/diet_response.dart';
import 'package:my_app/features/workouts/models/workout_response.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mock data for demonstration
  final int _waterIntakeMl = 1500;
  final int _waterTargetMl = 2000;
  final int _completedWorkouts = 3; // Оставим для демонстрации, если понадобится в будущем
  final int _totalWorkouts = 5; // Оставим для демонстрации, если понадобится в будущем

  // Примерное время для приемов пищи
  final Map<String, String> _mealTimes = {
    'Breakfast': '8:00 AM',
    'Lunch': '1:00 PM',
    'Dinner': '7:00 PM',
    'Snack': '11:00 AM', // Добавим для примера, если есть снеки
  };


  @override
  Widget build(BuildContext context) {
    final dietProvider = Provider.of<DietPlanProvider>(context);
    final workoutProvider = Provider.of<WorkoutPlanProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Welcome Card
            _buildSectionCard(
              context,
              title: 'Welcome!',
              children: [
                Text(
                  'Your journey to a healthier you starts here!',
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontStyle: FontStyle.italic,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10), // Уменьшено расстояние

            // Быстрый обзор планов
            _buildPlansOverview(context, dietProvider, workoutProvider),
            const SizedBox(height: 10), // Уменьшено расстояние

            _buildSectionCard(
              context,
              title: 'Today\'s Nutrition',
              children: [
                if (dietProvider.dietResponse != null)
                  _buildNutritionOverview(context, dietProvider.dietResponse!)
                else
                  const Text('No diet data available'),
                const SizedBox(height: 8),
                _buildWaterIntakeProgress(context),
              ],
            ),
            const SizedBox(height: 10), // Уменьшено расстояние

            _buildSectionCard(
              context,
              title: 'Workout Progress',
              children: [
                if (workoutProvider.workoutResponse != null)
                  _buildWorkoutStats(context, workoutProvider.workoutResponse!)
                else
                  const Text('No workout data available'),
                  _buildMetricRow(
                  context,
                  'Workouts Completed',
                  '$_completedWorkouts / $_totalWorkouts',
                  Icons.fitness_center,
                ),
                _buildMetricRow( // Новое расположение
                  context,
                  'Remaining time to update plans', // Новое название
                  '7 days', // Примерное значение
                  Icons.update, // Подходящая иконка
                ),
                
              ],
            ),
            const SizedBox(height: 10), // Уменьшено расстояние

            // Виджет с ближайшими приемами пищи
            if (dietProvider.dietResponse != null)
              _buildNextMealsWidget(context, dietProvider.dietResponse!),
            const SizedBox(height: 10), // Уменьшено расстояние

            // Виджет с ближайшими тренировками
            if (workoutProvider.workoutResponse != null)
              _buildNextWorkoutsWidget(context, workoutProvider.workoutResponse!),
          ],
        ),
      ),
    );
  }

  Widget _buildPlansOverview(BuildContext context, DietPlanProvider dietProvider, WorkoutPlanProvider workoutProvider) {
    return Row(
      children: [
        Expanded(
          child: _buildPlanStatusCard(
            context,
            'Diet Plan',
            dietProvider.dietResponse != null ? 'Active' : 'Not set',
            // Icons.restaurant_menu, // Иконка удалена
            dietProvider.dietResponse != null ? Colors.green : Colors.orange,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const DietScreen())),
          ),
        ),
        const SizedBox(width: 5), // Уменьшено расстояние до 5
        Expanded(
          child: _buildPlanStatusCard(
            context,
            'Workout', // Разделено на две строки
            workoutProvider.workoutResponse != null ? 'Active' : 'Not set',
            // Icons.fitness_center, // Иконка удалена
            workoutProvider.workoutResponse != null ? Colors.green : Colors.orange,
            () => Navigator.push(context, MaterialPageRoute(builder: (context) => const WorkoutPlanPage())),
          ),
        ),
      ],
    );
  }

  Widget _buildPlanStatusCard(BuildContext context, String title, String status, Color statusColor, VoidCallback onTap) { // Убран параметр IconData icon
    return InkWell(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Убрана строка с Icon
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center, // Выравнивание текста по центру для многострочных заголовков
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: statusColor,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    status,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildNutritionOverview(BuildContext context, DietResponse dietResponse) {
    final macros = dietResponse.macronutrientDistribution;
    return Column(
      children: [
        Text(
          'Daily Goal: ${dietResponse.dailyCalories} kcal',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).primaryColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildMacroCircle(context, 'Protein', macros.proteinPercentage, Icons.egg),
            _buildMacroCircle(context, 'Carbs', macros.carbPercentage, Icons.rice_bowl),
            _buildMacroCircle(context, 'Fat', macros.fatPercentage, Icons.oil_barrel),
          ],
        ),
      ],
    );
  }

  Widget _buildMacroCircle(BuildContext context, String label, int value, IconData icon) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            SizedBox(
              width: 60,
              height: 60,
              child: CircularProgressIndicator(
                value: value / 100,
                strokeWidth: 8,
                color: Theme.of(context).primaryColor,
                backgroundColor: Theme.of(context).primaryColor,
              ),
            ),
            Center(
              child: Icon(icon, size: 24, color: Theme.of(context).primaryColor),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('$value%', style: Theme.of(context).textTheme.bodyMedium),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildWaterIntakeProgress(BuildContext context) {
    final percentage = _waterIntakeMl / _waterTargetMl;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Water Intake',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            Text(
              '${_waterIntakeMl}ml / ${_waterTargetMl}ml',
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: percentage,
          minHeight: 10,
          borderRadius: BorderRadius.circular(5),
          color: Colors.blue[300],
          backgroundColor: Colors.blue[100],
        ),
      ],
    );
  }

  Widget _buildWorkoutStats(BuildContext context, WorkoutResponse response) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatItem(context, 'BMI', response.bmiCase, Icons.accessibility),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatItem(context, 'BFP', response.bfpCase, Icons.monitor_weight),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 24, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Flexible(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: Theme.of(context).textTheme.bodyMedium),
              Text(
                value,
                style: Theme.of(context).textTheme.titleMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNextMealsWidget(BuildContext context, DietResponse dietResponse) {
    final currentDay = dietResponse.plan.isNotEmpty ? dietResponse.plan[0] : null;

    if (currentDay == null || currentDay.meals.isEmpty) {
      return const SizedBox();
    }

    return _buildSectionCard(
      context,
      title: 'Next Meals',
      children: [
        ...currentDay.meals.take(3).map((meal) => _buildMealItem(context, meal)),
      ],
    );
  }

  Widget _buildMealItem(BuildContext context, Meal meal) {
    String mealTime = _mealTimes[meal.name] ?? ''; // Получаем время из карты
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.restaurant, size: 24, color: Theme.of(context).primaryColor),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '${meal.calories} kcal',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ),
          if (mealTime.isNotEmpty) // Отображаем чип, если время найдено
            Chip(
              label: Text(mealTime),
              visualDensity: VisualDensity.compact,
            ),
        ],
      ),
    );
  }

  Widget _buildNextWorkoutsWidget(BuildContext context, WorkoutResponse response) {
    final nextWorkout = response.workoutPlan.isNotEmpty ? response.workoutPlan[0] : null;

    if (nextWorkout == null) {
      return const SizedBox();
    }

    return _buildSectionCard(
      context,
      title: 'Next Workout',
      children: [
        ListTile(
          leading: Icon(
            Icons.fitness_center,
            color: Theme.of(context).primaryColor,
          ),
          title: Text(
            nextWorkout.workoutName,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          subtitle: Text(
            nextWorkout.description,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          trailing: Chip(
            label: Text('Day ${nextWorkout.day}'),
            visualDensity: VisualDensity.compact,
          ),
        ),
        if (nextWorkout.workoutName != "Rest or Active Recovery")
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, bottom: 8),
            child: Text(
              '${nextWorkout.exercises.length} exercises',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
      ],
    );
  }

  Widget _buildSectionCard(
      BuildContext context, {
        required String title,
        required List<Widget> children,
      }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(
                context,
              ).textTheme.titleLarge,
            ),
            const Divider(color: Colors.deepPurple),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(
      BuildContext context,
      String label,
      String value,
      IconData icon,
      ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).iconTheme.color,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).primaryColor,
                ),
          ),
        ],
      ),
    );
  }
}