import 'package:flutter/material.dart';
import 'screens/auth/intro_screen.dart';

/// ============================================================================
/// APPLICATION ENTRY POINT
/// ============================================================================
/// Initializes and launches the PG Finder Flutter application.
/// ============================================================================

void main() {
  runApp(const PGFinderApp());
}

class PGFinderApp extends StatelessWidget {
  const PGFinderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PG Finder',
      theme: ThemeData(
        fontFamily: 'Roboto',
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFBFDFD),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF13B99D),
          primary: const Color(0xFF13B99D),
        ),
      ),
      home: const IntroScreen(),
    );
  }
}
