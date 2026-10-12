import 'package:flutter/material.dart';

/// This is the complete Admin Page widget for PG Findar.
/// Built with beginner-friendly Flutter state management (StatefulWidget).
class AdminPage extends StatefulWidget {
  const AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  // Active bottom navigation tab index (0: Home, 1: Users, 2: Booking, 3: Pgs, 4: More)
  int _selectedIndex = 0;

  // Controller for the Search Bar in Users tab
  final TextEditingController _userSearchController = TextEditingController();

  // Full list of users matching Image 3
  final List<Map<String, String>> _allUsers = [
    {'name': 'Aarav Sharma', 'email': 'aarav@example.com', 'status': 'Active'},
    {'name': 'Neha Verma', 'email': 'neha@example.com', 'status': 'Active'},
    {'name': 'Priya Patel', 'email': 'priya@example.com', 'status': 'Active'},
    {'name': 'Vikram Singh', 'email': 'vikram@example.com', 'status': 'Active'},
    {'name': 'Rohan Gupta', 'email': 'rohan@example.com', 'status': 'Active'},
    {'name': 'Ananya Reddy', 'email': 'ananya@example.com', 'status': 'Active'},
  ];

  // Filtered users list displayed based on search input
  List<Map<String, String>> _filteredUsers = [];

  // Selected filter for Bookings tab ('All', 'Confirmed', 'Pending', 'Cancelled')
  String _selectedBookingFilter = 'All';

  @override
  void initState() {
    super.initState();
    _filteredUsers = List.from(_allUsers);
    _userSearchController.addListener(_onUserSearchChanged);
  }

  @override
  void dispose() {
    _userSearchController.dispose();
    super.dispose();
  }

  // Filters users list dynamically as user types in search bar
  void _onUserSearchChanged() {
    final query = _userSearchController.text.toLowerCase();
    setState(() {
      _filteredUsers = _allUsers.where((user) {
        final nameMatches = user['name']!.toLowerCase().contains(query);
        final emailMatches = user['email']!.toLowerCase().contains(query);
        return nameMatches || emailMatches;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Gradient background matching all screenshot designs
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8FDF5), // Light mint green top
              Color(0xFFAAF7D9), // Soft mint green bottom
            ],
          ),
        ),
        child: SafeArea(child: _buildCurrentTabContent()),
      ),

      // Bottom Navigation Bar with 5 interactive tabs
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  /// --------------------------------------------------------------------------
  /// TAB CONTENT SWITCHER
  /// --------------------------------------------------------------------------
  Widget _buildCurrentTabContent() {
    switch (_selectedIndex) {
      case 0:
        return _buildHomeView();
      case 1:
        return _buildUsersView();
      case 2:
        return _buildBookingView();
      case 3:
        return _buildPgsView();
      case 4:
        return _buildMoreView();
      default:
        return _buildHomeView();
    }
  }

