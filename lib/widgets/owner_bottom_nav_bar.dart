import 'package:flutter/material.dart';
import 'package:pg_findar/resources/owner_theme.dart';
import 'package:pg_findar/screens/auth/login_screen.dart';
import 'package:pg_findar/widgets/dashboard_background.dart';
import '../screens/owner/owner_home_screen.dart';
import '../screens/owner/owner_properties_screen.dart';
import '../screens/owner/owner_bookings_screen.dart';
import '../screens/owner/owner_earnings_screen.dart';
import '../screens/owner/owner_profile_screen.dart';

// Export all individual owner screens for convenient access
export '../screens/owner/owner_home_screen.dart';
export '../screens/owner/owner_properties_screen.dart';
export '../screens/owner/owner_bookings_screen.dart';
export '../screens/owner/owner_earnings_screen.dart';
export '../screens/owner/owner_profile_screen.dart';

/// ============================================================================
/// OWNER DASHBOARD PAGE
/// ============================================================================
/// This is the main shell for the Owner panel.
/// It holds the 5 owner screens and switches between them using a Bottom Navigation Bar:
/// 1. Home       -> Overview & quick stats
/// 2. Properties -> Manage PG properties and rooms
/// 3. Bookings   -> Approve or decline student booking requests
/// 4. Earnings   -> View revenue and payouts
/// 5. Profile    -> Owner details & Logout
/// ============================================================================

class OwnerDashboardPage extends StatefulWidget {
  final int initialIndex; // Which tab to show first (default is 0: Home)
  const OwnerDashboardPage({super.key, this.initialIndex = 0});

  @override
  State<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends State<OwnerDashboardPage> {
  // Keeps track of which tab is currently selected (0, 1, 2, 3, or 4)
  late int _currentIndex;

  // The list of 5 screens corresponding to each tab
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    // 1. Set the initial tab index
    _currentIndex = widget.initialIndex;

    // 2. Initialize each screen once when the page loads
    _screens = [
      // Tab 0: Home Screen (Tapping 'View All' navigates to Bookings tab index 2)
      OwnerHomeScreen(onViewAllBookings: () => _navigateToTab(2)),

      // Tab 1: Properties Screen (Add/edit/delete PGs and rooms)
      const OwnerPropertiesScreen(),

      // Tab 2: Bookings Screen (View, approve, decline bookings)
      const OwnerBookingsScreen(),

      // Tab 3: Earnings Screen (Monthly revenue, pending payments)
      const OwnerEarningsScreen(),

      // Tab 4: Profile Screen (Owner details & logout back to LoginPage)
      OwnerProfileScreen(
        onLogout: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false, // Clear all backstack history on logout
          );
        },
      ),
    ];
  }

  // Helper method: Updates current tab index and triggers a screen refresh
  void _navigateToTab(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // PopScope intercepts phone back button:
    // If not on Home tab, go to Home tab first; if on Home tab, exit app.
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentIndex != 0) {
          _navigateToTab(0);
        }
      },
      child: DashboardBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          // IndexedStack preserves the scroll position and state of each tab
          body: IndexedStack(index: _currentIndex, children: _screens),
          // The bottom navigation bar matching reference design
          bottomNavigationBar: OwnerBottomNavBar(
            currentIndex: _currentIndex,
            onTap: _navigateToTab,
          ),
        ),
      ),
    );
  }
}

/// ============================================================================
/// OWNER BOTTOM NAVIGATION BAR (MATCHES REFERENCE DESIGN)
/// ============================================================================
/// - Rounded top corners (Radius 30)
/// - Soft diffused shadow on top of mint background
/// - Clean outline icons with active mint teal highlight
/// ============================================================================

class OwnerBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const OwnerBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            spreadRadius: 0,
            offset: const Offset(0, -6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
        child: SafeArea(
          top: false,
          child: Padding(
            padding: const EdgeInsets.only(top: 8, bottom: 4),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.white,
              elevation: 0,
              selectedItemColor: OwnerColors.primary,
              unselectedItemColor: OwnerColors.textNavUnselected,
              selectedFontSize: 12,
              unselectedFontSize: 12,
              selectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 12,
                height: 1.5,
              ),
              unselectedLabelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                height: 1.5,
              ),
              items: const [
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.home_outlined, size: 26),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.home_outlined, size: 26),
                  ),
                  label: 'Home',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.holiday_village_outlined, size: 26),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.holiday_village_outlined, size: 26),
                  ),
                  label: 'Properties',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.calendar_today_outlined, size: 24),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.calendar_today_outlined, size: 24),
                  ),
                  label: 'Bookings',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 26,
                    ),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(
                      Icons.account_balance_wallet_outlined,
                      size: 26,
                    ),
                  ),
                  label: 'Earnings',
                ),
                BottomNavigationBarItem(
                  icon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.person_outline_rounded, size: 26),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.person_outline_rounded, size: 26),
                  ),
                  label: 'Profile',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
