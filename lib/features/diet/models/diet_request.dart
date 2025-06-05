// models/diet_request.dart
import 'dart:convert';

class DietRequest {
  final int heightCm;
  final int weightKg;
  final int age;
  final String gender;
  final String goal;
  final double targetWeight;
  final String activityLevel;
  final List<String> allergens;
  final int days;

  DietRequest({
    required this.heightCm,
    required this.weightKg,
    required this.age,
    required this.gender,
    required this.goal,
    required this.targetWeight,
    required this.activityLevel,
    required this.allergens,
    required this.days,
  });

  Map<String, dynamic> toJson() {
    return {
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'age': age,
      'gender': gender,
      'goal': goal,
      'target_weight': targetWeight,
      'activity_level': activityLevel,
      'allergens': allergens,
      'days': days,
    };
  }
}

String dietRequestToJson(DietRequest data) => json.encode(data.toJson());