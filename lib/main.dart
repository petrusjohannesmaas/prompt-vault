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

// Global theme notifier
final ValueNotifier<ThemeMode> themeModeNotifier = ValueNotifier(
  ThemeMode.system,
);

class SummarizerApp extends StatefulWidget {
  const SummarizerApp({super.key});

  @override
  State<SummarizerApp> createState() => _SummarizerAppState();
}

class _SummarizerAppState extends State<SummarizerApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangePlatformBrightness() {
    // If the system theme changes, reset our override to system
    // so the app adapts to the new system preference.
    themeModeNotifier.value = ThemeMode.system;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeModeNotifier,
      builder: (context, currentMode, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Prompt Vault',
          themeMode: currentMode,
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
              bodyMedium: GoogleFonts.ubuntuSans(
                color: const Color(0xFF1E1E2F),
              ),
              displaySmall: GoogleFonts.ubuntuSansMono(
                color: const Color(0xFF1E1E2F),
              ),
            ),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            colorScheme: const ColorScheme(
              brightness: Brightness.dark,
              primary: Color(0xFF7B69F2), // Purple
              onPrimary: Colors.white,
              secondary: Color(0xFF4FCEA9), // Teal
              onSecondary: Colors.white,
              error: Color(0xFFE74C3C), // Crimson
              onError: Colors.white,
              surface: Color(0xFF2A2A3D), // Darker Gray
              onSurface: Colors.white,
            ),
            scaffoldBackgroundColor: const Color(0xFF1E1E2F), // Charcoal
            textTheme: TextTheme(
              displayLarge: const TextStyle(
                fontSize: 72,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              titleLarge: GoogleFonts.ubuntu(fontSize: 30, color: Colors.white),
              bodyMedium: GoogleFonts.ubuntuSans(color: Colors.white),
              displaySmall: GoogleFonts.ubuntuSansMono(color: Colors.white),
            ),
            useMaterial3: true,
          ),

          home: const VaultScreen(),
          builder: (context, child) {
            // Global Zoom: 150%
            // We constrain the app to 2/3rds of the screen size, then scale it up 1.5x.
            // This effectively lowers the density, making everything appear bigger.
            return Transform.scale(
              scale: 1.5,
              alignment: Alignment.center,
              child: FractionallySizedBox(
                widthFactor: 1.0 / 1.5,
                heightFactor: 1.0 / 1.5,
                alignment: Alignment.center,
                child: child,
              ),
            );
          },
        );
      },
    );
  }
}
