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
  final List<String>? allergens;
  int? cycleLength;
  DateTime? lastPeriodDate;
  int? cycleDay;
  final String? email;
  final int? age; // Добавлено поле для возраста
  final String? menstrualPhase;
  final double? bmi; // Добавлено поле для индекса массы тела
  final double? bfp; // Добавлено поле для процента жира в организме

  UserProfileData({
    this.username,
    this.gender,
    this.birthDate,
    this.height,
    this.weight,
    this.targetWeight,
    this.goal,
    this.activityLevel,
    this.allergens,
    this.lastPeriodDate,
    this.cycleLength,
    this.cycleDay,
    this.email,
    this.age, // Добавлено поле для возраста
    this.menstrualPhase,
    this.bmi, // Добавлено поле для индекса массы тела
    this.bfp, // Добавлено поле для процента жира в организме
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
        allergens: json["allergens"] == null
            ? []
            : List<String>.from(json["allergens"].map((x) => x)), // <--- ADD THIS FOR PARSING
        lastPeriodDate: json["lastPeriodDate"] != null ? DateTime.parse(json["lastPeriodDate"]) : null,
        cycleLength: json["cycleLength"],
        cycleDay: json["cycleDay"],
        email: json["email"],
        age: json["age"], // Приводим к int, если есть
        menstrualPhase: json["menstrualPhase"], 
        bmi: json["bmi"]?.toDouble(), // Приводим к double, если есть
        bfp: json["bfp"]?.toDouble(), // Приводим к double, если есть
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
        "allergens": allergens == null ? [] : List<dynamic>.from(allergens!.map((x) => x)),
        "lastPeriodDate": lastPeriodDate?.toIso8601String(),
        "cycleLength": cycleLength, 
        "cycleDay": cycleDay,
        "email": email,
        "age": age, // Возраст сохраняем как есть
        "menstrualPhase": menstrualPhase,
        "bmi": bmi, // Индекс массы тела сохраняем как есть
        "bfp": bfp, // Процент жира в организме сохраняем как есть
      };
}