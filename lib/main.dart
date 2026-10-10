import 'package:flutter/material.dart';
import 'resources/theme.dart';
import 'screens/auth/intro_screen.dart';

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
      theme: AppTheme.lightTheme,
      home: const IntroScreen(),
    );
  }
}
