class ScannedProduct {
  final String name;
  final bool recalled;
  final double nutritionScore;
  final DateTime scannedAt;

  ScannedProduct({
    required this.name,
    required this.recalled,
    required this.nutritionScore,
    required this.scannedAt,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'recalled': recalled,
        'nutritionScore': nutritionScore,
        'scannedAt': scannedAt.toIso8601String(),
      };
}
