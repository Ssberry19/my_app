import 'package:flutter/material.dart';

class WorkoutsScreen extends StatelessWidget {
  const WorkoutsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Тренировки', style: TextStyle(color: Colors.white)),
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
              _buildWeeklyPlan(),
              const SizedBox(height: 20),
              _buildWorkoutList(),
              const SizedBox(height: 20),
              _buildPerformanceSection(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeeklyPlan() {
    return Card(
      // ignore: deprecated_member_use
      color: Colors.white.withOpacity(0.9),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSectionHeader('Еженедельный план тренировок'),
            const Divider(color: Colors.deepPurple),
            const SizedBox(height: 10),
            _buildWorkoutProgress(),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutProgress() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildProgressItem('Выполнено', '4/7', Colors.deepPurple),
        _buildProgressItem('Часов', '6.5h', Colors.deepPurple[300]!),
        _buildProgressItem('Калории', '2400', Colors.deepPurple[100]!),
      ],
    );
  }

  Widget _buildProgressItem(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: color.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(value,
                style: TextStyle(
                    color: color,
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
        ),
        const SizedBox(height: 8),
        Text(label,
            style: TextStyle(
                color: Colors.deepPurple[800],
                fontSize: 12)),
      ],
    );
  }

  Widget _buildWorkoutList() {
    final workouts = [
      {'title': 'Силовая тренировка', 'time': '30 мин', 'type': 'Грудь/Спина'},
      {'title': 'Кардио', 'time': '20 мин', 'type': 'Беговая дорожка'},
      {'title': 'HIIT', 'time': '45 мин', 'type': 'Интервалы'},
    ];

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
            _buildSectionHeader('Текущие тренировки'),
            const Divider(color: Colors.deepPurple),
            ...workouts.map((workout) => _buildWorkoutItem(workout)),
          ],
        ),
      ),
    );
  }

  Widget _buildWorkoutItem(Map<String, String> workout) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            // ignore: deprecated_member_use
            color: Colors.deepPurple.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(Icons.fitness_center, color: Colors.deepPurple),
        ),
        title: Text(workout['title']!,
            style: TextStyle(
                color: Colors.deepPurple[800],
                fontWeight: FontWeight.bold)),
        subtitle: Text(workout['type']!,
            style: TextStyle(color: Colors.deepPurple[300])),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(workout['time']!,
                style: TextStyle(
                    color: Colors.deepPurple[800],
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSection() {
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
            _buildSectionHeader('Запись показателей'),
            const Divider(color: Colors.deepPurple),
            _buildPerformanceField('Вес', 'кг'),
            _buildPerformanceField('Подходы', 'кол-во'),
            _buildPerformanceField('Повторения', 'раз'),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              icon: const Icon(Icons.add, size: 20),
              label: const Text('Добавить запись'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceField(String label, String hint) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          floatingLabelStyle: TextStyle(color: Colors.deepPurple[800]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide(color: Colors.deepPurple),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.deepPurple, width: 2),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Row(
      children: [
        Icon(Icons.sports_gymnastics, color: Colors.deepPurple),
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