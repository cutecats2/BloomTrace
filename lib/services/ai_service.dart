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
        "Analyze this product for safety and nutrition. "
        "Return JSON with EXACTLY these keys: "
        "{ 'name': string, 'recalled': boolean, 'recall_reason': string, ... } "
        "CRITICAL: Always include 'recalled'. If no recall is found, set 'recalled' to false "
        "and set 'recall_reason' to 'No active recalls found as of 2026.'"
        "Return ONLY a JSON object: "
        "{"
        "  'name': 'string', "
        "  'recalled': boolean, "
        "  'recall_reason': 'string or null', " // This is where the info goes
        "  'nutrition': {'calories': int, 'protein': 'string', 'fat': 'string', 'carbs': 'string'}, "
        "  'nutritionScore': number"
        "}"
      ),
      DataPart('image/jpeg', imageBytes),
    ])
    ];

    final response = await _model.generateContent(prompt);
      final text = response.text;

      if (text == null) throw Exception("No response from AI");

      // 1. Clean the response (Gemini often wraps JSON in ```json ... ```)
      final cleanedJson = text.replaceAll('```json', '').replaceAll('```', '').trim();

      // 2. Decode the string into a Map
      final Map<String, dynamic> data = jsonDecode(cleanedJson);

      // 3. Use the .fromJson factory we built in the model
      // This automatically handles the nested Nutrition and Recall fields
      return ScannedProduct.fromJson(data);
    }
  }

