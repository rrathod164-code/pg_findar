import 'package:flutter/material.dart';
import 'package:pg_findar/widgets/app_image.dart';

/// Admin Booking Tab (Screenshot 1)
class AdminBookingTab extends StatefulWidget {
  const AdminBookingTab({super.key});

  @override
  State<AdminBookingTab> createState() => _AdminBookingTabState();
}

class _AdminBookingTabState extends State<AdminBookingTab> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  final List<Map<String, String>> _allBookings = [
    {
      'name': 'Green Valley PG',
      'location': 'Rajkot, Gujarat',
      'status': 'Confirmed',
      'price': '₹ 6,500',
      'date': '23 May 2025',
      'image': 'assets/images/GreenVally.png',
    },
    {
      'name': 'Royal PG',
      'location': 'Rajkot, Gujarat',
      'status': 'Confirmed',
      'price': '₹ 6,500',
      'date': '23 May 2025',
      'image': 'assets/images/royal.png',
    },
    {
      'name': 'Shivam PG',
      'location': 'Rajkot, Gujarat',
      'status': 'Cancelled',
      'price': '₹ 8,500',
      'date': '23 May 2025',
      'image': 'assets/images/Shanti.png',
    },
    {
      'name': 'Maple PG',
      'location': 'Rajkot, Gujarat',
      'status': 'Confirmed',
      'price': '₹ 7,500',
      'date': '23 May 2025',
      'image': 'assets/images/Sunshine.png',
    },
    {
      'name': 'Beary besti hostel',
      'location': 'Rajkot, Gujarat',
      'status': 'Pending',
      'price': '₹ 8,500',
      'date': '23 May 2025',
      'image': 'assets/images/Comfert.png',
    },
    {
      'name': 'Galaxy Prime Hostel',
      'location': 'Rajkot, Gujarat',
      'status': 'Confirmed',
      'price': '₹ 10,500',
      'date': '23 May 2025',
      'image': 'assets/images/metro.png',
    },
    {
      'name': "Kashmira's PG",
      'location': 'Rajkot, Gujarat',
      'status': 'Confirmed',
      'price': '₹ 6,500',
      'date': '23 May 2025',
      'image': 'assets/images/Shanti.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = _searchController.text.toLowerCase().trim();

    final filteredBookings = _allBookings.where((booking) {
      final matchesFilter = _selectedFilter == 'All' ||
          booking['status'] == _selectedFilter;
      final matchesQuery = query.isEmpty ||
          booking['name']!.toLowerCase().contains(query) ||
          booking['location']!.toLowerCase().contains(query);
      return matchesFilter && matchesQuery;
    }).toList();

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
            child: TextField(
              controller: _searchController,
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
          const SizedBox(height: 16),

          // Filter Pills Row (All, Confirmed, Pending, Cancelled)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Confirmed', 'Pending', 'Cancelled'].map((
                filter,
              ) {
                final isSelected = _selectedFilter == filter;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFilter = filter;
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
            child: filteredBookings.isEmpty
                ? const Center(
                    child: Text(
                      'No bookings found',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  )
                : ListView.builder(
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
                              child: AppImage(
                                imageUrl: booking['image']!,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
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
}
