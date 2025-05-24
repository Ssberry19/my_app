import 'package:flutter/material.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Диета', style: TextStyle(color: Colors.white)),
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
              _buildMealSection('Завтрак', _breakfastContent()),
              const SizedBox(height: 20),
              _buildMealSection('Обед', _lunchContent()),
              const SizedBox(height: 20),
              _buildMealSection('Ужин', _dinnerContent()),
              const SizedBox(height: 20),
              _buildMealSection('Перекус', _snackContent()),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Еженедельный план',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple[800])),
            const Divider(color: Colors.deepPurple),
            const SizedBox(height: 10),
            _buildDayGrid(),
            const SizedBox(height: 20),
            _buildNutritionInfo(),
          ],
        ),
      ),
    );
  }

  Widget _buildDayGrid() {
    final days = ['Пн', 'Вт', 'Ср', 'Чт', 'Пт', 'Сб', 'Вс'];
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
      ),
      itemCount: days.length,
      itemBuilder: (context, index) => Container(
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: Colors.deepPurple.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(days[index],
              style: TextStyle(
                  color: Colors.deepPurple[800],
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildNutritionInfo() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildNutritionItem('1000', 'ккал'),
        _buildNutritionItem('65g', 'Белок'),
        _buildNutritionItem('42g', 'Жиры'),
        _buildNutritionItem('75g', 'Углеводы'),
      ],
    );
  }

  Widget _buildNutritionItem(String value, String label) {
    return Column(
      children: [
        Text(value,
            style: TextStyle(
                color: Colors.deepPurple[800],
                fontWeight: FontWeight.bold,
                fontSize: 18)),
        Text(label,
            style: TextStyle(
                color: Colors.deepPurple[300],
                fontSize: 12)),
      ],
    );
  }

  Widget _buildMealSection(String title, List<Widget> content) {
    return Card(
      // ignore: deprecated_member_use
      color: Colors.white.withOpacity(0.9),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.restaurant, color: Colors.deepPurple),
                const SizedBox(width: 8),
                Text(title,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.deepPurple[800])),
              ],
            ),
            const Divider(color: Colors.deepPurple),
            ...content,
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  List<Widget> _breakfastContent() {
    return [
      _buildIngredientItem('Яйцо вкрутую с гренками'),
      _buildIngredientItem('2 яйца'),
      _buildIngredientItem('1 кусок цельнозернового хлеба'),
      const SizedBox(height: 10),
      _buildInstructionSection('Как приготовить',
          'Сварите яйца вкрутую, подайте с гренками'),
      _buildHealthBenefits('Содержит белок и здоровые жиры'),
    ];
  }

   List<Widget> _lunchContent() {
    return [
      _buildIngredientItem('Яйцо вкрутую с гренками'),
      _buildIngredientItem('2 яйца'),
      _buildIngredientItem('1 кусок цельнозернового хлеба'),
      const SizedBox(height: 10),
      _buildInstructionSection('Как приготовить',
          'Сварите яйца вкрутую, подайте с гренками'),
      _buildHealthBenefits('Содержит белок и здоровые жиры'),
    ];
  }

   List<Widget> _dinnerContent() {
    return [
      _buildIngredientItem('Яйцо вкрутую с гренками'),
      _buildIngredientItem('2 яйца'),
      _buildIngredientItem('1 кусок цельнозернового хлеба'),
      const SizedBox(height: 10),
      _buildInstructionSection('Как приготовить',
          'Сварите яйца вкрутую, подайте с гренками'),
      _buildHealthBenefits('Содержит белок и здоровые жиры'),
    ];
  }

   List<Widget> _snackContent() {
    return [
      _buildIngredientItem('Яйцо вкрутую с гренками'),
      _buildIngredientItem('2 яйца'),
      _buildIngredientItem('1 кусок цельнозернового хлеба'),
      const SizedBox(height: 10),
      _buildInstructionSection('Как приготовить',
          'Сварите яйца вкрутую, подайте с гренками'),
      _buildHealthBenefits('Содержит белок и здоровые жиры'),
    ];
  }
  // Аналогичные методы для lunchContent, dinnerContent, snackContent

  Widget _buildIngredientItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.circle, size: 8, color: Colors.deepPurple),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildInstructionSection(String title, String text) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                color: Colors.deepPurple[800],
                fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        Text(text,
            style: TextStyle(color: Colors.grey[700])),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildHealthBenefits(String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Colors.deepPurple.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8)),
      child: Row(
        children: [
          Icon(Icons.favorite, color: Colors.deepPurple[300]),
          const SizedBox(width: 8),
          Expanded(child: Text(text)),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCustomButton('Заметки', Icons.edit_note),
          _buildCustomButton('ИМТ', Icons.calculate),
          _buildCustomButton('Записать еду', Icons.add_box),
        ],
      ),
    );
  }

  Widget _buildCustomButton(String text, IconData icon) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, color: Colors.deepPurple),
          onPressed: () {},
        ),
        Text(text,
            style: TextStyle(
                color: Colors.deepPurple[800],
                fontSize: 12)),
      ],
    );
  }
}