import 'package:flutter/material.dart';
import 'package:pg_findar/resources/theme.dart';
import 'dashboard_background.dart';
import '../screens/user/user_home_screen.dart';
import '../screens/user/user_saved_screen.dart';
import '../screens/user/user_booking_screen.dart';
import '../screens/user/user_profile_screen.dart';

export 'owner_bottom_nav_bar.dart';

class BottomNavScreen extends StatefulWidget {
  final int initialIndex;
  const BottomNavScreen({super.key, this.initialIndex = 0});

  @override
  State<BottomNavScreen> createState() => _BottomNavScreenState();
}

class _BottomNavScreenState extends State<BottomNavScreen> {
  late int _currentIndex;

  late final List<Widget> _screens;

  void _switchToTab(int index) {
    if (mounted) {
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _currentIndex = widget.initialIndex;

    _screens = [
      const HomeScreen(),

      const SavedScreen(),

      const BookingScreen(),

      ProfileScreen(onBack: () => _switchToTab(0)),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _currentIndex == 0,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_currentIndex != 0) {
          _switchToTab(0);
        }
      },
      child: DashboardBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,

          body: IndexedStack(index: _currentIndex, children: _screens),

          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: _currentIndex,
            onTap: _switchToTab,
          ),
        ),
      ),
    );
  }
}

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const CustomBottomNavBar({
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
              selectedItemColor: AppColors.primary,
              unselectedItemColor: const Color(0xFF1E293B),
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
                    child: Icon(Icons.favorite_border_rounded, size: 26),
                  ),
                  activeIcon: Padding(
                    padding: EdgeInsets.only(bottom: 4),
                    child: Icon(Icons.favorite_border_rounded, size: 26),
                  ),
                  label: 'Saved',
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
                  label: 'Booking',
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
