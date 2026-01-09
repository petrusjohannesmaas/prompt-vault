import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'screens/summarizer_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const SummarizerApp());
}

class SummarizerApp extends StatelessWidget {
  const SummarizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Summarizer',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const SummarizerScreen(),
    );
  }
}
