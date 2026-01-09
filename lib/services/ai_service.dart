import 'package:firebase_ai/firebase_ai.dart';

class AIService {
  final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash',
  );

  Future<String> summarize(String structuredInput) async {
    // 3. Updated prompt to handle the new structured input
    final prompt = [
      Content.text(
        "You are a helpful assistant. Based on the following structured requirements, please provide a tweet length, ambiguous response:\n\n$structuredInput",
      ),
    ];

    try {
      final response = await model.generateContent(prompt);
      return response.text ?? "Could not generate a response.";
    } catch (e) {
      return "Error: $e";
    }
  }
}
