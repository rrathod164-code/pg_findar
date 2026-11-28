import 'package:flutter/material.dart';

import 'admin_booking_tab.dart';
import 'admin_home_tab.dart';
import 'admin_more_tab.dart';
import 'admin_properties_tab.dart';
import 'admin_users_tab.dart';

/// Complete Admin Screen for PG Finder.
/// Houses the master layout, mint background canvas, safe area, and 5-tab BottomNavigationBar.
class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Active bottom navigation tab index (0: Home, 1: Users, 2: Booking, 3: Pgs, 4: More)
  int _selectedIndex = 0;

  // The 5 individual admin tab pages
  final List<Widget> _tabs = const [
    AdminHomeTab(),
    AdminUsersTab(),
    AdminBookingTab(),
    AdminPropertiesTab(),
    AdminMoreTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Base Mint Background Canvas matching screenshot color
          Container(
            color: const Color(0xFFE8FDF5),
          ),

          // Translucent Top-Right Accent Circle Shape
          Positioned(
            top: -50,
            right: -50,
            child: IgnorePointer(
              child: Container(
                width: 240,
                height: 240,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF27E39F).withValues(alpha: 0.16),
                ),
              ),
            ),
          ),

          // Translucent Top-Left Accent Circle Shape
          Positioned(
            top: -60,
            left: -60,
            child: IgnorePointer(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF27E39F).withValues(alpha: 0.12),
                ),
              ),
            ),
          ),

          // Translucent Bottom Accent Circle Shape
          Positioned(
            bottom: 40,
            left: -60,
            child: IgnorePointer(
              child: Container(
                width: 220,
                height: 220,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF27E39F).withValues(alpha: 0.14),
                ),
              ),
            ),
          ),

          // Main View Content wrapped in SafeArea using IndexedStack for state retention
          SafeArea(
            child: IndexedStack(
              index: _selectedIndex,
              children: _tabs,
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar with 5 interactive tabs
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// --------------------------------------------------------------------------
  /// BOTTOM NAVIGATION BAR
  /// --------------------------------------------------------------------------
  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        child: BottomNavigationBar(
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF13B99D),
          unselectedItemColor: Colors.black87,
          selectedFontSize: 12,
          unselectedFontSize: 12,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined, size: 26),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.people_outline_rounded, size: 26),
              label: 'Users',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.book_outlined, size: 26),
              label: 'Booking',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.other_houses_outlined, size: 26),
              label: 'Pgs',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz_rounded, size: 26),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}
