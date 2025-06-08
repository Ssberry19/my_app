import 'dart:convert';

class CycleRequest {
  final int age;
  final int heightCm;
  final int weightKg;
  final double bmi;
  final double bfp;
  final int cycleDay;
  final int cycleLength;

  CycleRequest({
    required this.age,
    required this.heightCm,
    required this.weightKg,
    required this.bmi,
    required this.bfp,
    required this.cycleDay,
    required this.cycleLength,
  });

  Map<String, dynamic> toJson() {
    return {
      'age': age,
      'height_cm': heightCm,
      'weight_kg': weightKg,
      'bmi': bmi,
      'bfp': bfp,
      'cycle_day': cycleDay,
      'cycle_length': cycleLength,
    };
  }

  String toJsonString() => json.encode(toJson());
}