import 'package:flutter/material.dart';
import 'package:pg_findar/resources/theme.dart';

/// Reusable background theme widget matching the User Dashboard design.
/// Features the signature soft canvas with translucent brand accent circles
/// for a clean, cohesive look derived dynamically from [AppColors].
class DashboardBackground extends StatelessWidget {
  final Widget child;

  const DashboardBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final primaryColor = AppColors.primary;

    return Stack(
      children: [
        // Base Background Canvas
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromARGB(255, 200, 250, 244),
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
                color: primaryColor.withValues(alpha: 0.16),
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
                color: primaryColor.withValues(alpha: 0.10),
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
                color: primaryColor.withValues(alpha: 0.08),
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
