import 'package:flutter/material.dart';

class RegistrationData extends ChangeNotifier {
  String? username;
  Gender? gender;
  DateTime? birthDate;
  double? height;
  double? weight;
  double? targetWeight;
  FitnessGoal? goal;
  ActivityLevel? activityLevel;
  List<String>? allergens = []; // Добавлено поле для аллергенов
  int? cycleLength;
  DateTime? lastPeriodDate;
  int? cycleDay;
  String? email;
  String? password;
  String? confirmPassword;

  void notify() => notifyListeners();

  @override
  void dispose() {
    // Очищаем ресурсы
    super.dispose();
  }
}

enum Gender { male, female }
enum FitnessGoal { loseWeight, maintain, gainWeight }
enum ActivityLevel { sedentary, light, moderate, high, extreme }