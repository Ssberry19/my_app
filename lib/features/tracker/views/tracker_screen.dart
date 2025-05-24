import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class TrackerScreen extends StatelessWidget {
  const TrackerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Трекер', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE6E6FA),
              Color(0xFFD8BFD8),
            ],
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildCalendarSection(),
              const SizedBox(height: 20),
              _buildProgressChart(),
              const SizedBox(height: 20),
              _buildNotesSection(),
              const SizedBox(height: 20),
              _buildSymptomsMonitor(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarSection() {
    return Card(
      // ignore: deprecated_member_use
      color: Colors.white.withOpacity(0.9),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionHeader('Календарь прогресса'),
            const Divider(color: Colors.deepPurple),
            const SizedBox(height: 10),
            _buildWeekDaysRow(),
            _buildCalendarGrid(),
          ],
        ),
      ),
    );
  }

  Widget _buildWeekDaysRow() {
    final days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: days.map((day) => 
        Text(day, style: TextStyle(
          color: Colors.deepPurple[800],
          fontWeight: FontWeight.bold))
      ).toList(),
    );
  }

  Widget _buildCalendarGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.2,
      ),
      itemCount: 28,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          color: _getDayColor(index),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            '${index + 1}',
            style: TextStyle(color: Colors.deepPurple[800]),
          ),
        ),
      ),
    );
  }

  Color _getDayColor(int index) {
    final colors = [
      Colors.deepPurple,
      Colors.deepPurple,
      Colors.deepPurple,
    ];
    return colors[index % 3];
  }

  Widget _buildProgressChart() {
    return Card(
      // ignore: deprecated_member_use
      color: Colors.white.withOpacity(0.9),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionHeader('График прогресса'),
            const Divider(color: Colors.deepPurple),
            const SizedBox(height: 10),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: const [
                        FlSpot(0, 3),
                        FlSpot(2, 1),
                        FlSpot(4, 4),
                        FlSpot(6, 3),
                      ],
                      color: Colors.deepPurple,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
            _buildChartLegend(),
          ],
        ),
      ),
    );
  }

  Widget _buildChartLegend() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildLegendItem('Неделя', Colors.deepPurple),
        _buildLegendItem('Месяц', Colors.deepPurple[300]!),
        _buildLegendItem('Год', Colors.deepPurple[100]!),
      ],
    );
  }

  Widget _buildLegendItem(String text, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(text),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Card(
      // ignore: deprecated_member_use
      color: Colors.white.withOpacity(0.9),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionHeader('Заметки'),
            const Divider(color: Colors.deepPurple),
            const TextField(
              decoration: InputDecoration(
                hintText: 'Добавьте заметку...',
                border: InputBorder.none,
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 10),
            ElevatedButton.icon(
              icon: Icon(Icons.save, color: Colors.white),
              label: const Text('Сохранить'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomsMonitor() {
    return Card(
      // ignore: deprecated_member_use
      color: Colors.white.withOpacity(0.9),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionHeader('Мониторинг симптомов'),
            const Divider(color: Colors.deepPurple),
            _buildSymptomItem('Головная боль', Icons.healing),
            _buildSymptomItem('Усталость', Icons.nightlight_round),
            _buildSymptomItem('Сон', Icons.bedtime),
          ],
        ),
      ),
    );
  }

  Widget _buildSymptomItem(String text, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.deepPurple),
      title: Text(text),
      trailing: Switch(
        activeColor: Colors.deepPurple,
        value: false,
        onChanged: (value) {},
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Icon(Icons.insights, color: Colors.deepPurple),
        const SizedBox(width: 8),
        Text(title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple[800])),
      ],
    );
  }
}