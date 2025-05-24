import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:math';
import 'package:my_app/features/diet/views/diet_screen.dart';
import 'package:my_app/features/workouts/views/workouts_screen.dart';
import 'package:my_app/features/tracker/views/tracker_screen.dart';

class HomeScreen2 extends StatefulWidget {
  const HomeScreen2({super.key});

  @override
  State<HomeScreen2> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Главная', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFADD8E6), // Светло-голубой
              Color(0xFF9370DB), // Средний фиолетовый (MediumPurple)
              Color(0xFF6A5ACD),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildGreeting(),
              const SizedBox(height: 20),
              _buildMetricsRow(),
              const SizedBox(height: 20),
              _buildQuickActions(),
              const SizedBox(height: 20),
              _buildWeightProgressChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGreeting() {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, top: 8),
      child:Text(
        'Welcome, <Соня>!',
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.deepPurple[800],
        ),
      )
    );
  }

  Widget _buildMetricsRow() {
    return Row(
      children: [
        Expanded(
          child: _buildMetricCard(
            title: 'Калории сегодня',
            value: '1200/2000',
            progress: 0.6,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _buildMetricCard(
            title: 'Тренировки',
            value: '2/3 выполнено',
            progress: 0.66,
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({required String title, required String value, required double progress}) {
  return Card(
    // ignore: deprecated_member_use
    color: Colors.white.withOpacity(0.9),
    elevation: 4,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(15), // Закрываем параметр shape
    ), // <-- Добавлена закрывающая скобка для shape
    child: Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              color: Colors.deepPurple[800],
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.deepPurple[100],
            color: Colors.deepPurple,
            minHeight: 8,
            borderRadius: BorderRadius.circular(4),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: Colors.deepPurple[800],
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
        ],
      ),
    ),
  ); // <-- Закрывающая скобка для Card
}

  Widget _buildQuickActions() {
    return Card(
      color: Colors.white,
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildActionButton(
              icon: Icons.restaurant,
              label: 'Nearest meal time',
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder: (_, __, ___) => DietScreen(),
                    transitionsBuilder: (_, a, __, c) => 
                      FadeTransition(opacity: a, child: c),
                  ),
                );
              },
            ),
            const Divider(color: Colors.deepPurple),
            _buildActionButton(
              icon: Icons.fitness_center,
              label: 'Start training',
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder: (_, __, ___) => WorkoutsScreen(),
                    transitionsBuilder: (_, a, __, c) => 
                      FadeTransition(opacity: a, child: c),
                  ),
                );
              },
            ),
            const Divider(color: Colors.deepPurple),
            _buildActionButton(
              icon: Icons.insights,
              label: 'View progress',
              onPressed: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    transitionDuration: const Duration(milliseconds: 500),
                    pageBuilder: (_, __, ___) => (TrackerScreen()),
                    transitionsBuilder: (_, a, __, c) => 
                      FadeTransition(opacity: a, child: c),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required VoidCallback onPressed}) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(label, style: TextStyle(
        color: Colors.deepPurple[800],
        fontSize: 16)),
      trailing: Icon(Icons.arrow_forward_ios, 
        size: 16, 
        color: Colors.deepPurple[300]),
      onTap: onPressed,
    );
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
              height: 300, // Увеличена высота для лучшего отображения
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
                        reservedSize: 40, // Место для подписей дат
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
                          padding: const EdgeInsets.only(right: 8.0, left: 10.0), // Увеличено с 8 до 12
                          child: Text(
                            '${value.toInt()}',
                            style: TextStyle(
                              fontSize: 11, // Увеличен размер шрифта
                              color: Colors.deepPurple[800],
                            ),
                          ),
                        ),
                        interval: _calculateYInterval(weightData), // Автоподбор интервала
                        reservedSize: 40, // Место для подписей кг
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

  // Автоподбор интервала для оси Y
  double _calculateYInterval(List<dynamic> data) {
  final minWeight = data.map((e) => e['weight'] as double).reduce(min);
  final maxWeight = data.map((e) => e['weight'] as double).reduce(max);
  final range = maxWeight - minWeight;
  
  // Алгоритм "красивых" интервалов
  final double roughStep = range / 5;
  final int magnitude = pow(10, (roughStep.floor().toString().length - 1)).toInt();
  final double step = (roughStep / magnitude).ceilToDouble() * magnitude;

  return step;
}

  // Сокращение названий месяцев
  String _getMonthAbbreviation(int month) {
    return [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ][month - 1];
  }

}
// import 'package:flutter/material.dart';
// import '../widgets/metric_card.dart';
// import '../widgets/action_button.dart';
// import '../widgets/progress_chart.dart';
// import '../widgets/recommendation_card.dart';

// class HomeScreen2 extends StatelessWidget {
//   const HomeScreen2({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Главная'),
//         actions: [
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             onPressed: () {},
//           ),
//         ],
//       ),
//       body: SingleChildScrollView(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             // Добавьте здесь содержимое главной страницы
//             const MetricCard(
//               title: 'Активность',
//               value: '85%',
//               progress: 0.85,
//             ),
//             const SizedBox(height: 20),
//             const ActionButton(
//               icon: Icons.add,
//               label: 'Добавить активность',
//             ),
//             const SizedBox(height: 20),
//             const ProgressChart(),
//             const SizedBox(height: 20),
//             const RecommendationCard(
//               text: 'Рекомендуем вечернюю прогулку',
//               emoji: '🚶♀️',
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// } 
