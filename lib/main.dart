import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/vault_screen.dart';

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
      debugShowCheckedModeBanner: false,
      title: 'Prompt Vault',
      theme: ThemeData(
        colorScheme: const ColorScheme(
          brightness: Brightness.light,
          primary: Color(0xFF7B69F2), // Purple
          onPrimary: Colors.white,
          secondary: Color(0xFF4FCEA9), // Teal
          onSecondary: Colors.white,
          error: Color(0xFFE74C3C), // Crimson
          onError: Colors.white,
          surface: Colors.white,
          onSurface: Color(0xFF1E1E2F), // Charcoal
        ),
        scaffoldBackgroundColor: const Color(0xFFF9F9FB), // Off-white
        textTheme: TextTheme(
          displayLarge: const TextStyle(
            fontSize: 72,
            fontWeight: FontWeight.bold,
          ),
          titleLarge: GoogleFonts.ubuntu(
            fontSize: 30,
            color: const Color(0xFF1E1E2F),
          ),
          bodyMedium: GoogleFonts.ubuntuSans(color: const Color(0xFF1E1E2F)),
          displaySmall: GoogleFonts.ubuntuSansMono(
            color: const Color(0xFF1E1E2F),
          ),
        ),
        useMaterial3: true,
      ),
      home: const VaultScreen(),
    );
  }
}
