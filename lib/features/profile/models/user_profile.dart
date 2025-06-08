// models/user_profile.dart
import 'dart:convert';

// Функция для десериализации JSON-строки в объект UserProfileResponse
UserProfileResponse userProfileResponseFromJson(String str) => UserProfileResponse.fromJson(json.decode(str));

// Функция для сериализации объекта UserProfileResponse в JSON-строку
String userProfileResponseToJson(UserProfileResponse data) => json.encode(data.toJson());

// Основной класс для ответа профиля пользователя
class UserProfileResponse {
  final String? status; // Может быть null, если бэкенд не всегда возвращает
  final String? message; // Может быть null
  final UserProfileData? data; // Сами данные профиля, могут быть null

  UserProfileResponse({
    this.status,
    this.message,
    this.data,
  });

  // Фабричный конструктор для создания объекта из JSON
  factory UserProfileResponse.fromJson(Map<String, dynamic> json) => UserProfileResponse(
        status: json["status"],
        message: json["message"],
        data: json["data"] == null ? null : UserProfileData.fromJson(json["data"]), // Проверяем на null
      );

  // Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
        "data": data?.toJson(), // Безопасный вызов toJson()
      };
}

// Класс для самих данных профиля пользователя
class UserProfileData {
  final String? username;
  final String? gender;
  final DateTime? birthDate;
  final double? height;
  final double? weight;
  final double? targetWeight;
  final String? goal;
  final String? activityLevel;
  int? cycleLength;
  DateTime? lastPeriodDate;
  int? cycleDay;
  final String? email;

  UserProfileData({
    this.username,
    this.gender,
    this.birthDate,
    this.height,
    this.weight,
    this.targetWeight,
    this.goal,
    this.activityLevel,
    this.lastPeriodDate,
    this.cycleLength,
    this.cycleDay,
    this.email,
  });

  // Фабричный конструктор для создания объекта из JSON
  factory UserProfileData.fromJson(Map<String, dynamic> json) => UserProfileData(
        username: json["username"],
        gender: json["gender"],
        birthDate: json["birthDate"] != null ? DateTime.parse(json["birthDate"]) : null,
        height: json["height"]?.toDouble(), // Используем ?.toDouble() для безопасного приведения
        weight: json["weight"]?.toDouble(),
        targetWeight: json["targetWeight"]?.toDouble(),
        goal: json["goal"],
        activityLevel: json["activityLevel"],
        // Специальная обработка для List<DateTime>
        lastPeriodDate: json["lastPeriodDate"] != null ? DateTime.parse(json["lastPeriodDate"]) : null,
        cycleLength: json["cycleLength"],
        cycleDay: json["cycleDay"],
        email: json["email"],
      );

  // Метод для преобразования объекта в JSON
  Map<String, dynamic> toJson() => {
        "username": username,
        "gender": gender,
        "birthDate": birthDate?.toIso8601String(),
        "height": height,
        "weight": weight,
        "targetWeight": targetWeight,
        "goal": goal,
        "activityLevel": activityLevel,
        "lastPeriodDate": lastPeriodDate?.toIso8601String(),
        "cycleLength": cycleLength, 
        "cycleDay": cycleDay,
        "email": email,
      };
}