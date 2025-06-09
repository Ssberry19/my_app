// lib/providers/workout_plan_provider.dart
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../models/workout_request.dart';
import '../models/workout_response.dart';
import 'package:my_app/features/profile/models/profile_provider.dart';
import 'package:provider/provider.dart'; // Для работы с JSON

class WorkoutPlanProvider extends ChangeNotifier {
  WorkoutResponse? _workoutResponse;
  bool _isLoading = false;
  String? _errorMessage;

  WorkoutResponse? get workoutResponse => _workoutResponse;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchWorkoutPlan(BuildContext context, {bool forceRefresh = false}) async {
  if (_workoutResponse != null && !forceRefresh && !_isLoading) return;

  _isLoading = true;
  notifyListeners();

  final String baseUrl = dotenv.env['FASTAPI_URL'] ?? 'http://127.0.0.1:8000';
  const String endpoint = '/workout-calories/generate';
  final String apiUrl = '$baseUrl$endpoint';

  try {
    final profileData = Provider.of<ProfileData>(context, listen: false);

    if (profileData.height == null || profileData.weight == null || profileData.age == null) {
    _errorMessage = 'Profile data (height/weight/age) is missing';
    return;
  }

    final WorkoutRequest request = WorkoutRequest(
      heightCm: (profileData.height ?? 0) > 0 ? profileData.height! : 170, // Дефолтное значение
      weightKg: (profileData.weight ?? 0) > 0 ? profileData.weight! : 70,
      age: profileData.age ?? 25,
      gender: profileData.gender?.toString().split('.').last ?? 'male', // "male" или "female"
      goal: profileData.goal?.toString().split('.').last ?? 'weight_loss',
      menstrualPhase: profileData.menstrualPhase?.isNotEmpty == true 
          ? profileData.menstrualPhase!
          : 'none', // Замените 'none' на допустимое значение для бэкенда
      bodyFatPercentage: (profileData.bfp ?? 0) > 0 ? profileData.bfp! : 20.0,
      days: 7,
    );
  
    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'Content-Type': 'application/json'},
      body: workoutRequestToJson(request),
    );

    if (response.statusCode == 200) {
      _workoutResponse = workoutResponseFromJson(response.body);
      _errorMessage = null;
    } else {
      _errorMessage = 'Error ${response.statusCode}: ${response.body}';
    }
  } catch (e) {
    _errorMessage = 'Could not connect to server: $e';
  } finally {
    _isLoading = false;
    notifyListeners();
  }
}
}