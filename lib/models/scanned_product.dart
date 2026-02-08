import 'package:cloud_firestore/cloud_firestore.dart';

class ScannedProduct {
  final String name;
  final bool recalled;
  final String? recallReason;
  final Nutrition nutrition;
  final double nutritionScore;
  final DateTime scannedAt;

  ScannedProduct({
    required this.name,
    required this.recalled,
    this.recallReason,
    required this.nutrition,
    required this.nutritionScore,
    required this.scannedAt,
  });

  // Convert JSON from Gemini into this Object
  factory ScannedProduct.fromJson(Map<String, dynamic> json) {
    return ScannedProduct(
      name: json['name'] ?? 'Unknown',
      recalled: json['recalled'] ?? false,
      recallReason: json['recall_reason'],
      nutrition: Nutrition.fromJson(json['nutrition'] ?? {}),
      nutritionScore: (json['nutritionScore'] ?? 0).toDouble(),
      scannedAt: DateTime.now(),
    );
  }

  // Convert Object into a Map for Firestore
  Map<String, dynamic> toJson() => {
        'name': name,
        'recalled': recalled,
        'recall_reason': recallReason,
        'nutrition': nutrition.toJson(),
        'nutritionScore': nutritionScore,
        'scannedAt': Timestamp.fromDate(scannedAt), // Uses native Firestore dates
      };
}

class Nutrition {
  final int calories;
  final String protein;
  final String fat;
  final String carbs;

  Nutrition({this.calories = 0, this.protein = '0g', this.fat = '0g', this.carbs = '0g'});

  factory Nutrition.fromJson(Map<String, dynamic> json) {
    return Nutrition(
      calories: json['calories'] ?? 0,
      protein: json['protein'] ?? '0g',
      fat: json['fat'] ?? '0g',
      carbs: json['carbs'] ?? '0g',
    );
  }

  Map<String, dynamic> toJson() => {
        'calories': calories,
        'protein': protein,
        'fat': fat,
        'carbs': carbs,
      };
}