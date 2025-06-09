// lib/providers/diet_plan_provider.dart
// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/diet_request.dart';
import '../models/diet_response.dart';
import 'package:my_app/features/profile/models/profile_provider.dart';
import 'package:provider/provider.dart'; // Для работы с JSON

class DietPlanProvider extends ChangeNotifier {
  DietResponse? _dietResponse;
  bool _isLoading = false;
  String? _errorMessage;

  DietResponse? get dietResponse => _dietResponse;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchDietPlan(BuildContext context, {bool forceRefresh = false}) async {
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

      // Получаем данные профиля из Provider
      final profileData = Provider.of<ProfileData>(context, listen: false);
  //     final DietRequest request = profileData.toDietRequest(); // Преобразуем профиль в DietRequest
 
      final DietRequest request = DietRequest(
        heightCm: (profileData.height ?? 0) > 0 ? profileData.height! : 170, // Дефолтное значение
        weightKg: (profileData.weight ?? 0) > 0 ? profileData.weight! : 70,
        age: profileData.age ?? 25,
        gender: "female",
        goal: "weight_loss", // Замените на нужную цель
        targetWeight: (profileData.targetWeight ?? 0) > 0 ? profileData.targetWeight! : 65.0, // Дефолтное значение
        activityLevel: profileData.activityLevel?.toString().split('.').last ?? 'sedentary', // Преобразуем enum в строку
        allergens: profileData.allergens ?? [], // Используем пустой список, если allergens null
        days: 7, // Количество дней для плана питания
        );


      print("POPA" + request.toJsonString());

      
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: dietRequestToJson(request), // Преобразуем запрос в JSON
    
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