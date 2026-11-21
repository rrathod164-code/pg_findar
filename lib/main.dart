import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'resources/theme.dart';
import 'screens/auth/intro_screen.dart';
import 'services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Make system status bar & bottom navigation bar transparent (no black bar)
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarContrastEnforced: false,
    ),
  );

  await FirebaseService.initialize();
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
