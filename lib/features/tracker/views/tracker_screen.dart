import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Предполагается, что fl_chart настроен на использование тематических цветов или вы его настраиваете вручную
import 'package:table_calendar/table_calendar.dart'; // Если используется
import 'dart:math';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tracker'), // Стиль берется из темы
        // backgroundColor: Colors.deepPurple, // Удаляем
        // elevation: 0, // Удаляем
      ),
      // Убираем Container с градиентом
      // body: Container(
      //   decoration: const BoxDecoration(
      //     gradient: LinearGradient(
      //       begin: Alignment.topCenter,
      //       end: Alignment.bottomCenter,
      //       colors: [
      //         Color(0xFFE6E6FA),
      //         Color(0xFFD8BFD8),
      //       ],
      //     ),
      //   ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildCalendarSection(context), // Передаем context
            const SizedBox(height: 20),
            _buildWeightProgressChart(), 
            const SizedBox(height: 20),
            _buildNotesSection(context), // Передаем context
            const SizedBox(height: 20),
            _buildSymptomsMonitor(context), // Передаем context
          ],
        ),
      ),
    );
  }

  Widget _buildCalendarSection(BuildContext context) {
    // Card автоматически возьмет стиль из theme.dart
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionHeader(context, 'Calendar'), // Передаем context
            const Divider(color: Colors.deepPurple), // Цвет из темы
            TableCalendar(
              firstDay: DateTime.utc(2020, 1, 1),
              lastDay: DateTime.utc(2030, 12, 31),
              focusedDay: _focusedDay,
              calendarFormat: _calendarFormat,
              selectedDayPredicate: (day) {
                return isSameDay(_selectedDay, day);
              },
              onDaySelected: (selectedDay, focusedDay) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay; // update `_focusedDay` here as well
                });
              },
              onFormatChanged: (format) {
                if (_calendarFormat != format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                }
              },
              onPageChanged: (focusedDay) {
                _focusedDay = focusedDay;
              },
              // Календарь также может использовать тематические стили
              calendarStyle: CalendarStyle(
                todayDecoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Theme.of(
                    context,
                  ).primaryColor, // Цвет из темы
                  shape: BoxShape.circle,
                ),
                selectedDecoration: BoxDecoration(
                  color: Theme.of(context).primaryColor, // Цвет из темы
                  shape: BoxShape.circle,
                ),
                weekendTextStyle: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                ), // Цвет из темы
                // outsideDaysTextStyle: TextStyle(color: Colors.grey.shade400),
                defaultTextStyle: Theme.of(context).textTheme.bodyMedium!,
              ),
              headerStyle: HeaderStyle(
                formatButtonVisible: false,
                titleCentered: true,
                titleTextStyle: Theme.of(context).textTheme.titleMedium!
                    .copyWith(
                      color: Theme.of(context).primaryColor,
                    ), // Стиль и цвет из темы
                // leftMakersAutoResizing: true, // Исправление
                // rightMakersAutoResizing: true, // Исправление
              ),
            ),
          ],
        ),
      ),
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

  Widget _buildNotesSection(BuildContext context) {
    // Card автоматически возьмет стиль из theme.dart
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionHeader(context, 'Notes'), // Передаем context
            const Divider(color: Colors.deepPurple), // Цвет из темы
            TextFormField(
              maxLines: 4,
              decoration: const InputDecoration(
                hintText: 'Add your notes...',
                // Остальные стили берутся из InputDecorationTheme в theme.dart
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // TODO: Save notes
              },
              // Стиль берется из ElevatedButtonThemeData в theme.dart
              child: const Text('Save note'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomsMonitor(BuildContext context) {
    // Card автоматически возьмет стиль из theme.dart
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionHeader(
              context,
              'Symptom tracking',
            ), // Передаем context
            const Divider(color: Colors.deepPurple), // Цвет из темы
            _buildSymptomItem(context, 'Headache', Icons.healing),
            _buildSymptomItem(context, 'Fatigue', Icons.nightlight_round),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomItem(BuildContext context, String text, IconData icon) {
    return ListTile(
      leading: Icon(
        icon,
        color: Theme.of(context).iconTheme.color,
      ), // Цвет иконки из темы
      title: Text(
        text,
        style: Theme.of(context).textTheme.bodyLarge,
      ), // Стиль из темы
      trailing: Switch(
        // activeColor: Colors.deepPurple, // Удаляем, берется из темы SwitchThemeData
        value: false, // You might want to manage this state
        onChanged: (value) {
          // TODO: Handle switch state change
        },
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Row(
      children: [
        Icon(
          Icons.insights,
          color: Theme.of(context).iconTheme.color,
        ), // Цвет иконки из темы
        const SizedBox(width: 8),
        Text(
          title,
          style: Theme.of(context).textTheme.titleLarge, // Стиль из темы
        ),
      ],
    );
  }
}
