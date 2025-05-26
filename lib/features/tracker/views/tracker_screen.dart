import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart'; // Предполагается, что fl_chart настроен на использование тематических цветов или вы его настраиваете вручную
import 'package:table_calendar/table_calendar.dart'; // Если используется

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
            _buildProgressChart(context), // Передаем context
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
                  ).primaryColor.withOpacity(0.2), // Цвет из темы
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

  Widget _buildProgressChart(BuildContext context) {
    // Card автоматически возьмет стиль из theme.dart
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionHeader(context, 'Weekly Progress'), // Передаем context
            const Divider(color: Colors.deepPurple), // Цвет из темы
            SizedBox(
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
                        FlSpot(0, 2),
                        FlSpot(1, 4),
                        FlSpot(2, 3),
                        FlSpot(3, 5),
                        FlSpot(4, 4),
                        FlSpot(5, 6),
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
                        ).primaryColor.withOpacity(0.2), // Цвет из темы
                      ),
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
