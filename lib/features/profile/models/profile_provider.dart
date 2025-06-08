// models/profile_data.dart
import 'package:flutter/material.dart';
import 'user_profile.dart'; // Импортируем новую модель UserProfileData

// Enum'ы для удобства (если используются в формах ввода)
enum Gender { male, female }
enum FitnessGoal { loseWeight, maintain, gainWeight, cutting }
enum ActivityLevel { sedentary, light, moderate, active, veryActive }

class ProfileData extends ChangeNotifier {
  // Поля для сбора данных в форме (могут быть nullable по умолчанию)
  String? username;
  String? email;
  Gender? gender; //NOT editable
  DateTime? birthDate; //NOT editable
  int? age; //NOT editable

  double? height;
  double? weight; //MAIN
  ActivityLevel? activityLevel; //MAIN
  double? targetWeight;
  FitnessGoal? goal;

  int? cycleLength; //MAIN
  DateTime? lastPeriodDate; //MAIN
  int? cycleDay; //NOT editable
  String? menstrualPhase; //NOT editable
  
  List<String>? allergens;
  double? bmi; // Add BMI field
  double? bfp; // Add body fat percentage field
  String? password;
  String? confirmPassword;
  // Поле для хранения данных, полученных с бэкенда
  UserProfileData? _userProfile;

  UserProfileData? get userProfile => _userProfile;

  // Метод для обновления данных профиля, полученных с бэкенда
  void updateUserProfile(UserProfileData? data) {
    _userProfile = data;
    // Обновляем локальные поля, если _userProfile не null.
    // Это полезно, если вы хотите использовать те же поля для отображения и редактирования.
    if (data != null) {
      username = data.username;
      // Преобразование строки в enum, если есть
      gender = data.gender != null ? Gender.values.firstWhere((e) => e.toString().split('.').last == data.gender, orElse: () => Gender.male) : null;
      birthDate = data.birthDate;
      height = data.height;
      weight = data.weight;
      targetWeight = data.targetWeight;
      goal = data.goal != null ? FitnessGoal.values.firstWhere((e) => e.toString().split('.').last == data.goal, orElse: () => FitnessGoal.maintain) : null;
      activityLevel = data.activityLevel != null ? ActivityLevel.values.firstWhere((e) => e.toString().split('.').last == data.activityLevel, orElse: () => ActivityLevel.sedentary) : null;
      cycleLength = data.cycleLength; // Используем значение из _userData, если оно есть
      lastPeriodDate = data.lastPeriodDate;
      cycleDay = data.cycleDay; // Присваиваем пустой список, если null
      email = data.email;
      age = data.age;      // Пароль, конечно, не должен возвращаться с бэкенда и здесь не обновляется
      menstrualPhase = data.menstrualPhase;
      bmi = data.bmi;
      bfp = data.bfp;
      allergens = data.allergens ?? []; // Присваиваем пустой список, если null
    }
    notifyListeners(); // Уведомляем слушателей об изменении данных
  }

  void clearUserProfile() {
    _userProfile = null; // Очищаем данные профиля
    notifyListeners(); // Уведомляем слушателей об изменении
  }

  void notify() => notifyListeners();
}