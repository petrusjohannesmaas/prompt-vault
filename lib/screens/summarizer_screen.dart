import 'package:flutter/material.dart';
import 'package:prompt_vault/services/ai_service.dart';

class SummarizerScreen extends StatefulWidget {
  const SummarizerScreen({super.key});

  @override
  State<SummarizerScreen> createState() => _SummarizerScreenState();
}

class _SummarizerScreenState extends State<SummarizerScreen> {
  // 1. Define 4 controllers for your new fields
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _contextController = TextEditingController();
  final TextEditingController _successController = TextEditingController();
  final TextEditingController _responseController = TextEditingController();

  final AIService _aiService = AIService();
  String _result = "";
  bool _isLoading = false;

  void _handleSummarize() async {
    // Basic validation for required fields
    if (_goalController.text.isEmpty || _responseController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill in the required fields.")),
      );
      return;
    }

    setState(() {
      _isLoading = true;
      _result = "";
    });

    // 2. Combine inputs into a single structured string
    final combinedInput =
        '''
      GOAL: ${_goalController.text}
      CONTEXT: ${_contextController.text}
      SUCCESS CRITERIA: ${_successController.text}
      RESPONSE FORMAT: ${_responseController.text}
    ''';

    final summary = await _aiService.summarize(combinedInput);

    setState(() {
      _result = summary;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Prompt Builder")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                // Changed to allow all text fields to fit
                child: Column(
                  children: [
                    _buildInputField(
                      _goalController,
                      "What are you trying to accomplish? (Required)",
                      3,
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(
                      _contextController,
                      "What does the AI need to know?",
                      3,
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(
                      _successController,
                      "What does success look like for you?",
                      3,
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(
                      _responseController,
                      "How should the AI respond? (Required)",
                      3,
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _handleSummarize,
                      child: _isLoading
                          ? const CircularProgressIndicator()
                          : const Text("Generate Response"),
                    ),
                    const SizedBox(height: 20),
                    const Divider(),
                    Text(
                      _result,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to keep the code clean
  Widget _buildInputField(
    TextEditingController controller,
    String label,
    int lines,
  ) {
    return TextField(
      controller: controller,
      maxLines: lines,
      decoration: InputDecoration(
        labelText: label,
        alignLabelWithHint: true,
        border: const OutlineInputBorder(),
      ),
    );
  }
}