  /// --------------------------------------------------------------------------
  /// 1. HOME DASHBOARD VIEW (Tab 0 - Image 1)
  /// --------------------------------------------------------------------------
  Widget _buildHomeView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTopAppBar(),
          const SizedBox(height: 24),
          _buildWelcomeHeader(),
          const SizedBox(height: 28),
          _buildStatsGrid(),
          const SizedBox(height: 28),
          _buildTodaysBookingSection(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  /// Top App Bar
  Widget _buildTopAppBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu, size: 28, color: Colors.black87),
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.notifications_none_rounded,
                size: 28,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 22,
              backgroundColor: Color(0xFFD9D9D9),
              child: Icon(
                Icons.person_outline_rounded,
                color: Colors.black54,
                size: 26,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Greetings Header
  Widget _buildWelcomeHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: const [
        Text(
          'Welcome Back,',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        SizedBox(height: 2),
        Text(
          'Admin',
          style: TextStyle(
            fontSize: 34,
            fontWeight: FontWeight.w900,
            color: Colors.black,
            letterSpacing: 0.5,
          ),
        ),
        SizedBox(height: 6),
        Text(
          'Manage your PG properties efficiently',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF8294A5),
          ),
        ),
      ],
    );
  }

  /// 2x2 Dashboard Stat Grid
  Widget _buildStatsGrid() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.person_outline_rounded,
                title: 'Total Users',
                count: '250',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                icon: Icons.book_outlined,
                title: 'Bookings',
                count: '120',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                icon: Icons.home_outlined,
                title: 'PGs',
                count: '45',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildStatCard(
                icon: Icons.currency_rupee,
                title: 'Revenue',
                count: '3,90,000',
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// Stat Card Helper
  Widget _buildStatCard({
    required IconData icon,
    required String title,
    required String count,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 15,
            spreadRadius: 1,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Icon(icon, size: 40, color: const Color(0xFF00A896)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  count,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Today's Booking Section
  Widget _buildTodaysBookingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Todays booking',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x0D000000),
                blurRadius: 15,
                spreadRadius: 1,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&w=300&q=80',
                  width: 95,
                  height: 85,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 95,
                      height: 85,
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.king_bed_outlined,
                        color: Colors.grey,
                        size: 40,
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Green Valley PG',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Kalawad Road, Rajkot',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF8EA0B0),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// --------------------------------------------------------------------------
  /// 2. USERS VIEW (Tab 1 - Image 3)
  /// --------------------------------------------------------------------------
  Widget _buildUsersView() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Users',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 20),

          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFD6F5E8),
              borderRadius: BorderRadius.circular(30),
            ),
            child: TextField(
              controller: _userSearchController,
              decoration: const InputDecoration(
                icon: Icon(Icons.search, color: Colors.black87, size: 24),
                hintText: 'Search users..',
                hintStyle: TextStyle(
                  color: Color(0xFF7CA397),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Users List
          Expanded(
            child: _filteredUsers.isEmpty
                ? const Center(
                    child: Text(
                      'No users found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
                    itemCount: _filteredUsers.length,
                    itemBuilder: (context, index) {
                      final user = _filteredUsers[index];

                      return Container(
                        margin: const EdgeInsets.only(bottom: 14),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 16,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0x06000000),
                              blurRadius: 10,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  user['name']!,
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  user['email']!,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF8FA1B2),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 18,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFC3F3D8),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                user['status']!,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Color(0xFF2E7D32),
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  /// --------------------------------------------------------------------------
  /// 3. BOOKINGS VIEW (Tab 2 - Image 5)
  /// --------------------------------------------------------------------------
  Widget _buildBookingView() {
    final List<Map<String, String>> allBookings = [
      {
        'name': 'Green Valley PG',
        'location': 'Rajkot, Gujarat',
        'status': 'Confirmed',
        'price': '₹ 6,500',
        'date': '23 May 2025',
        'image':
            'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&w=300&q=80',
      },
      {
        'name': 'Royal PG',
        'location': 'Rajkot, Gujarat',
        'status': 'Confirmed',
        'price': '₹ 6,500',
        'date': '23 May 2025',
        'image':
            'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=300&q=80',
      },
      {
        'name': 'Shivam PG',
        'location': 'Rajkot, Gujarat',
        'status': 'Cancelled',
        'price': '₹ 8,500',
        'date': '23 May 2025',
        'image':
            'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=300&q=80',
      },
      {
        'name': 'Maple PG',
        'location': 'Rajkot, Gujarat',
        'status': 'Confirmed',
        'price': '₹ 7,500',
        'date': '23 May 2025',
        'image':
            'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=300&q=80',
      },
      {
        'name': 'Beary besti hostel',
        'location': 'Rajkot, Gujarat',
        'status': 'Pending',
        'price': '₹ 8,500',
        'date': '23 May 2025',
        'image':
            'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=300&q=80',
      },
      {
        'name': 'Galaxy Prime Hostel',
        'location': 'Rajkot, Gujarat',
        'status': 'Confirmed',
        'price': '₹ 10,500',
        'date': '23 May 2025',
        'image':
            'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?auto=format&fit=crop&w=300&q=80',
      },
      {
        'name': "Kashmira's PG",
        'location': 'Rajkot, Gujarat',
        'status': 'Confirmed',
        'price': '₹ 6,500',
        'date': '23 May 2025',
        'image':
            'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=300&q=80',
      },
    ];

    final filteredBookings = _selectedBookingFilter == 'All'
        ? allBookings
        : allBookings
              .where((b) => b['status'] == _selectedBookingFilter)
              .toList();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title
          const Text(
            'Booking',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 18),

          // Search Bar
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFD6F5E8),
              borderRadius: BorderRadius.circular(30),
            ),
            child: const TextField(
              decoration: InputDecoration(
                icon: Icon(Icons.search, color: Colors.black87, size: 24),
                hintText: 'Search users..',
                hintStyle: TextStyle(
                  color: Color(0xFF7CA397),
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Filter Pills Row (All, Confirmed, Pending, Cancelled)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Confirmed', 'Pending', 'Cancelled'].map((
                filter,
              ) {
                final isSelected = _selectedBookingFilter == filter;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedBookingFilter = filter;
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 10,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? const Color(0xFF5DF0A6)
                          : const Color(0xFFC7EADB),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      filter,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 18),

          // Bookings Cards List
          Expanded(
            child: ListView.builder(
              itemCount: filteredBookings.length,
              itemBuilder: (context, index) {
                final booking = filteredBookings[index];
                final status = booking['status']!;

                Color badgeBgColor;
                Color badgeTextColor;
                if (status == 'Confirmed') {
                  badgeBgColor = const Color(0xFFC3F3D8);
                  badgeTextColor = const Color(0xFF2E7D32);
                } else if (status == 'Cancelled') {
                  badgeBgColor = const Color(0xFFFCDADA);
                  badgeTextColor = const Color(0xFFD32F2F);
                } else {
                  badgeBgColor = const Color(0xFFFEE6A8);
                  badgeTextColor = const Color(0xFFB45309);
                }

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x06000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          booking['image']!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.home_work_outlined,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 14),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              booking['name']!,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              booking['location']!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: badgeBgColor,
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Text(
                                status,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                  color: badgeTextColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            booking['price']!,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            booking['date']!,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// --------------------------------------------------------------------------
  /// 4. PGS / PROPERTIES VIEW (Tab 3 - Image 4)
  /// --------------------------------------------------------------------------
  Widget _buildPgsView() {
    final List<Map<String, String>> propertiesList = [
      {
        'name': 'Green Valley PG',
        'location': 'Rajkot, Gujarat',
        'type': 'PG',
        'price': '₹ 6,500',
        'status': 'Active',
        'image':
            'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&w=300&q=80',
      },
      {
        'name': 'Royal PG',
        'location': 'Rajkot, Gujarat',
        'type': 'PG',
        'price': '₹ 6,500',
        'status': 'Active',
        'image':
            'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?auto=format&fit=crop&w=300&q=80',
      },
      {
        'name': 'Shivam PG',
        'location': 'Rajkot, Gujarat',
        'type': 'PG',
        'price': '₹ 8,500',
        'status': 'Active',
        'image':
            'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=300&q=80',
      },
      {
        'name': 'Maple PG',
        'location': 'Rajkot, Gujarat',
        'type': 'PG',
        'price': '₹ 7,500',
        'status': 'Active',
        'image':
            'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=300&q=80',
      },
      {
        'name': 'Beary besti hostel',
        'location': 'Rajkot, Gujarat',
        'type': 'PG',
        'price': '₹ 8,500',
        'status': 'Active',
        'image':
            'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=300&q=80',
      },
      {
        'name': 'Galaxy Prime Hostel',
        'location': 'Rajkot, Gujarat',
        'type': 'PG',
        'price': '₹ 10,500',
        'status': 'Active',
        'image':
            'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?auto=format&fit=crop&w=300&q=80',
      },
      {
        'name': "Kashmira's PG",
        'location': 'Rajkot, Gujarat',
        'type': 'PG',
        'price': '₹ 6,500',
        'status': 'Active',
        'image':
            'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?auto=format&fit=crop&w=300&q=80',
      },
      {
        'name': 'Divine Girls Hostel',
        'location': 'Rajkot, Gujarat',
        'type': 'Hostel',
        'price': '₹ 7,500',
        'status': 'Active',
        'image':
            'https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?auto=format&fit=crop&w=300&q=80',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Properties',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 18),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFD6F5E8),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: const TextField(
                    decoration: InputDecoration(
                      icon: Icon(Icons.search, color: Colors.black87, size: 22),
                      hintText: 'Search users..',
                      hintStyle: TextStyle(
                        color: Color(0xFF7CA397),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 14,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF5DF0A6),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  '+ Add Property',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          Expanded(
            child: ListView.builder(
              itemCount: propertiesList.length,
              itemBuilder: (context, index) {
                final item = propertiesList[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x06000000),
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.network(
                          item['image']!,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 80,
                              height: 80,
                              color: Colors.grey[300],
                              child: const Icon(
                                Icons.home_work_outlined,
                                color: Colors.grey,
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['name']!,
                              style: const TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              item['location']!,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            item['type']!,
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF94A3B8),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            item['price']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2E7D32),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFC3F3D8),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              item['status']!,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF2E7D32),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// --------------------------------------------------------------------------
  /// 5. MORE VIEW (Tab 4 - Image 2)
  /// --------------------------------------------------------------------------
  Widget _buildMoreView() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'More',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 28),

          _buildMoreMenuItem(
            icon: Icons.star_border_rounded,
            title: 'Reviews',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Reviews section opened')),
              );
            },
          ),
          _buildMoreMenuItem(
            icon: Icons.help_outline_rounded,
            title: 'Help & Support',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Help & Support section opened')),
              );
            },
          ),
          _buildMoreMenuItem(
            icon: Icons.lock_outline_rounded,
            title: 'Privacy Policy',
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Privacy Policy opened')),
              );
            },
          ),
          _buildMoreMenuItem(
            icon: Icons.logout_rounded,
            title: 'Logout',
            isLogout: true,
            onTap: _showLogoutConfirmationDialog,
          ),
        ],
      ),
    );
  }

  /// Logout Dialog (Pixel-Perfect Matching Image 6)
  void _showLogoutConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          backgroundColor: const Color(0xFFFDF0F0), // Soft pale blush pink matching Image 6
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 28.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Top Circular Grey Icon Background
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    color: Color(0xFFDFE2E6), // Light grey circle
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.logout_rounded,
                    color: Colors.black87,
                    size: 26,
                  ),
                ),
                const SizedBox(height: 16),

                // Title Text
                const Text(
                  'Logout?',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFD32F2F), // Red title
                  ),
                ),
                const SizedBox(height: 12),

                // Description Subtitle Text
                const Text(
                  'Are you sure you want to\nlogout from your account?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF7A8B9A), // Muted grey text
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 24),

                // Action Buttons Row (Cancle & Logout)
                Row(
                  children: [
                    // Cancle Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () => Navigator.of(context).pop(),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9), // Light greyish white
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text(
                              'Cancle',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),

                    // Logout Button
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Logged out successfully')),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFF4D4D), // Coral red button color
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Center(
                            child: Text(
                              'Logout',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// Helper for More Menu items
  Widget _buildMoreMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: const Color(0x33455A64), width: 1),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                size: 24,
                color: isLogout ? Colors.red : Colors.black87,
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isLogout ? Colors.red : Colors.black,
                  ),
                ),
              ),
              Icon(
                Icons.arrow_forward,
                size: 22,
                color: isLogout ? Colors.red : Colors.black87,
              ),
            ],
          ),
        ),
      ),
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
          selectedItemColor: const Color(0xFF00A896),
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
