import 'package:flutter/material.dart';
import 'package:pg_findar/screens/auth/login_screen.dart';
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
/// OWNER DASHBOARD PAGE (MERGED NAVIGATION SCAFFOLD & TABS)
/// ============================================================================
/// Root dashboard scaffold for PG Owners featuring:
/// - 5 modular screens (Home, Properties, Bookings, Earnings, Profile)
/// - Preserved state with IndexedStack
/// - Dedicated custom OwnerBottomNavBar
/// ============================================================================

class OwnerDashboardPage extends StatefulWidget {
  final int initialIndex;
  const OwnerDashboardPage({super.key, this.initialIndex = 0});

  @override
  State<OwnerDashboardPage> createState() => _OwnerDashboardPageState();
}

class _OwnerDashboardPageState extends State<OwnerDashboardPage> {
  late int _currentIndex;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _screens = [
      OwnerHomeScreen(onViewAllBookings: () => _navigateToTab(2)),
      const OwnerPropertiesScreen(),
      const OwnerBookingsScreen(),
      const OwnerEarningsScreen(),
      OwnerProfileScreen(
        onLogout: () {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const LoginPage()),
            (route) => false,
          );
        },
      ),
    ];
  }

  void _navigateToTab(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentIndex != 0) {
          _navigateToTab(0);
        }
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: OwnerBottomNavBar(
          currentIndex: _currentIndex,
          onTap: _navigateToTab,
        ),
      ),
    );
  }
}

/// ============================================================================
/// OWNER BOTTOM NAVIGATION BAR
/// ============================================================================
/// A custom, modern bottom navigation bar widget specifically designed
/// for the Owner Dashboard with 5 tabs: Home, Properties, Bookings, Earnings, Profile.
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF13B99D),
          unselectedItemColor: const Color(0xFF758595),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
          elevation: 0,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.holiday_village_outlined),
              activeIcon: Icon(Icons.holiday_village_rounded),
              label: 'Properties',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_outlined),
              activeIcon: Icon(Icons.calendar_today_rounded),
              label: 'Bookings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_balance_wallet_outlined),
              activeIcon: Icon(Icons.account_balance_wallet_rounded),
              label: 'Earnings',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}

// Aliases for compatibility
typedef OwnerBottomNavScreen = OwnerDashboardPage;
typedef OrganizerDashboardPage = OwnerDashboardPage;
typedef OrganizerHomeTab = OwnerHomeTab;
typedef OrganizerPropertiesTab = OwnerPropertiesTab;
typedef OrganizerBookingsTab = OwnerBookingsTab;
typedef OrganizerEarningsTab = OwnerEarningsTab;
typedef OrganizerProfileTab = OwnerProfileTab;
