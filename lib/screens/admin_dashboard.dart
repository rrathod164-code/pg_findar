import 'package:flutter/material.dart';
import '../login.dart';
import 'admin/admin_home_tab.dart';
import 'admin/admin_users_tab.dart';
import 'admin/admin_bookings_tab.dart';
import 'admin/admin_pgs_tab.dart';
import 'admin/admin_more_tab.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  int _currentTabIndex = 0;

  static const Color brandTeal = Color(0xFF13B99D);

  void _handleLogout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: const Row(
          children: [
            Icon(Icons.logout_rounded, color: Colors.redAccent),
            SizedBox(width: 8),
            Text('Logout Admin', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out of the admin panel?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showNotificationsSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.notifications_active_rounded, color: brandTeal),
                    SizedBox(width: 8),
                    Text(
                      'Admin Notifications',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(ctx),
                ),
              ],
            ),
            const Divider(),
            _buildNotificationItem(
              icon: Icons.bookmark_added_rounded,
              color: brandTeal,
              title: 'New Booking at Green Valley PG',
              subtitle: 'Rahul Sharma booked Double Sharing for 3 months',
              time: '10 mins ago',
            ),
            _buildNotificationItem(
              icon: Icons.payment_rounded,
              color: Colors.green,
              title: 'Payment Received ₹19,500',
              subtitle: 'Invoice #8492 cleared by Amit Verma',
              time: '1 hour ago',
            ),
            _buildNotificationItem(
              icon: Icons.person_add_rounded,
              color: Colors.blueAccent,
              title: 'New User Registered',
              subtitle: 'Sneha Joshi signed up from Rajkot',
              time: '2 hours ago',
            ),
            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem({
    required IconData icon,
    required Color color,
    required String title,
    required String subtitle,
    required String time,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Text(time, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: _buildDrawer(),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF1FBF8), Color(0xFFE2F7F2), Color(0xFFC7F3EA)],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          bottom: false,
          child: IndexedStack(
            index: _currentTabIndex,
            children: [
              // 1. Home Tab
              AdminHomeTab(
                onSelectTab: (index) {
                  setState(() => _currentTabIndex = index);
                },
                onOpenDrawer: () => Scaffold.of(context).openDrawer(),
                onOpenNotifications: _showNotificationsSheet,
              ),
              // 2. Manage Users Tab
              const AdminUsersTab(),
              // 3. Bookings Tab
              const AdminBookingsTab(),
              // 4. PGs Tab
              const AdminPgsTab(),
              // 5. More Tab
              AdminMoreTab(
                onLogout: _handleLogout,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNav(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.white,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF0C937C), Color(0xFF13B99D)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 8,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.person, color: brandTeal, size: 36),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Admin Panel',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'admin13 • Super Administrator',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.dashboard_outlined, color: brandTeal),
            title: const Text('Dashboard'),
            selected: _currentTabIndex == 0,
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentTabIndex = 0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.people_outline, color: brandTeal),
            title: const Text('Manage Users'),
            selected: _currentTabIndex == 1,
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentTabIndex = 1);
            },
          ),
          ListTile(
            leading: const Icon(Icons.book_outlined, color: brandTeal),
            title: const Text('Manage Bookings'),
            selected: _currentTabIndex == 2,
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentTabIndex = 2);
            },
          ),
          ListTile(
            leading: const Icon(
              Icons.holiday_village_outlined,
              color: brandTeal,
            ),
            title: const Text('PG Accommodations'),
            selected: _currentTabIndex == 3,
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentTabIndex = 3);
            },
          ),
          ListTile(
            leading: const Icon(Icons.more_horiz_rounded, color: brandTeal),
            title: const Text('More Options'),
            selected: _currentTabIndex == 4,
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentTabIndex = 4);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: () {
              Navigator.pop(context);
              _handleLogout();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, 'Home'),
              _buildNavItem(1, Icons.people_outline_rounded, 'Users'),
              _buildNavItem(2, Icons.book_outlined, 'Booking'),
              _buildNavItem(3, Icons.holiday_village_outlined, 'Pgs'),
              _buildNavItem(4, Icons.more_horiz_rounded, 'More'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentTabIndex == index;
    final color = isSelected ? brandTeal : Colors.black87;

    return InkWell(
      onTap: () {
        setState(() {
          _currentTabIndex = index;
        });
      },
      child: SizedBox(
        width: 60,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 26),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
