import 'package:flutter/material.dart';
import 'package:prompt_vault/services/ai_service.dart';
import 'package:prompt_vault/services/firestore_service.dart';

class SummarizerScreen extends StatefulWidget {
  final VoidCallback? onSaveSuccess;

  const SummarizerScreen({super.key, this.onSaveSuccess});

  @override
  State<SummarizerScreen> createState() => _SummarizerScreenState();
}

class _SummarizerScreenState extends State<SummarizerScreen> {
  final TextEditingController _goalController = TextEditingController();
  final TextEditingController _contextController = TextEditingController();
  final TextEditingController _successController = TextEditingController();
  final TextEditingController _responseController = TextEditingController();

  final AIService _aiService = AIService();
  final FirestoreService _firestoreService = FirestoreService();
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
    });

    final combinedInput =
        '''
      GOAL: ${_goalController.text}
      CONTEXT: ${_contextController.text}
      SUCCESS CRITERIA: ${_successController.text}
      RESPONSE FORMAT: ${_responseController.text}
    ''';

    final responseMap = await _aiService.summarize(combinedInput);

    if (mounted) {
      final title = responseMap["title"]!;
      final body = responseMap["body"]!;

      try {
        await _firestoreService.savePrompt(title, body);

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Summary saved to Vault!")),
          );

          // Clear inputs
          _goalController.clear();
          _contextController.clear();
          _successController.clear();
          _responseController.clear();

          setState(() {
            _isLoading = false;
          });

          // Redirect if callback is provided
          widget.onSaveSuccess?.call();
        }
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text("Error saving to vault: $e")));
          setState(() {
            _isLoading = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
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
                          : const Text("Generate Summary"),
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
