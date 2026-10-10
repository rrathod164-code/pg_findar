import 'package:flutter/material.dart';
import 'theme.dart';

/// Centralized Placeholders class for the entire PG Finder application.
/// Manages default images, fallback assets, input hint texts, and empty states.
class AppPlaceholders {
  AppPlaceholders._(); // Private constructor to prevent instantiation

  // ==========================================
  // 1. IMAGE & ASSET PLACEHOLDERS
  // ==========================================
  /// Default placeholder image for PG listings when image is null/empty
  static const String defaultPgImage = 'assets/images/GreenVally.png';

  /// Alternative fallback PG images
  static const String fallbackPgImageSunshine = 'assets/images/Sunshine.png';
  static const String fallbackPgImageComfort = 'assets/images/Comfert.png';
  static const String fallbackPgImageRoyal = 'assets/images/royal.png';

  /// Default user profile avatar placeholder
  static const String defaultUserAvatar = 'assets/images/user_avatar.png';

  /// Default intro banner illustration
  static const String introBanner = 'assets/images/intro.png';

  /// Fallback high-quality network placeholder URL
  static const String networkPgFallback =
      'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?q=80&w=600&auto=format&fit=crop';

  // ==========================================
  // 2. INPUT FIELD HINTS & PLACEHOLDERS
  // ==========================================
  /// Search bar hint
  static const String searchHint = 'Search PG, location or area...';
  static const String searchLocationHint = 'Search location or locality...';

  /// Auth Form Placeholders
  static const String fullNameHint = 'Enter your full name';
  static const String emailHint = 'Enter your email';
  static const String emailOrUsernameHint = 'Enter your email or username';
  static const String phoneHint = 'Enter 10-digit mobile number';
  static const String passwordHint = 'Enter your password';
  static const String createPasswordHint = 'Create a password';
  static const String confirmPasswordHint = 'Confirm your password';

  /// PG & Property Form Placeholders (For Owner)
  static const String pgNameHint = 'e.g. Skyline Living PG';
  static const String pgLocationHint = 'e.g. Kalawad Road';
  static const String pgAddressHint = 'Street, Area, Landmark, City';
  static const String roomNumberHint = 'e.g. Room 103';
  static const String pgDescriptionHint =
      'Describe rules, food menu, gate timings and surroundings...';
  static const String monthlyRentHint = 'e.g. 7000';
  static const String rentAmountHint = '6500';
  static const String securityDepositHint = 'e.g. 5000';
  static const String noticePeriodHint = 'e.g. 30 days';

  /// Review & Rating Placeholders
  static const String reviewHint =
      'Write your experience about cleanliness, food quality, owner behavior...';

  /// Booking & Visit Placeholders
  static const String selectDateHint = 'Select preferred visit date';
  static const String selectTimeHint = 'Select visit time slot';
  static const String specialRequestHint = 'Any special requirements or questions...';

  // ==========================================
  // 3. EMPTY STATE & FALLBACK TEXTS
  // ==========================================
  static const String noPgFoundTitle = 'No PGs Found';
  static const String noPgFoundSubtitle =
      'Try adjusting your search filters, budget range or select another city.';

  static const String noSavedPgTitle = 'No Saved PGs Yet';
  static const String noSavedPgSubtitle =
      'Explore PGs and tap the heart icon to save your favorites here.';

  static const String noBookingsTitle = 'No Visits Scheduled';
  static const String noBookingsSubtitle =
      'Find your dream PG and schedule a free visit today!';

  static const String noReviewsTitle = 'No Reviews Yet';
  static const String noReviewsSubtitle =
      'Be the first resident to leave a helpful review for this PG.';

  // ==========================================
  // 4. DEFAULT VALUES & LABELS
  // ==========================================
  static const String currency = '₹';
  static const String defaultCity = 'Rajkot';
  static const String defaultCountryCode = '+91';
  static const double defaultRating = 4.5;
  static const String defaultSharingType = '2 Sharing';

  // ==========================================
  // 5. REUSABLE PLACEHOLDER WIDGETS
  // ==========================================
  /// Standard image error / loading placeholder widget
  static Widget imagePlaceholder({
    double? width,
    double? height,
    BorderRadius? borderRadius,
    IconData icon = Icons.image_outlined,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Center(
        child: Icon(
          icon,
          size: 32,
          color: const Color(0xFF94A3B8),
        ),
      ),
    );
  }

  /// Shimmer-like loading skeleton placeholder box
  static Widget skeletonBox({
    required double width,
    required double height,
    double radius = 8,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFE2E8F0),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }

  /// Circular avatar placeholder with initials
  static Widget avatarPlaceholder({
    double radius = 24,
    String? initial,
  }) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: AppColors.primaryLight,
      child: initial != null && initial.isNotEmpty
          ? Text(
              initial.toUpperCase(),
              style: TextStyle(
                fontSize: radius * 0.9,
                fontWeight: FontWeight.bold,
                color: AppColors.primary,
              ),
            )
          : Icon(
              Icons.person_rounded,
              size: radius * 1.1,
              color: AppColors.primary,
            ),
    );
  }
}
