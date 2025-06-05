// ignore_for_file: avoid_print

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

  final DietRequest _requestData = DietRequest(
    heightCm: 175,
    weightKg: 75,
    age: 21,
    gender: "female",
    goal: "weight_loss",
    targetWeight: 65.0,
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
    
    print('Attempting to connect to: $apiUrl');

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: dietRequestToJson(_requestData),
      );

      if (response.statusCode == 200) {
        print('Successful API response body: ${response.body}');
        setState(() {
          _dietResponse = dietResponseFromJson(response.body);
        });
      } else {
        print('Server error status code: ${response.statusCode}');
        print('Server error response body: ${response.body}');
        setState(() {
          _errorMessage =
              'Ошибка ${response.statusCode}: ${response.reasonPhrase}\n${response.body}';
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Could not connect to server: $e';
      });
      print('Network/Connection error: $e');
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
        title: const Text('Weekly Diet Plan'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, color: Colors.red, size: 60),
                        const SizedBox(height: 10),
                        Text(
                          'Loading error: $_errorMessage',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _fetchDietPlan,
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : _dietResponse == null
                  ? const Center(child: Text('No diet plan available'))
                  : _buildDietPlanDisplay(_dietResponse!),
    );
  }

  Widget _buildDietPlanDisplay(DietResponse response) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Используем оператор ?? для предоставления значения по умолчанию, если поле null
          _buildInfoCard('Status', response.status ?? 'N/A', Colors.green),
          _buildInfoCard('BMI Category', response.bmiCase ?? 'N/A', Colors.blue),
          _buildInfoCard('BFP Category', response.bfpCase ?? 'N/A', Colors.teal),
          const SizedBox(height: 20),
          const Text(
            'Your diet plan:',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          // Проверяем, что dietPlan не null и не пуст
          ...(response.dietPlan.isNotEmpty
              ? response.dietPlan.map((dayPlan) => _buildDayDietCard(dayPlan)).toList()
              : [const Center(child: Text('Diet plan data is missing or empty.'))]),
          const SizedBox(height: 20),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, Color color) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      color: color.withOpacity(0.1),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$title:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              value,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayDietCard(DietPlan dayPlan) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Используем оператор ?? для безопасного доступа к nullable полям
            Text(
              'Day ${dayPlan.day}: ${dayPlan.dietName ?? 'No Diet Name'}', // <-- ИСПРАВЛЕНО
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 8),
            Text(
              dayPlan.description ?? 'No description provided.', // <-- ИСПРАВЛЕНО (это строка 89)
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey[700]),
            ),
            const Divider(height: 20, thickness: 1),
            // Проверяем, что meals не null и не пуст
            ...(dayPlan.meals.isNotEmpty
                ? dayPlan.meals.map((meal) => _buildMealTile(meal)).toList()
                : [const Text('No meals planned for this day.')]),
          ],
        ),
      ),
    );
  }

  Widget _buildMealTile(Meal meal) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Используем оператор ?? для безопасного доступа к nullable полям
          Text(
            '${meal.type ?? 'N/A'}: ${meal.name ?? 'No Meal Name'}', // <-- ИСПРАВЛЕНО
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(meal.description ?? 'No description provided.'), // <-- ИСПРАВЛЕНО
          // Проверяем, что calories не null перед вызовом toStringAsFixed
          Text('Calories: ${meal.calories?.toStringAsFixed(2) ?? 'N/A'} kcal'),
          const SizedBox(height: 8),
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
          ),
          _buildCustomButton(
            context,
            'BMI',
            Icons.calculate,
          ),
          _buildCustomButton(
            context,
            'Log food',
            Icons.add_box,
          ),
        ],
      ),
    );
  }

  Widget _buildCustomButton(BuildContext context, String text, IconData icon) {
    return Column(
      children: [
        IconButton(
          icon: Icon(icon, size: 30),
          color: Theme.of(context).primaryColor,
          onPressed: () {
            // Action for button
          },
        ),
        const SizedBox(height: 4),
        Text(
          text,
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            color: Theme.of(context).primaryColor,
          ),
        ),
      ],
    );
  }
}