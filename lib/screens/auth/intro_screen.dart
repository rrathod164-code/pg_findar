import 'package:flutter/material.dart';
import 'login_screen.dart';

/// ============================================================================
/// SPLASH / GET STARTED ONBOARDING SCREEN
/// ============================================================================
/// The entry onboarding screen of the app.
/// ============================================================================

class IntroScreen extends StatelessWidget {
  const IntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF1FBFA), Color(0xFFB9F2E9)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Illustration Image
              Expanded(
                child: Center(
                  child: Image.asset(
                    'assets/intro.png',
                    fit: BoxFit.contain,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) => Container(
                      padding: const EdgeInsets.all(32),
                      child: const Icon(
                        Icons.apartment_rounded,
                        size: 100,
                        color: Color(0xFF13B99D),
                      ),
                    ),
                  ),
                ),
              ),

              // 'Get start' Button
              Padding(
                padding: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.07,
                  right: MediaQuery.of(context).size.width * 0.07,
                  bottom: MediaQuery.of(context).size.height * 0.06,
                ),
                child: SizedBox(
                  width: double.infinity,
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const LoginScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF13B99D),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: const Text(
                      'Get start',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Alias for compatibility
typedef Introduction = IntroScreen;
