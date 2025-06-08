import 'dart:convert';

WorkoutRequest workoutRequestFromJson(String str) => WorkoutRequest.fromJson(json.decode(str));

String workoutRequestToJson(WorkoutRequest data) => json.encode(data.toJson());

class WorkoutRequest {
  double heightCm;
  double weightKg;
  String goal;
  
    String gender;
    int age;
  String menstrualPhase;
  double bodyFatPercentage;
  int days;

  WorkoutRequest({
    required this.heightCm,
    required this.weightKg,
    required this.age,
    required this.gender,
    required this.goal,
    required this.menstrualPhase,
    required this.bodyFatPercentage,
    required this.days,
  });

  factory WorkoutRequest.fromJson(Map<String, dynamic> json) => WorkoutRequest(
        heightCm: json["height_cm"]?.toDouble(),
        weightKg: json["weight_kg"]?.toDouble(),
        age: json["age"],
        gender: json["gender"],
        goal: json["goal"],
        menstrualPhase: json["menstrual_phase"],
        bodyFatPercentage: json["body_fat_percentage"]?.toDouble(),
        days: json["days"],
      );

  Map<String, dynamic> toJson() => {
        "height_cm": heightCm,
        "weight_kg": weightKg,
        "age": age,
        "gender": gender,
        "goal": goal,
        "menstrual_phase": menstrualPhase,
        "body_fat_percentage": bodyFatPercentage,
        "days": days,
      };
}