import 'package:flutter/material.dart';
import 'package:pg_findar/resources/theme.dart';

class DashboardBackground extends StatelessWidget {
  final Widget child;

  const DashboardBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final primaryColor = AppColors.primary;

    return Stack(
      children: [
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color.fromARGB(255, 200, 250, 244),
        ),

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

        child,
      ],
    );
  }
}
