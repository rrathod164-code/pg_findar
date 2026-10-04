import 'package:flutter/material.dart';

/// ============================================================================
/// 🎨 APP CENTRAL COLOR PALETTE (AppColors)
/// ============================================================================
/// Change colors here to instantly reflect across all screens, buttons,
/// inputs, icons, and UI widgets throughout the entire application.
/// ============================================================================
class AppColors {
  // ===========================================================================
  // 1. BRAND & PRIMARY COLORS
  // (Change `primary` to change the main app theme color everywhere!)
  // ===========================================================================
  static const Color primary = Color(
    0xFF13B99D,
  ); // Main Brand Color (Mint Teal)
  static const Color primaryLight = Color.fromARGB(
    255,
    209,
    241,
    238,
  ); // Soft Tint / Badge Background
  static const Color primaryDark = Color(0xFF0E8E78); // Darker Brand Accent
  static const Color primaryTint = Color(0xFFB9F2E9); // Secondary Accent Shade

  // ===========================================================================
  // 2. BACKGROUND & SURFACE COLORS
  // ===========================================================================
  static const Color background = Color(0xFFFBFDFD); // Off-White Canvas
  static const Color surface = Colors.white; // Card / Sheet / Modal Background
  static const Color cardBg = Colors.white;

  // ===========================================================================
  // 3. TEXT & CONTENT COLORS
  // ===========================================================================
  static const Color textDark = Color(0xFF091A2A); // Headings & Titles
  static const Color textGrey = Color(0xFF758595); // Subtitles & Captions
  static const Color textLight = Color(0xFF9CA3AF); // Light Hint & Muted Text
  static const Color inputHint = Color(0xFFB0BAC5); // Text Field Hint

  // ===========================================================================
  // 4. ACCENT & STATUS COLORS
  // ===========================================================================
  static const Color success = Color(0xFF10B981); // Completed / Green Badge
  static const Color successLight = Color(0xFFD1FAE5); // Green Badge Background
  static const Color warning = Color(0xFFF97316); // Review / Orange
  static const Color error = Color(0xFFEF4444); // Cancelled / Red Badge
  static const Color errorLight = Color(0xFFFEE2E2); // Red Badge Background
  static const Color starAmber = Color(0xFFFFC107); // Star Ratings

  // ===========================================================================
  // 5. BORDER & DIVIDER COLORS
  // ===========================================================================
  static const Color border = Color(0xFFE5E7EB); // Subtle Border Grey
  static const Color divider = Color(0xFFF3F4F6); // Soft Divider Grey
  static const Color cardShadow = Color(0x0A000000); // 4% Soft Shadow

  // ===========================================================================
  // 6. ONBOARDING & GRADIENT COLORS
  // ===========================================================================
  static const Color introGradientTop = Color(0xFFF1FBFA);
  static const Color introGradientBottom = Color(0xFFB9F2E9);

  /// Helper Gradient for Onboarding Screen
  static const LinearGradient introGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [introGradientTop, introGradientBottom],
  );
}

/// ============================================================================
/// CENTRAL APP THEME
/// ============================================================================
/// Central ThemeData configuration used by MaterialApp in main.dart.
/// ============================================================================
class AppTheme {
  // Central Light Theme for the entire PG Finder application
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: AppColors.background,

      // Color Scheme
      colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.primary,
        primary: AppColors.primary,
        surface: AppColors.surface,
        brightness: Brightness.light,
      ),

      // AppBar Theme (Clean, transparent, centered)
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        centerTitle: true,
        titleTextStyle: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textDark,
        ),
        iconTheme: IconThemeData(color: AppColors.textDark),
      ),

      // Elevated Button Theme (Primary rounded buttons)
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: Colors.white,
          elevation: 0,
          textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // Outlined Button Theme
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),

      // Text Button Theme
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
        ),
      ),

      // Card Theme
      cardTheme: const CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(16)),
          side: BorderSide(color: AppColors.border, width: 0.8),
        ),
      ),

      // Input Field / TextField Theme
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        hintStyle: const TextStyle(color: AppColors.inputHint, fontSize: 14),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
        ),
      ),
    );
  }
}
