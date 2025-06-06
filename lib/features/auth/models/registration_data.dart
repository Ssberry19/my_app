import 'package:flutter/material.dart';

class RegistrationData extends ChangeNotifier{
  String? fullName;
  Gender? gender;
  DateTime? birthDate;
  double? height;
  double? weight;
  double? targetWeight;
  FitnessGoal? goal;
  ActivityLevel? activityLevel;
  List<DateTime> menstrualCycles = [];
  String? email;
  String? password;
  String? confirmPassword;

  void notify() => notifyListeners();
}

enum Gender { male, female }
enum FitnessGoal { loseWeight, maintain, gainWeight }
enum ActivityLevel { sedentary, light, moderate, high, extreme }