import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'package:my_app/features/diet/views/diet_screen.dart';
import 'package:my_app/features/workouts/views/workouts_screen.dart';
import 'package:my_app/features/tracker/views/tracker_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // Mock data for demonstration
  final int _caloriesToday = 1800;
  final int _targetCalories = 2500;
  final int _completedWorkouts = 3;
  final int _totalWorkouts = 5;
  final int _waterIntakeMl = 1500;
  final int _waterTargetMl = 2000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'), 
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome!',
              style: Theme.of(context).textTheme.headlineSmall!.copyWith(
                color: Theme.of(context).primaryColor,
              ), // Стиль из темы
            ),
            const SizedBox(height: 16),
            _buildSectionCard(
              context,
              title: 'Statistics',
              children: [
                _buildMetricRow(
                  context,
                  'Calories Today',
                  '$_caloriesToday / $_targetCalories kcal',
                  Icons.local_fire_department,
                ),
                _buildMetricRow(
                  context,
                  'Workouts',
                  '$_completedWorkouts / $_totalWorkouts completed',
                  Icons.fitness_center,
                ),
                _buildMetricRow(
                  context,
                  'Water',
                  '${_waterIntakeMl / 1000} / ${_waterTargetMl / 1000} л',
                  Icons.water_drop,
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              context,
              title: 'Progress',
              children: [
                _buildProgressChart(context),
                const SizedBox(height: 16),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TrackerScreen(),
                        ),
                      );
                    },
                    child: const Text('View more details'), // Стиль из темы
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildSectionCard(
              context,
              title: 'Recommendations',
              children: [
                _buildRecommendationItem(
                  context,
                  'Try a new recipe from the "Diet" section!',
                  Icons.restaurant_menu,
                ),
                _buildRecommendationItem(
                  context,
                  'Add a new workout to your plan!',
                  Icons.directions_run,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const DietScreen(),
                        ),
                      );
                    },
                    child: const Text('More recommendations'), // Стиль из темы
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildActionButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionCard(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    // Card автоматически возьмет стиль из theme.dart
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
              ).textTheme.titleLarge, // Использование стиля из темы
            ),
            const Divider(color: Colors.deepPurple), // Цвет из темы
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
          ), // Цвет иконки из темы
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge, // Стиль из темы
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontWeight: FontWeight.w600,
              color: Theme.of(context).primaryColor,
            ), // Стиль и цвет из темы
          ),
        ],
      ),
    );
  }

  Widget _buildProgressChart(BuildContext context) {
    return SizedBox(
      height: 200,
      child: LineChart(
        LineChartData(
          gridData: FlGridData(show: false),
          titlesData: FlTitlesData(show: false),
          borderData: FlBorderData(
            show: true,
            border: Border.all(
              color: Colors.deepPurple.shade100,
              width: 1,
            ), // Цвет из темы
          ),
          lineBarsData: [
            LineChartBarData(
              spots: const [
                FlSpot(0, 3),
                FlSpot(1, 2),
                FlSpot(2, 5),
                FlSpot(3, 3),
                FlSpot(4, 4.2),
                FlSpot(5, 3.8),
                FlSpot(6, 5),
              ],
              isCurved: true,
              color: Theme.of(context).primaryColor, // Цвет из темы
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: FlDotData(show: false),
              belowBarData: BarAreaData(
                show: true,
                // ignore: deprecated_member_use
                color: Theme.of(
                  context,
                ).primaryColor, // Цвет из темы
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecommendationItem(
    BuildContext context,
    String text,
    IconData icon,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            color: Theme.of(context).hintColor,
          ), // Использование hintColor для разнообразия
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium, // Стиль из темы
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildActionButton(context, 'Diet', Icons.restaurant_menu, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const DietScreen()),
          );
        }),
        _buildActionButton(context, 'Workouts', Icons.fitness_center, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const WorkoutPlanPage()),
          );
        }),
        _buildActionButton(context, 'Tracker', Icons.show_chart, () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const TrackerScreen()),
          );
        }),
      ],
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    VoidCallback onPressed,
  ) {
    return Column(
      children: [
        FloatingActionButton(
          heroTag: label, // Добавляем heroTag для избежания ошибок
          onPressed: onPressed,
          mini: true,
          // Стили берутся из floatingActionButtonTheme в theme.dart
          child: Icon(icon),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall!.copyWith(
            fontWeight: FontWeight.w500,
            color: Theme.of(context).primaryColor,
          ), // Стиль и цвет из темы
        ),
      ],
    );
  }
}
