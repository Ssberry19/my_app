import 'dart:convert';

CycleResponse cycleResponseFromJson(String str) => 
    CycleResponse.fromJson(json.decode(str));

String cycleResponseToJson(CycleResponse data) => 
    json.encode(data.toJson());

class CycleResponse {
  final String predictedPhase;
  final double confidence;

  CycleResponse({
    required this.predictedPhase,
    required this.confidence,
  });

  factory CycleResponse.fromJson(Map<String, dynamic> json) => CycleResponse(
        predictedPhase: json["predicted_phase"],
        confidence: json["confidence"].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        "predicted_phase": predictedPhase,
        "confidence": confidence,
      };
}