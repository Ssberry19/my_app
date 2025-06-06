// models/profile_data.dart
import 'package:flutter/material.dart';
import 'user_profile.dart'; // Импортируем новую модель UserProfileData

// Enum'ы для удобства (если используются в формах ввода)
enum Gender { male, female }
enum FitnessGoal { loseWeight, maintain, gainWeight, cutting }
enum ActivityLevel { sedentary, light, moderate, active, veryActive }

class ProfileData extends ChangeNotifier {
  // Поля для сбора данных в форме (могут быть nullable по умолчанию)
  String? fullName;
  Gender? gender;
  DateTime? birthDate;
  double? height;
  double? weight;
  double? targetWeight;
  FitnessGoal? goal;
  ActivityLevel? activityLevel;
  List<DateTime> menstrualCycles = []; // Это может быть пустым списком
  String? email;
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
      fullName = data.fullName;
      // Преобразование строки в enum, если есть
      gender = data.gender != null ? Gender.values.firstWhere((e) => e.toString().split('.').last == data.gender, orElse: () => Gender.male) : null;
      birthDate = data.birthDate;
      height = data.height;
      weight = data.weight;
      targetWeight = data.targetWeight;
      goal = data.goal != null ? FitnessGoal.values.firstWhere((e) => e.toString().split('.').last == data.goal, orElse: () => FitnessGoal.maintain) : null;
      activityLevel = data.activityLevel != null ? ActivityLevel.values.firstWhere((e) => e.toString().split('.').last == data.activityLevel, orElse: () => ActivityLevel.sedentary) : null;
      menstrualCycles = data.menstrualCycles ?? []; // Присваиваем пустой список, если null
      email = data.email;
      // Пароль, конечно, не должен возвращаться с бэкенда и здесь не обновляется
    }
    notifyListeners(); // Уведомляем слушателей об изменении данных
  }

  void notify() => notifyListeners();
}