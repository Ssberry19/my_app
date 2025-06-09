// features/diet/views/diet_screen.dart
// ignore_for_file: avoid_print, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Импортируем provider
import '../models/diet_plan_provider.dart'; // Импортируем DietPlanProvider
// import '../../profile/models/profile_data.dart'; // Если нужны данные профиля для запроса
import '../models/diet_response.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  int _selectedDayIndex = 0;
  bool _isSummaryExpanded = false;

  @override
  void initState() {
    super.initState();
    // Нам не нужно вызывать fetchDietPlan здесь, так как он уже вызван в MainScreen
    // Однако, если вы хотите убедиться, что план загружен (например, при первом запуске
    // и если пользователь сразу перешел на DietScreen без загрузки MainScreen),
    // можно добавить Provider.of<DietPlanProvider>(context, listen: false).fetchDietPlan();
    // Но при текущей маршрутизации и логике, когда /main является стартовым после логина/регистрации,
    // это не обязательно.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            // Вызываем метод forceRefresh из провайдера
            onPressed: () {
              Provider.of<DietPlanProvider>(context, listen: false).fetchDietPlan(context, forceRefresh: true);
            },
          ),
        ],
      ),
      body: Consumer<DietPlanProvider>( // Используем Consumer для прослушивания изменений
        builder: (context, dietPlanProvider, child) {
          if (dietPlanProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (dietPlanProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(dietPlanProvider.errorMessage!),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      dietPlanProvider.fetchDietPlan(context, forceRefresh: true);
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          if (dietPlanProvider.dietResponse == null) {
            return const Center(child: Text('No diet plan available'));
          }

          final DietResponse response = dietPlanProvider.dietResponse!;
          // Убедимся, что выбранный индекс дня не выходит за пределы,
          // если количество дней изменилось после обновления
          if (_selectedDayIndex >= (response.plan.length)) {
            _selectedDayIndex = 0;
          }
          // Оборачиваем весь контент в SingleChildScrollView
          return SingleChildScrollView(
            child: _buildDietPlan(response),
          );
        },
      ),
    );
  }

  Widget _buildDietPlan(DietResponse response) {
    final List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0),
          child: _buildSummaryCard(response),
        ),
        _buildDaySelectorCard(weekdays, response.plan.length, response),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildDaySelectorCard(List<String> weekdays, int numberOfDays, DietResponse response) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 8.0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 8.0),
            child: Text(
              'Plan for the week',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(numberOfDays, (index) {
              final bool isSelected = _selectedDayIndex == index;
              return GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedDayIndex = index;
                  });
                },
                child: Column(
                  children: [
                    Text(
                      weekdays[index % weekdays.length],
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).colorScheme.secondary.withOpacity(0.1),
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary
                              : Theme.of(context).textTheme.bodyLarge?.color,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const Divider(height: 24, thickness: 1),

          Padding(
            padding: const EdgeInsets.only(bottom: 15.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMacroItem('Protein', '${response.macronutrientDistribution.proteinPercentage}%', Icons.egg),
                _buildMacroItem('Carbs', '${response.macronutrientDistribution.carbPercentage}%', Icons.rice_bowl),
                _buildMacroItem('Fat', '${response.macronutrientDistribution.fatPercentage}%', Icons.oil_barrel),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.local_fire_department, color: Theme.of(context).primaryColor, size: 24),
              const SizedBox(width: 8),
              Text(
                'Daily Calories: ${response.dailyCalories} kcal',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const Divider(height: 24, thickness: 1),

          if (response.plan.isNotEmpty && _selectedDayIndex < response.plan.length)
            _buildDayPlanContent(response.plan[_selectedDayIndex])
          else
            const Center(child: Text('Diet plan for selected day not available.')),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(DietResponse response) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Diet Summary',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const Divider(height: 20, thickness: 1),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  response.summary,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: _isSummaryExpanded ? null : 2,
                  overflow: _isSummaryExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
                if (response.summary.length > 100)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isSummaryExpanded = !_isSummaryExpanded;
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                    child: Text(
                      _isSummaryExpanded ? 'Read less' : 'Read more',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMacroItem(String label, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Theme.of(context).primaryColor, size: 24),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildDayPlanContent(DayPlan dayPlan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Day ${dayPlan.day}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Divider(height: 20, thickness: 1),
        ...dayPlan.meals.map((meal) => _buildMealItem(meal)),
      ],
    );
  }

  Widget _buildMealItem(Meal meal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.fastfood, color: Theme.of(context).primaryColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      meal.description,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              Text(
                '${meal.calories} kcal',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey[700]),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 28.0),
            child: Wrap(
              spacing: 8.0,
              runSpacing: 4.0,
              children: [
                _buildNutritionChip('P: ${meal.proteinG}g'),
                _buildNutritionChip('C: ${meal.carbsG}g'),
                _buildNutritionChip('F: ${meal.fatG}g'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNutritionChip(String text) {
    return Chip(
      label: Text(text),
      visualDensity: VisualDensity.compact,
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
      labelStyle: TextStyle(color: Theme.of(context).primaryColor, fontSize: 14),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
    );
  }
}