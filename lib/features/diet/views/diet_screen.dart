import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/diet_request.dart';
import '../models/diet_response.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class DietScreen extends StatefulWidget {
  const DietScreen({super.key});

  @override
  State<DietScreen> createState() => _DietScreenState();
}

class _DietScreenState extends State<DietScreen> {
  DietResponse? _dietResponse;
  bool _isLoading = false;
  String? _errorMessage;
  int _selectedDayIndex = 0; // Инициализируем выбранный день как первый (День 1)
  bool _isSummaryExpanded = false; // Состояние для сворачивания/разворачивания текста сводки

  final DietRequest _requestData = DietRequest(
    heightCm: 175,
    weightKg: 70,
    age: 25,
    gender: "female",
    goal: "weight_loss",
    targetWeight: 60.0,
    activityLevel: "sedentary",
    allergens: [],
    days: 7,
  );

  @override
  void initState() {
    super.initState();
    _fetchDietPlan();
  }

  Future<void> _fetchDietPlan() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final String baseUrl = dotenv.env['FASTAPI_URL'] ?? 'http://127.0.0.1:8000';
    const String endpoint = '/generate-diet';
    final String apiUrl = '$baseUrl$endpoint';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: _requestData.toJsonString(),
      );

      if (response.statusCode == 200) {
        setState(() {
          _dietResponse = dietResponseFromJson(response.body);
          // Убедимся, что выбранный индекс дня не выходит за пределы,
          // если количество дней изменилось после обновления
          if (_selectedDayIndex >= (_dietResponse?.plan.length ?? 0)) {
            _selectedDayIndex = 0;
          }
          _isSummaryExpanded = false; // Сбрасываем состояние развернутости при новой загрузке
        });
      } else {
        setState(() {
          _errorMessage = 'Error ${response.statusCode}: ${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not connect to server: $e';
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Diet Plan'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchDietPlan,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_errorMessage != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_errorMessage!),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _fetchDietPlan,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }
    if (_dietResponse == null) {
      return const Center(child: Text('No diet plan available'));
    }
    // Оборачиваем весь контент в SingleChildScrollView
    return SingleChildScrollView(
      child: _buildDietPlan(_dietResponse!),
    );
  }

  Widget _buildDietPlan(DietResponse response) {
    // Список названий дней недели для отображения над кружками
    final List<String> weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Карточка сводки диеты
        Padding(
          padding: const EdgeInsets.fromLTRB(16.0, 8.0, 16.0, 8.0), // Отступы для Summary
          child: _buildSummaryCard(response),
        ),
        // Объединенная карточка с заголовком "Plan for the week" и селектором дней
        // а также с макронутриентами и калориями
        _buildDaySelectorCard(weekdays, response.plan.length, response), // Передаем response целиком
        const SizedBox(height: 20), // Дополнительный отступ внизу
      ],
    );
  }

  // Новый виджет для объединенной карточки с селектором дней, макронутриентами и планом
  Widget _buildDaySelectorCard(List<String> weekdays, int numberOfDays, DietResponse response) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 8.0), // Корректируем внутренние отступы
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 3), // changes position of shadow
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Заголовок "Plan for the week" внутри карточки
          Padding(
            padding: const EdgeInsets.fromLTRB(4.0, 0, 4.0, 8.0), // Небольшой отступ от края карточки
            child: Text(
              'Plan for the week',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor, // Красим в фиолетовый
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
                      weekdays[index % weekdays.length], // Гарантируем, что используем дни недели по кругу
                      style: TextStyle(
                        fontSize: 12,
                        color: isSelected ? Theme.of(context).primaryColor : Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: isSelected
                          ? Theme.of(context).primaryColor // Цвет для выбранного дня
                          : Theme.of(context).colorScheme.secondary.withOpacity(0.1), // Цвет для невыбранного
                      child: Text(
                        '${index + 1}',
                        style: TextStyle(
                          color: isSelected
                              ? Theme.of(context).colorScheme.onPrimary // Цвет текста для выбранного дня
                              : Theme.of(context).textTheme.bodyLarge?.color, // Цвет текста для невыбранного
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),
          const Divider(height: 24, thickness: 1), // Разделитель после селектора дней

          // Макронутриенты и калории (перенесены сюда)
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
          const Divider(height: 24, thickness: 1), // Разделитель перед планом дня

          // Отображение плана для выбранного дня
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
      elevation: 2, // Добавим тень для соответствия дизайну
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)), // Скруглим углы
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
            // Сворачиваемый текст
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  response.summary,
                  style: Theme.of(context).textTheme.bodyMedium,
                  maxLines: _isSummaryExpanded ? null : 2, // 2 строки или весь текст
                  overflow: _isSummaryExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
                ),
                // Показываем кнопку только если текст длиннее 2 строк
                if (response.summary.length > 100)
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _isSummaryExpanded = !_isSummaryExpanded;
                      });
                    },
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero, // Убираем лишний padding у кнопки
                      alignment: Alignment.centerLeft, // Выравниваем текст кнопки по левому краю
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
        Icon(icon, color: Theme.of(context).primaryColor, size: 24), // Иконка для макроса
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

  // Метод для содержимого плана дня (без Card)
  Widget _buildDayPlanContent(DayPlan dayPlan) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Day ${dayPlan.day}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        const Divider(height: 20, thickness: 1),
        ...dayPlan.meals.map((meal) => _buildMealItem(meal)).toList(),
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
            crossAxisAlignment: CrossAxisAlignment.center, // Выравнивание по центру
            children: [
              Icon(Icons.fastfood, color: Theme.of(context).primaryColor, size: 20), // Иконка еды
              const SizedBox(width: 8),
              Expanded( // Расширяем Text, чтобы он занимал доступное пространство
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      meal.description, // Описание блюда
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
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
            padding: const EdgeInsets.only(left: 28.0), // Отступ для чипов
            child: Wrap(
              spacing: 8.0, // Горизонтальный отступ между чипами
              runSpacing: 4.0, // Вертикальный отступ между строками чипов
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
      backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1), // Полупрозрачный цвет темы
      labelStyle: TextStyle(color: Theme.of(context).primaryColor, fontSize: 12), // Цвет текста чипа
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 0),
    );
  }
}