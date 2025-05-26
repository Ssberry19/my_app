import 'package:flutter/material.dart';

class DietScreen extends StatelessWidget {
  const DietScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet'), // Style comes from theme.dart
        // backgroundColor: Colors.deepPurple, // Удаляем, берется из темы
        // elevation: 0, // Удаляем, берется из темы
      ),
      // Убираем Container с градиентом, чтобы использовать scaffoldBackgroundColor из темы
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
            _buildWeeklyPlan(context), // Передаем context
            const SizedBox(height: 20),
            _buildMealSection(
              context,
              'Breakfast',
              _breakfastContent(context),
            ), // Передаем context
            const SizedBox(height: 20),
            _buildMealSection(
              context,
              'Lunch',
              _lunchContent(context),
            ), // Передаем context
            const SizedBox(height: 20),
            _buildMealSection(
              context,
              'Dinner',
              _dinnerContent(context),
            ), // Передаем context
            const SizedBox(height: 20),
            _buildMealSection(
              context,
              'Snack',
              _snackContent(context),
            ), // Передаем context
            const SizedBox(height: 20),
            _buildActionButtons(context), // Передаем context
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyPlan(BuildContext context) {
    // Card автоматически возьмет стиль из theme.dart
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Plan for the week',
              style: Theme.of(
                context,
              ).textTheme.titleLarge, // Использование стиля из темы
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: List.generate(7, (index) {
                final day = [
                  'Mon',
                  'Tue',
                  'Wed',
                  'Thu',
                  'Fri',
                  'Sat',
                  'Sun',
                ][index];
                return Column(
                  children: [
                    Text(day, style: Theme.of(context).textTheme.bodyMedium),
                    const SizedBox(height: 4),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: index == 0
                          ? Theme.of(context).primaryColor
                          : Colors.grey[200],
                      child: Text(
                        (index + 1).toString(),
                        style: TextStyle(
                          color: index == 0 ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealSection(BuildContext context, String title, Widget content) {
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
            const Divider(
              color: Colors.deepPurple,
            ), // Divider остается, цвет из темы
            content,
          ],
        ),
      ),
    );
  }

  Widget _buildMealItem(
    BuildContext context,
    String title,
    String description,
    String calories,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(
            Icons.fastfood,
            color: Theme.of(context).iconTheme.color,
          ), // Использование цвета иконки из темы
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium, // Использование стиля из темы
                ),
                Text(
                  description,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall, // Использование стиля из темы
                ),
              ],
            ),
          ),
          Text(
            calories,
            style: Theme.of(context).textTheme.titleSmall!.copyWith(
              color: Theme.of(context).primaryColor,
            ), // Использование стиля и цвета из темы
          ),
        ],
      ),
    );
  }

  Widget _breakfastContent(BuildContext context) {
    return Column(
      children: [
        _buildMealItem(context, 'Oatmeal with berries', '250g', '300 kcal'),
        _buildMealItem(
          context,
          'Scrambled eggs with toast',
          '1 serving',
          '450 kcal',
        ),
        _buildHealthBenefits(
          context,
          'Start your day with energy and vitamins.',
        ), // Передаем context
      ],
    );
  }

  Widget _lunchContent(BuildContext context) {
    return Column(
      children: [
        _buildMealItem(context, 'Chicken Salad', '300g', '400 kcal'),
        _buildMealItem(context, 'Broccoli Cream Soup', '200ml', '200 kcal'),
        _buildHealthBenefits(
          context,
          'Provide your body with proteins to maintain muscles.',
        ), // Передаем context
      ],
    );
  }

  Widget _dinnerContent(BuildContext context) {
    return Column(
      children: [
        _buildMealItem(
          context,
          'Steamed Fish with Vegetables',
          '350g',
          '350 kcal',
        ),
        _buildMealItem(context, 'Greek Yogurt', '150g', '100 kcal'),
        _buildHealthBenefits(
          context,
          'A light dinner for a comfortable sleep.',
        ), // Передаем context
      ],
    );
  }

  Widget _snackContent(BuildContext context) {
    return Column(
      children: [
        _buildMealItem(context, 'Fruit Smoothie', '200ml', '150 kcal'),
        _buildMealItem(context, 'A Handful of Nuts', '30g', '180 kcal'),
        _buildHealthBenefits(
          context,
          'Perfect for maintaining energy between meals.',
        ), // Передаем context
      ],
    );
  }

  Widget _buildHealthBenefits(BuildContext context, String text) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        // ignore: deprecated_member_use
        color: Theme.of(context).primaryColor.withOpacity(0.1), // Цвет из темы
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(
            Icons.favorite,
            color: Theme.of(context).primaryColor,
          ), // Цвет из темы
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
          ), // Стиль из темы
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildCustomButton(
            context,
            'Notes',
            Icons.edit_note,
          ), // Передаем context
          _buildCustomButton(
            context,
            'BMI',
            Icons.calculate,
          ), // Передаем context
          _buildCustomButton(
            context,
            'Log food',
            Icons.add_box,
          ), // Передаем context
        ],
      ),
    );
  }

  Widget _buildCustomButton(BuildContext context, String text, IconData icon) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 30), // Размер иконки из темы
          color: Theme.of(context).primaryColor, // Цвет иконки из темы
          onPressed: () {
            // Action for button
          },
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).primaryColor,
          ), // Стиль и цвет из темы
        ),
      ],
    );
  }
}
