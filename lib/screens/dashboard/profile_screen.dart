import 'package:flutter/material.dart';
import '../../models/pg_model.dart';
import '../../services/api_service.dart';
import '../auth/login_screen.dart';

/// ============================================================================
/// PROFILE SCREEN (USER PROFILE, STATS & LOGOUT)
/// ============================================================================
/// Displays user avatar, statistics (Active Bookings, Saved Listings),
/// profile options, and log out flow.
/// ============================================================================

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ApiService apiService = ApiService();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFD),
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF091A2A),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 24),
            // Avatar and info
            Center(
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        colors: [Color(0xFF13B99D), Color(0xFF5ED5A8)],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF13B99D).withValues(alpha: 0.2),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        'U',
                        style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'User 13',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF091A2A),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'user13@gmail.com',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF758595),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            // Statistics Row
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Row(
                children: [
                  Expanded(
                    child: ValueListenableBuilder<List<PGBooking>>(
                      valueListenable: apiService.bookingsNotifier,
                      builder: (context, bookings, child) {
                        final active = bookings
                            .where((b) => b.status != 'Cancelled')
                            .length;
                        return _buildStatCard('Active Bookings',
                            active.toString(), Icons.home_work_outlined);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ValueListenableBuilder<List<String>>(
                      valueListenable: apiService.savedPgIdsNotifier,
                      builder: (context, saved, child) {
                        return _buildStatCard('Saved Listings',
                            saved.length.toString(), Icons.favorite_border_rounded);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Profile Options List
            _buildProfileListTile(
                context, 'Edit Profile', Icons.edit_outlined, () {}),
            _buildProfileListTile(
                context, 'My Preferred Location', Icons.pin_drop_outlined, () {}),
            _buildProfileListTile(
                context, 'Notifications', Icons.notifications_none_rounded, () {}),
            _buildProfileListTile(
                context, 'Privacy Policy', Icons.security_rounded, () {}),
            _buildProfileListTile(
                context, 'Help & Support', Icons.support_agent_rounded, () {}),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),

            // Logout Option
            _buildProfileListTile(
              context,
              'Log Out',
              Icons.logout_rounded,
              () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Log Out'),
                    content: const Text(
                        'Are you sure you want to log out of the PG Finder application?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel',
                            style: TextStyle(color: Color(0xFF758595))),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginScreen()),
                            (route) => false,
                          );
                        },
                        child: const Text(
                          'Log Out',
                          style: TextStyle(
                              color: Colors.red, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
              textColor: Colors.red,
              iconColor: Colors.red,
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1FBFA),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF13B99D), size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF091A2A),
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF758595),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileListTile(
    BuildContext context,
    String title,
    IconData icon,
    VoidCallback onTap, {
    Color textColor = const Color(0xFF091A2A),
    Color iconColor = const Color(0xFF758595),
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        elevation: 1,
        shadowColor: Colors.black.withValues(alpha: 0.08),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            child: Row(
              children: [
                Icon(icon, color: iconColor, size: 20),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: textColor,
                      fontSize: 14.5,
                    ),
                  ),
                ),
                Icon(
                  Icons.chevron_right_rounded,
                  color: Colors.grey[400],
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// Alias for compatibility
typedef ProfileTab = ProfileScreen;
