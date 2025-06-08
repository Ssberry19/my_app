// lib/providers/workout_plan_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/workout_request.dart';
import '../models/workout_response.dart';

class WorkoutPlanProvider extends ChangeNotifier {
  WorkoutResponse? _workoutResponse;
  bool _isLoading = false;
  String? _errorMessage;

  WorkoutResponse? get workoutResponse => _workoutResponse;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  // Данные запроса, которые будут использоваться для генерации плана
  // В реальном приложении эти данные должны приходить из профиля пользователя
  final WorkoutRequest _requestData = WorkoutRequest(
    heightCm: 180,
    weightKg: 80,
    age: 21,
    gender: "male",
    goal: "weight_loss",
    menstrualPhase: "", // Убедитесь, что это поле обрабатывается корректно для мужчин или женщин
    bodyFatPercentage: 38.0,
    days: 7,
  );

  Future<void> fetchWorkoutPlan({bool forceRefresh = false}) async {
    // Если данные уже есть и не требуется принудительное обновление, просто выходим
    if (_workoutResponse != null && !forceRefresh && !_isLoading) {
      return;
    }

    _isLoading = true;
    _errorMessage = null;
    notifyListeners(); // Уведомляем слушателей о начале загрузки

    final String baseUrl = dotenv.env['FASTAPI_URL'] ?? 'http://127.0.0.1:8000';
    const String endpoint = '/workout-calories/generate';
    final String apiUrl = '$baseUrl$endpoint';

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: workoutRequestToJson(_requestData), // Используем функцию для сериализации
      );

      if (response.statusCode == 200) {
        _workoutResponse = workoutResponseFromJson(response.body);
        _errorMessage = null;
      } else {
        _errorMessage = 'Error ${response.statusCode}: ${response.body}';
        _workoutResponse = null; // Очищаем старый план при ошибке
      }
    } catch (e) {
      _errorMessage = 'Could not connect to server: $e';
      _workoutResponse = null; // Очищаем старый план при ошибке
    } finally {
      _isLoading = false;
      notifyListeners(); // Уведомляем слушателей об окончании загрузки (или ошибке)
    }
  }
}