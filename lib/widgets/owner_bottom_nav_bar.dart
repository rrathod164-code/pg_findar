import 'package:flutter/material.dart';
import 'package:pg_findar/resources/owner_theme.dart';
import 'package:pg_findar/screens/auth/login_screen.dart';
import 'package:pg_findar/widgets/dashboard_background.dart';
import '../screens/owner/owner_home_screen.dart';
import '../screens/owner/owner_properties_screen.dart';
import '../screens/owner/owner_bookings_screen.dart';
import '../screens/owner/owner_earnings_screen.dart';
import '../screens/owner/owner_profile_screen.dart';

export '../screens/owner/owner_home_screen.dart';
export '../screens/owner/owner_properties_screen.dart';
export '../screens/owner/owner_bookings_screen.dart';
export '../screens/owner/owner_earnings_screen.dart';
export '../screens/owner/owner_profile_screen.dart';

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
      child: DashboardBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: IndexedStack(index: _currentIndex, children: _screens),
          bottomNavigationBar: OwnerBottomNavBar(
            currentIndex: _currentIndex,
            onTap: _navigateToTab,
          ),
        ),
      ),
    );
  }
}

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
