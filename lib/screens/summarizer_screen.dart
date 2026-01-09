import 'package:flutter/material.dart';
import 'package:prompt_vault/services/ai_service.dart';

class SummarizerScreen extends StatefulWidget {
  const SummarizerScreen({super.key});

  @override
  State<SummarizerScreen> createState() => _SummarizerScreenState();
}

class _SummarizerScreenState extends State<SummarizerScreen> {
  final TextEditingController _controller = TextEditingController();
  final AIService _aiService = AIService();
  String _result = "";
  bool _isLoading = false;

  void _handleSummarize() async {
    setState(() {
      _isLoading = true;
      _result = "";
    });

    final summary = await _aiService.summarize(_controller.text);

    setState(() {
      _result = summary;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("AI Text Summarizer")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _controller,
              maxLines: 8,
              decoration: const InputDecoration(
                hintText: "Paste your long text here...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isLoading ? null : _handleSummarize,
              child: _isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Summarize Text"),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  _result,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
