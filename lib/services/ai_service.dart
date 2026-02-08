import 'dart:convert';
import 'dart:typed_data';
import 'package:google_generative_ai/google_generative_ai.dart';
import '../models/scanned_product.dart';

class AIService {
  final _model = GenerativeModel(
    model: 'gemini-2.0-flash',
    apiKey: const String.fromEnvironment('GEMINI_KEY'),
  );

  Future<ScannedProduct> analyzeProduct(Uint8List imageBytes) async {
    final prompt = [
      Content.multi([
        TextPart(
          "You are a grocery AI. Analyze this product image and return a JSON object: "
          "{'name': string, 'recalled': bool, 'nutritionScore': number 0-100}. "
          "Output only JSON."
        ),
        DataPart('image/jpeg', imageBytes),
      ])
    ];

    final response = await _model.generateContent(prompt);
    final text = response.text;

    if (text == null) throw Exception("No response from AI");

    final jsonStart = text.indexOf('{');
    final jsonEnd = text.lastIndexOf('}');
    if (jsonStart == -1 || jsonEnd == -1) throw Exception("Invalid JSON: $text");

    final jsonString = text.substring(jsonStart, jsonEnd + 1);
    final data = jsonDecode(jsonString);

    return ScannedProduct(
      name: data['name'] ?? 'Unknown',
      recalled: data['recalled'] ?? false,
      nutritionScore: (data['nutritionScore'] ?? 0).toDouble(),
      scannedAt: DateTime.now(),
    );
  }
}
