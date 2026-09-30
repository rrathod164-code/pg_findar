import 'package:flutter/material.dart';

/// Reusable background theme widget matching the User Dashboard design.
/// Features the signature soft canvas (Color(0xFFFBFDFD)) with translucent
/// mint/teal accent circles (Color(0xFFE2F7F4)) for a clean, cohesive look.
class DashboardBackground extends StatelessWidget {
  final Widget child;

  const DashboardBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: [
        // Base Background Canvas
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromARGB(255, 215, 241, 241),
        ),

        // 1. Top Right Accent Circle
        Positioned(
          top: -40,
          right: -40,
          child: IgnorePointer(
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(
                  255,
                  155,
                  235,
                  223,
                ).withValues(alpha: 0.7),
              ),
            ),
          ),
        ),

        // 2. Middle Right Accent Circle
        Positioned(
          top: screenHeight * 0.38,
          right: -50,
          child: IgnorePointer(
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(
                  255,
                  155,
                  235,
                  223,
                ).withValues(alpha: 0.5),
              ),
            ),
          ),
        ),

        // 3. Lower Left Accent Circle
        Positioned(
          bottom: screenHeight * 0.12,
          left: -40,
          child: IgnorePointer(
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color.fromARGB(
                  255,
                  155,
                  235,
                  223,
                ).withValues(alpha: 0.4),
              ),
            ),
          ),
        ),

        // Main Page Content
        child,
      ],
    );
  }
}
