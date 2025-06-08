// lib/providers/diet_plan_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/diet_request.dart';
import '../models/diet_response.dart';

class DietPlanProvider extends ChangeNotifier {
  DietResponse? _dietResponse;
  bool _isLoading = false;
  String? _errorMessage;

  DietResponse? get dietResponse => _dietResponse;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Данные запроса, которые будут использоваться для генерации плана
  // В реальном приложении эти данные должны приходить из профиля пользователя
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

  Future<void> fetchDietPlan({bool forceRefresh = false}) async {
    // Если данные уже есть и не требуется принудительное обновление, просто выходим
    if (_dietResponse != null && !forceRefresh && !_isLoading) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Уведомляем слушателей о начале загрузки

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
        _dietResponse = dietResponseFromJson(response.body);
        _errorMessage = null;
      } else {
        _errorMessage = 'Error ${response.statusCode}: ${response.body}';
        _dietResponse = null; // Очищаем старый план при ошибке
      }
    } catch (e) {
      _errorMessage = 'Could not connect to server: $e';
      _dietResponse = null; // Очищаем старый план при ошибке
    } finally {
      _isLoading = false;
      notifyListeners(); // Уведомляем слушателей об окончании загрузки (или ошибке)
    }
  }
}