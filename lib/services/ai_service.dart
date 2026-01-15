import 'dart:convert';
import 'package:firebase_ai/firebase_ai.dart';

class AIService {
  final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash',
    generationConfig: GenerationConfig(responseMimeType: 'application/json'),
  );

  Future<Map<String, String>> summarize(
    String structuredInput,
    String promptType,
  ) async {
    final prompt = [
      Content.text(
        "Based on these requirements: $structuredInput.\n"
        "PROMPT TYPE: $promptType.\n"
        "Provide a response with the following JSON keys: 'title' and 'body'.",
      ),
    ];

    try {
      final response = await model.generateContent(prompt);
      final String? rawText = response.text;

      if (rawText == null || rawText.isEmpty) {
        return {"title": "Error", "body": "AI returned an empty response."};
      }

      final Map<String, dynamic> data = jsonDecode(rawText);

      return {
        "title": data["title"]?.toString() ?? "No Title",
        "body": data["body"]?.toString() ?? "No Content",
      };
    } catch (e) {
      return {
        "title": "Parsing Error",
        "body": "The AI response was not in the expected format. Details: $e",
      };
    }
  }
}
