// models/profile_data.dart
import 'package:flutter/material.dart';
import 'user_profile.dart'; // Импортируем новую модель UserProfileData
import 'package:my_app/features/diet/models/diet_request.dart'; // Импортируем модель DietRequest

// Enum'ы для удобства (если используются в формах ввода)
enum Gender { male, female }
enum FitnessGoal { loseWeight, maintain, gainWeight }
enum ActivityLevel { sedentary, light, moderate, high, extreme }

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
    print(_userProfile?.toJson()); // Выводим данные профиля в консоль для отладки
    
    // Это полезно, если вы хотите использовать те же поля для отображения и редактирования.
    if (data != null) {
      username = data.username;
      // Преобразование строки в enum, если есть
      gender = data.gender != null ? Gender.values.firstWhere((e) => e.toString().split('.').last == data.gender, orElse: () => Gender.male) : null;
      
      print("ЕБАНЫЙ ГЕНДЕР");
      print(gender);
      
      birthDate = data.birthDate;
      height = data.height;
      weight = data.weight;
      targetWeight = data.targetWeight;
      // if (goal = data.goal;)
      // != null ? FitnessGoal.values.firstWhere((e) => e.toString().split('.').last == data.goal, orElse: () => FitnessGoal.maintain) : null;
      
      print("ЕБАНЫЙ ЦЕЛЬ");
      print(data.goal);
      print(FitnessGoal.values);

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

  

  DietRequest toDietRequest() {
  return DietRequest(
    heightCm: height ?? 0, // Преобразуем double в int, если height не null, иначе 0
    weightKg: weight ?? 0,
    age: age ?? 0,
    gender: gender?.toString().split('.').last ?? 'male', // Преобразуем enum в строку (например, 'male')
    goal: goal?.toString().split('.').last ?? 'weight_loss', // Преобразуем enum в строку (например, 'loseWeight')
    targetWeight: targetWeight ?? 0.0,
    activityLevel: activityLevel?.toString().split('.').last ?? 'sedentary', // Преобразуем enum в строку
    allergens: allergens ?? [], // Используем пустой список, если allergens null
    days: 7, // Можно оставить фиксированным или добавить поле в профиль
  );
}

  void clearUserProfile() {
    _userProfile = null; // Очищаем данные профиля
    notifyListeners(); // Уведомляем слушателей об изменении
  }

  void notify() => notifyListeners();
}