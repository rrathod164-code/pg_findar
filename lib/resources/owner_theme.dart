import 'package:flutter/material.dart';

/// ============================================================================
/// 🏢 OWNER CENTRAL COLOR PALETTE (OwnerColors)
/// ============================================================================
/// Change colors here to instantly reflect across all owner screens,
/// cards, buttons, badges, navigation bar, and input fields.
/// ============================================================================
class OwnerColors {
  // ===========================================================================
  // 1. BRAND & PRIMARY TEAL ACCENTS
  // ===========================================================================
  static const Color primary = Color(0xFF13B99D); // Main Brand Mint Teal
  static const Color primaryDark = Color(0xFF0F9B83); // Dark Teal (Gradient end)
  static const Color primaryTint = Color(0xFFB9F2E9); // Secondary Accent Mint Tint
  static const Color tealDeep = Color(0xFF0F766E); // Deep Teal (Text & Accents)
  static const Color tealMedium = Color(0xFF0D9488); // Medium Teal (Icons & Subtitles)
  static const Color tealAccent = Color(0xFF00A896); // Accent Teal
  static const Color mintLight = Color(0xFFD2F5EC); // Mint Chip / Icon Circle Background
  static const Color mintSoft = Color(0xFFDFF8F3); // Soft Mint Accent Background
  static const Color mintBg = Color(0xFFE8F8F5); // Light Mint Card / Container Fill
  static const Color mintBorder = Color(0xFFB8E8DE); // Mint Card / Chip Border
  static const Color mintSurface = Color(0xFFF0FAF7); // Very Soft Mint Surface
  static const Color mintDivider = Color(0xFFD6E6E2); // Profile & Section Divider Mint

  // ===========================================================================
  // 2. BACKGROUND & SURFACE COLORS
  // ===========================================================================
  static const Color background = Color(0xFFFBFDFD); // Main Page Background
  static const Color surface = Colors.white; // Card / Modal / Sheet Surface
  static const Color inputFill = Color(0xFFF6F9F8); // TextField / Dropdown Fill
  static const Color cardBg = Color(0xFFF9FBFA); // Subtle Card Background
  static const Color divider = Color(0xFFF3F4F6); // Light Divider Grey
  static const Color border = Color(0xFFE5E7EB); // Border Grey

  // ===========================================================================
  // 3. TEXT & TYPOGRAPHY COLORS
  // ===========================================================================
  static const Color textDark = Color(0xFF132230); // Primary Headers & Dark Titles
  static const Color textHeading = Color(0xFF091A2A); // Main Screen Titles / Heavy Dark
  static const Color textNavUnselected = Color(0xFF1E293B); // Bottom Nav Unselected Label & Icon
  static const Color textGrey = Color(0xFF758595); // Secondary Labels & Subtitles
  static const Color textMuted = Color(0xFF637688); // Muted Text
  static const Color textProfileMuted = Color(0xFF6B8780); // Profile Subtitle Text
  static const Color textCaption = Color(0xFF8B98A5); // Subtle / Date Caption Text
  static const Color textHint = Color(0xFF9CA3AF); // Hint & Disabled Text
  static const Color textDisabled = Color(0xFF9E9E9E); // Inactive Icon / Text Grey

  // ===========================================================================
  // 4. STATUS BADGES & ACTION COLORS
  // ===========================================================================
  // Success / Active / Approved
  static const Color success = Color(0xFF27AE60); // Success Green Text / Icon
  static const Color successDark = Color(0xFF059669); // Emerald Active Badge Text
  static const Color successBg = Color(0xFFE6F8F0); // Success Green Badge Fill

  // Warning / Pending
  static const Color warning = Color(0xFFFB8C00); // Warning Orange Accent
  static const Color warningAlt = Color(0xFFE67E22); // Pending Badge Text Orange
  static const Color warningBg = Color(0xFFFFF3E0); // Warning Soft Orange Fill
  static const Color warningBgAlt = Color(0xFFFFF6E0); // Pending Badge Soft Orange Fill
  static const Color warningAmber = Color(0xFFFFB300); // Amber Star / Rating

  // Error / Cancelled / Declined / Delete
  static const Color error = Color(0xFFE53935); // Error / Decline Red
  static const Color errorAlt = Color(0xFFEF4444); // Profile Logout / Alert Red
  static const Color errorDark = Color(0xFFDC2626); // Deep Red Alert Text
  static const Color errorBg = Color(0xFFFFECEE); // Soft Red Badge Fill
  static const Color errorBorder = Color(0xFFFFCDD2); // Red Outline / Border Fill

  // ===========================================================================
  // 5. GRADIENTS & DECORATIONS
  // ===========================================================================
  static const LinearGradient earningsGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );
}
