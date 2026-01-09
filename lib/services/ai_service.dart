import 'package:firebase_ai/firebase_ai.dart';

class AIService {
  // Initialize the model (using gemini-2.5-flash for speed and efficiency)
  final model = FirebaseAI.googleAI().generativeModel(
    model: 'gemini-2.5-flash',
  );

  Future<String> summarize(String userInput) async {
    // Create the prompt instructions
    final prompt = [
      Content.text(
        "Please provide a concise summary of the following text: \n\n $userInput",
      ),
    ];

    try {
      final response = await model.generateContent(prompt);
      return response.text ?? "Could not generate summary.";
    } catch (e) {
      return "Error: $e";
    }
  }
}
