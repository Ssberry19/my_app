import 'dart:convert';

DietResponse dietResponseFromJson(String str) => 
    DietResponse.fromJson(json.decode(str));

String dietResponseToJson(DietResponse data) => 
    json.encode(data.toJson());

class DietResponse {
  final String summary;
  final int dailyCalories;
  final MacronutrientDistribution macronutrientDistribution;
  final List<DayPlan> plan;

  DietResponse({
    required this.summary,
    required this.dailyCalories,
    required this.macronutrientDistribution,
    required this.plan,
  });

  factory DietResponse.fromJson(Map<String, dynamic> json) => DietResponse(
        summary: json["summary"],
        dailyCalories: json["daily_calories"],
        macronutrientDistribution: 
            MacronutrientDistribution.fromJson(json["macronutrient_distribution"]),
        plan: List<DayPlan>.from(json["plan"].map((x) => DayPlan.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "summary": summary,
        "daily_calories": dailyCalories,
        "macronutrient_distribution": macronutrientDistribution.toJson(),
        "plan": List<dynamic>.from(plan.map((x) => x.toJson())),
      };
}

class MacronutrientDistribution {
  final int proteinPercentage;
  final int carbPercentage;
  final int fatPercentage;

  MacronutrientDistribution({
    required this.proteinPercentage,
    required this.carbPercentage,
    required this.fatPercentage,
  });

  factory MacronutrientDistribution.fromJson(Map<String, dynamic> json) => 
      MacronutrientDistribution(
        proteinPercentage: json["protein_percentage"],
        carbPercentage: json["carb_percentage"],
        fatPercentage: json["fat_percentage"],
      );

  Map<String, dynamic> toJson() => {
        "protein_percentage": proteinPercentage,
        "carb_percentage": carbPercentage,
        "fat_percentage": fatPercentage,
      };
}

class DayPlan {
  final int day;
  final List<Meal> meals;

  DayPlan({
    required this.day,
    required this.meals,
  });

  factory DayPlan.fromJson(Map<String, dynamic> json) => DayPlan(
        day: json["day"],
        meals: List<Meal>.from(json["meals"].map((x) => Meal.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "day": day,
        "meals": List<dynamic>.from(meals.map((x) => x.toJson())),
      };
}

class Meal {
  final String name;
  final String description;
  final int calories;
  final int proteinG;
  final int carbsG;
  final int fatG;

  Meal({
    required this.name,
    required this.description,
    required this.calories,
    required this.proteinG,
    required this.carbsG,
    required this.fatG,
  });

  factory Meal.fromJson(Map<String, dynamic> json) => Meal(
        name: json["name"],
        description: json["description"],
        calories: json["calories"],
        proteinG: json["protein_g"],
        carbsG: json["carbs_g"],
        fatG: json["fat_g"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "description": description,
        "calories": calories,
        "protein_g": proteinG,
        "carbs_g": carbsG,
        "fat_g": fatG,
      };
}