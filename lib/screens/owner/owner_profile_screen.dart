import 'package:flutter/material.dart';
import 'package:pg_findar/resources/theme.dart';
import '../../widgets/logout_dialog.dart';

/// ============================================================================
/// OWNER PROFILE SCREEN (MATCHING USER DASHBOARD LOOK & FEEL)
/// ============================================================================
/// Built with the exact same visual identity as the user profile:
/// - Curved mint header with avatar, owner name, and email
/// - "Verified PG Owner" badge
/// - Clean menu items with dividers and rounded action styling
/// - Unified DashboardBackground derived from the root owner dashboard
/// ============================================================================

class OwnerProfileScreen extends StatelessWidget {
  final VoidCallback? onLogout;

  const OwnerProfileScreen({super.key, this.onLogout});

  @override
  Widget build(BuildContext context) {
    final double topPadding = MediaQuery.of(context).padding.top;
    final Color headerMint = AppColors.primaryTint;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
          children: [
            // ================================================================
            // 1. TOP CURVED MINT HEADER (Avatar & Owner info)
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
                  const Text(
                    'Owner Profile',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF091A2A),
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Avatar & Info Row
                  Row(
                    children: [
                      // Circular Avatar with border & soft shadow
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

                      // Owner Name & Business Info
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Renisha Patel',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF091A2A),
                              ),
                            ),
                            const SizedBox(height: 3),
                            const Text(
                              'renisha@pgfindar.com',
                              style: TextStyle(
                                fontSize: 13.5,
                                color: Color(0xFF6B8780),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 3.5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.9),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.primary.withValues(alpha: 0.3),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.verified_rounded,
                                    size: 13,
                                    color: AppColors.primary,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Verified PG Owner',
                                    style: TextStyle(
                                      color: AppColors.primary,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // ================================================================
            // 2. MENU OPTIONS LIST (Matching User Profile Screen)
            // ================================================================
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 12,
                ),
                child: Column(
                  children: [
                    _buildMenuItem(
                      context: context,
                      icon: Icons.edit_outlined,
                      title: 'Edit Personal Details',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Edit Personal Details tapped'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFD6E6E2),
                    ),

                    _buildMenuItem(
                      context: context,
                      icon: Icons.storefront_outlined,
                      title: 'Business Information',
                      subtitle: 'Renisha Stays & Residences',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Renisha Stays & Residences'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFD6E6E2),
                    ),

                    _buildMenuItem(
                      context: context,
                      icon: Icons.account_balance_outlined,
                      title: 'Payout Bank Accounts',
                      subtitle: 'HDFC Bank ****4920',
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Payout Bank Accounts tapped'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFD6E6E2),
                    ),

                    _buildMenuItem(
                      context: context,
                      icon: Icons.help_outline_rounded,
                      title: 'Help & Support for Owners',
                      onTap: () => _showOwnerHelpSupportModal(context),
                    ),
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: Color(0xFFD6E6E2),
                    ),

                    // Logout Item with standard confirmation dialog
                    _buildMenuItem(
                      context: context,
                      icon: Icons.login_outlined,
                      title: 'Logout',
                      titleColor: const Color(0xFFEF4444),
                      iconColor: const Color(0xFFEF4444),
                      onTap: () => _handleLogout(context),
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
      );
  }

  // --------------------------------------------------------------------------
  // HELPER: Reusable Menu Item Row with Chevron Icon
  // --------------------------------------------------------------------------
  Widget _buildMenuItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    String? subtitle,
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: titleColor,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF758595),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ],
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
  // MODAL: Owner Help & Support Bottom Sheet
  // --------------------------------------------------------------------------
  void _showOwnerHelpSupportModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(22),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Owner Partner Support',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF091A2A),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Need assistance managing your listings, guest bookings, or monthly earnings payout? We are here to help.',
                style: TextStyle(fontSize: 13, color: Color(0xFF758595)),
              ),
              const SizedBox(height: 18),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.email_outlined, color: AppColors.primary),
                ),
                title: const Text('Email Support', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('owners@pgfindar.com'),
                onTap: () => Navigator.pop(context),
              ),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: AppColors.primaryTint,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(Icons.phone_in_talk_outlined, color: AppColors.primary),
                ),
                title: const Text('Owner Toll-Free Helpline', style: TextStyle(fontWeight: FontWeight.w600)),
                subtitle: const Text('1800-419-PG-OWNER'),
                onTap: () => Navigator.pop(context),
              ),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  void _handleLogout(BuildContext context) {
    LogoutDialog.show(context, onLogout: onLogout);
  }
}
