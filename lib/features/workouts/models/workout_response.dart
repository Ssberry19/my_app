import 'dart:convert';

WorkoutResponse workoutResponseFromJson(String str) => WorkoutResponse.fromJson(json.decode(str));

String workoutResponseToJson(WorkoutResponse data) => json.encode(data.toJson());

class WorkoutResponse {
  String status;
  String bmiCase;
  String bfpCase;
  List<WorkoutPlan> workoutPlan;

  WorkoutResponse({
    required this.status,
    required this.bmiCase,
    required this.bfpCase,
    required this.workoutPlan,
  });

  factory WorkoutResponse.fromJson(Map<String, dynamic> json) => WorkoutResponse(
        status: json["status"],
        bmiCase: json["bmi_case"],
        bfpCase: json["bfp_case"],
        workoutPlan: List<WorkoutPlan>.from(json["workout_plan"].map((x) => WorkoutPlan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "bmi_case": bmiCase,
        "bfp_case": bfpCase,
        "workout_plan": List<dynamic>.from(workoutPlan.map((x) => x.toJson())),
      };
}

class WorkoutPlan {
  int day;
  String workoutName;
  String description;
  List<Exercise> exercises;

  WorkoutPlan({
    required this.day,
    required this.workoutName,
    required this.description,
    required this.exercises,
  });

  factory WorkoutPlan.fromJson(Map<String, dynamic> json) => WorkoutPlan(
        day: json["day"],
        workoutName: json["workout_name"],
        description: json["description"],
        exercises: List<Exercise>.from(json["exercises"].map((x) => Exercise.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "workout_name": workoutName,
        "description": description,
        "exercises": List<dynamic>.from(exercises.map((x) => x.toJson())),
      };
}

class Exercise {
  String name;
  int sets;
  dynamic reps; // Could be String or int, use dynamic
  String target;
  String notes;
  double caloriesBurned;

  Exercise({
    required this.name,
    required this.sets,
    required this.reps,
    required this.target,
    required this.notes,
    required this.caloriesBurned,
  });

  factory Exercise.fromJson(Map<String, dynamic> json) => Exercise(
        name: json["name"],
        sets: json["sets"],
        reps: json["reps"],
        target: json["target"],
        notes: json["notes"],
        caloriesBurned: json["calories_burned"]?.toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "sets": sets,
        "reps": reps,
        "target": target,
        "notes": notes,
        "calories_burned": caloriesBurned,
      };
}