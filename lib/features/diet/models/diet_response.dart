// models/diet_response.dart
import 'dart:convert';

DietResponse dietResponseFromJson(String str) => DietResponse.fromJson(json.decode(str));

String dietResponseToJson(DietResponse data) => json.encode(data.toJson());

class DietResponse {
  final String? status; // Сделано nullable
  final String? bmiCase; // Сделано nullable
  final String? bfpCase; // Сделано nullable
  final List<DietPlan> dietPlan;

  DietResponse({
    required this.status,
    required this.bmiCase,
    required this.bfpCase,
    required this.dietPlan,
  });

  factory DietResponse.fromJson(Map<String, dynamic> json) => DietResponse(
        status: json["status"],
        bmiCase: json["bmi_case"],
        bfpCase: json["bfp_case"],
        // Если diet_plan может быть null или отсутствовать,
        // возможно, потребуется `(json["diet_plan"] as List?)?.map(...)?.toList() ?? []`
        dietPlan: List<DietPlan>.from(json["diet_plan"].map((x) => DietPlan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "bmi_case": bmiCase,
        "bfp_case": bfpCase,
        "diet_plan": List<dynamic>.from(dietPlan.map((x) => x.toJson())),
      };
}

class DietPlan {
  final int day;
  final String? dietName; // Сделано nullable
  final String? description; // Сделано nullable
  final List<Meal> meals;

  DietPlan({
    required this.day,
    required this.dietName,
    required this.description,
    required this.meals,
  });

  factory DietPlan.fromJson(Map<String, dynamic> json) => DietPlan(
        day: json["day"],
        dietName: json["diet_name"],
        description: json["description"],
        // Аналогично, если meals может быть null
        meals: List<Meal>.from(json["meals"].map((x) => Meal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "diet_name": dietName,
        "description": description,
        "meals": List<dynamic>.from(meals.map((x) => x.toJson())),
      };
}

class Meal {
  final String? name; // Сделано nullable
  final String? type; // Сделано nullable
  final String? description; // Сделано nullable
  final double? calories; // Уже был nullable

  Meal({
    required this.name,
    required this.type,
    required this.description,
    required this.calories,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        name: json["name"],
        type: json["type"],
        description: json["description"],
        calories: json["calories"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "type": type,
        "description": description,
        "calories": calories,
      };
}