import 'package:flutter/material.dart';
export 'placeholders.dart';

class OwnerColors {
  static const Color primary = Color(0xFF13B99D);
  static const Color primaryDark = Color(0xFF0F9B83);
  static const Color primaryTint = Color(0xFFB9F2E9);
  static const Color tealDeep = Color(0xFF0F766E);
  static const Color tealMedium = Color(0xFF0D9488);
  static const Color tealAccent = Color(0xFF00A896);
  static const Color mintLight = Color(0xFFD2F5EC);
  static const Color mintSoft = Color(0xFFDFF8F3);
  static const Color mintBg = Color(0xFFE8F8F5);
  static const Color mintBorder = Color(0xFFB8E8DE);
  static const Color mintSurface = Color(0xFFF0FAF7);
  static const Color mintDivider = Color(0xFFD6E6E2);

  static const Color background = Color(0xFFFBFDFD);
  static const Color surface = Colors.white;
  static const Color inputFill = Color(0xFFF6F9F8);
  static const Color cardBg = Color(0xFFF9FBFA);
  static const Color divider = Color(0xFFF3F4F6);
  static const Color border = Color(0xFFE5E7EB);

  static const Color textDark = Color(0xFF132230);
  static const Color textHeading = Color(0xFF091A2A);
  static const Color textNavUnselected = Color(0xFF1E293B);
  static const Color textGrey = Color(0xFF758595);
  static const Color textMuted = Color(0xFF637688);
  static const Color textProfileMuted = Color(0xFF6B8780);
  static const Color textCaption = Color(0xFF8B98A5);
  static const Color textHint = Color(0xFF9CA3AF);
  static const Color textDisabled = Color(0xFF9E9E9E);

  static const Color success = Color(0xFF27AE60);
  static const Color successDark = Color(0xFF059669);
  static const Color successBg = Color(0xFFE6F8F0);

  static const Color warning = Color(0xFFFB8C00);
  static const Color warningAlt = Color(0xFFE67E22);
  static const Color warningBg = Color(0xFFFFF3E0);
  static const Color warningBgAlt = Color(0xFFFFF6E0);
  static const Color warningAmber = Color(0xFFFFB300);

  static const Color error = Color(0xFFE53935);
  static const Color errorAlt = Color(0xFFEF4444);
  static const Color errorDark = Color(0xFFDC2626);
  static const Color errorBg = Color(0xFFFFECEE);
  static const Color errorBorder = Color(0xFFFFCDD2);

  static const LinearGradient earningsGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
}
