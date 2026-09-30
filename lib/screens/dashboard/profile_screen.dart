import 'package:flutter/material.dart';
import 'package:pg_findar/resources/theme.dart';
import '../../services/api_service.dart';
import '../../widgets/bottom_nav_bar.dart';
import '../../widgets/dashboard_background.dart';
import 'booking_screen.dart';
import 'edit_profile_screen.dart';
import 'my_reviews_screen.dart';
import 'saved_screen.dart';
import '../../widgets/logout_dialog.dart';

/// ============================================================================
/// MORE / PROFILE SCREEN (BEGINNER-FRIENDLY UI)
/// ============================================================================
/// Matches your exact design with:
/// - Curved mint header with avatar, "Hi , User" and "user@gmail.com"
/// - Options: Edit profile, My booking, Favourite, My Review, Help & Support, Logout
/// - Unified DashboardBackground
/// - Pure Flutter UI code with clean comments, no backend needed!
/// ============================================================================

class ProfileScreen extends StatelessWidget {
  final VoidCallback? onBack;
  const ProfileScreen({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;

    // Curved mint header background color matching your design
    final Color headerMint = AppColors.primaryTint;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: DashboardBackground(
        child: Column(
          children: [
            // ================================================================
            // 1. TOP CURVED MINT HEADER (Back button, Avatar & User info)
            // ================================================================
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, topPadding + 14, 20, 26),
              decoration: BoxDecoration(
                color: headerMint,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(36),
                  bottomRight: Radius.circular(36),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back Arrow Button (Returns to Home tab or pops screen)
                  GestureDetector(
                    onTap: () {
                      if (onBack != null) {
                        onBack!();
                      } else if (Navigator.canPop(context)) {
                        Navigator.pop(context);
                      } else {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const BottomNavScreen(initialIndex: 0),
                          ),
                          (route) => false,
                        );
                      }
                    },
                    child: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 24,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Avatar & Info Row
                  Row(
                    children: [
                      // Circular Avatar with border & shadow
                      Container(
                        width: 72,
                        height: 72,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.white.withValues(alpha: 0.9),
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.08),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Image.asset(
                            'assets/images/user_avatar.png',
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: AppColors.primary,
                                child: const Icon(
                                  Icons.person,
                                  color: Colors.white,
                                  size: 38,
                                ),
                              );
                            },
                          ),
                        ),
                      ),

                      const SizedBox(width: 18),

                      // User Name & Email (Reactive: updates immediately when profile is edited!)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ValueListenableBuilder<String>(
                            valueListenable: ApiService().userNameNotifier,
                            builder: (context, userName, _) {
                              return Text(
                                'Hi , $userName',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 4),
                          ValueListenableBuilder<String>(
                            valueListenable: ApiService().userEmailNotifier,
                            builder: (context, userEmail, _) {
                              return Text(
                                userEmail,
                                style: const TextStyle(
                                  fontSize: 14.5,
                                  color: Color(0xFF6B8780),
                                  fontWeight: FontWeight.w500,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ================================================================
            // 2. MENU OPTIONS LIST (With Dividers)
            // ================================================================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 8,
                ),
                child: Column(
                  children: [
                    // 1. Edit Profile
                    _buildMenuItem(
                      context: context,
                      icon: Icons.edit_outlined,
                      title: 'Edit profile',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFD6E6E2),
                    ),

                    // 2. My Booking
                    _buildMenuItem(
                      context: context,
                      icon: Icons.calendar_today_outlined,
                      title: 'My booking',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const BookingScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFD6E6E2),
                    ),

                    // 3. Favourite
                    _buildMenuItem(
                      context: context,
                      icon: Icons.favorite_border_rounded,
                      title: 'Favourite',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SavedScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFD6E6E2),
                    ),

                    // 4. My Review
                    _buildMenuItem(
                      context: context,
                      icon: Icons.star_border_rounded,
                      title: 'My Review',
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const MyReviewsScreen(),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFD6E6E2),
                    ),

                    // 5. Help & Support
                    _buildMenuItem(
                      context: context,
                      icon: Icons.help_outline_rounded,
                      title: 'Help & Support',
                      onTap: () => _showHelpSupportModal(context),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFD6E6E2),
                    ),

                    // 6. Logout (Red text)
                    _buildMenuItem(
                      context: context,
                      icon: Icons.login_outlined,
                      title: 'Logout',
                      titleColor: const Color(0xFFEF4444),
                      onTap: () => _showLogoutDialog(context),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFD6E6E2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // HELPER: Reusable Menu Item Row with Chevron Icon
  // --------------------------------------------------------------------------
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color titleColor = Colors.black,
    Color iconColor = Colors.black,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 4),
        child: Row(
          children: [
            Icon(icon, size: 22, color: iconColor),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: titleColor,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Colors.black,
            ),
          ],
        ),
      ),
    );
  }

  // --------------------------------------------------------------------------
  // MODAL: Help & Support Bottom Sheet
  // --------------------------------------------------------------------------
  void _showHelpSupportModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Help & Support',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              const Text(
                'Need assistance with your booking or PG finding?',
                style: TextStyle(color: Colors.black87, fontSize: 14),
              ),
              const SizedBox(height: 14),
              ListTile(
                leading: const Icon(
                  Icons.email_outlined,
                  color: AppColors.primary,
                ),
                title: const Text('support@pgfinder.com'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                leading: const Icon(
                  Icons.phone_outlined,
                  color: AppColors.primary,
                ),
                title: const Text('+91 98765 43210'),
                onTap: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  // --------------------------------------------------------------------------
  // DIALOG: Logout Confirmation Dialog
  // --------------------------------------------------------------------------
  void _showLogoutDialog(BuildContext context) {
    LogoutDialog.show(context);
  }
}

// Aliases for compatibility
typedef MoreScreen = ProfileScreen;
typedef ProfileTab = ProfileScreen;
