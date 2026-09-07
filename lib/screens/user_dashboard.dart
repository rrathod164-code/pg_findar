import 'package:flutter/material.dart';

import '../models/pg_model.dart';
import '../services/data_service.dart';
import '../login.dart'; // To navigate back on logout

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  int _currentIndex = 0;

  // Tabs list
  late final List<Widget> _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = [
      const HomeTab(),
      const SavedTab(),
      const BookingTab(),
      const ProfileTab(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _tabs[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.white,
          selectedItemColor: const Color(0xFF13B99D),
          unselectedItemColor: const Color(0xFF758595),
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
          unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              activeIcon: Icon(Icons.home_rounded),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite_border_rounded),
              activeIcon: Icon(Icons.favorite_rounded),
              label: 'saved',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month_outlined),
              activeIcon: Icon(Icons.calendar_month_rounded),
              label: 'Booking',
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

// ==========================================
// 1. HOME TAB (MATCHES SCREENSHOT)
// ==========================================
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final DataService _dataService = DataService();
  final TextEditingController _searchController = TextEditingController();
  
  String _selectedCity = 'Rajkot';
  String _selectedCategory = ''; // Empty means all
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Format date helper to avoid packages
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Book PG modal dialog
  void _showBookingDialog(PGAccommodation pg) {
    DateTime selectedDate = DateTime.now().add(const Duration(days: 1));
    String selectedRoomType = 'Double Sharing';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              padding: EdgeInsets.only(
                top: 24,
                left: 24,
                right: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 50,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Book PG Accommodation',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF091A2A),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    pg.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF13B99D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Select Room Sharing Type',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF091A2A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      _buildSharingOption(
                        title: 'Single',
                        price: pg.price + 1500,
                        isSelected: selectedRoomType == 'Single Sharing',
                        onTap: () => setModalState(() => selectedRoomType = 'Single Sharing'),
                      ),
                      const SizedBox(width: 10),
                      _buildSharingOption(
                        title: 'Double',
                        price: pg.price,
                        isSelected: selectedRoomType == 'Double Sharing',
                        onTap: () => setModalState(() => selectedRoomType = 'Double Sharing'),
                      ),
                      const SizedBox(width: 10),
                      _buildSharingOption(
                        title: 'Triple',
                        price: pg.price - 1000,
                        isSelected: selectedRoomType == 'Triple Sharing',
                        onTap: () => setModalState(() => selectedRoomType = 'Triple Sharing'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Select Check-in Date',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF091A2A),
                    ),
                  ),
                  const SizedBox(height: 8),
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: selectedDate,
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 90)),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              colorScheme: const ColorScheme.light(
                                primary: Color(0xFF13B99D),
                                onPrimary: Colors.white,
                                onSurface: Color(0xFF091A2A),
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
                      if (picked != null) {
                        setModalState(() {
                          selectedDate = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _formatDate(selectedDate),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF091A2A),
                            ),
                          ),
                          const Icon(Icons.calendar_today_rounded, color: Color(0xFF13B99D), size: 20),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () {
                        _dataService.bookPG(pg, selectedDate, selectedRoomType);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded, color: Colors.white),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text('Booking request for ${pg.name} sent successfully!'),
                                ),
                              ],
                            ),
                            backgroundColor: const Color(0xFF13B99D),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF13B99D),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(
                        'Confirm & Request Booking',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSharingOption({
    required String title,
    required double price,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFF1FBFA) : Colors.white,
            border: Border.all(
              color: isSelected ? const Color(0xFF13B99D) : Colors.grey[300]!,
              width: isSelected ? 2 : 1,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? const Color(0xFF13B99D) : const Color(0xFF091A2A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₹${price.toInt()}/mo',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? const Color(0xFF13B99D) : const Color(0xFF758595),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Stack(
      children: [
        // Background Gradient
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFFFBFDFD),
        ),

        // Translucent background circles matching the screenshot
        Positioned(
          top: -40,
          right: -40,
          child: Container(
            width: 180,
            height: 180,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE2F7F4).withValues(alpha: 0.7),
            ),
          ),
        ),
        Positioned(
          top: screenHeight * 0.38,
          right: -50,
          child: Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE2F7F4).withValues(alpha: 0.5),
            ),
          ),
        ),

        SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header (Hello User & Location Selector)
                Padding(
                  padding: EdgeInsets.only(
                    left: screenWidth * 0.06,
                    right: screenWidth * 0.06,
                    top: screenHeight * 0.02,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Hello, User',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF091A2A),
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Find your perfect PG',
                            style: TextStyle(
                              fontSize: 15,
                              color: Color(0xFF758595),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      
                      // Location selector dropdown dropdown matching the icon and name
                      InkWell(
                        onTap: () {
                          // Simple bottom sheet to choose location
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                            ),
                            builder: (context) {
                              return Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Select Location',
                                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    ListTile(
                                      leading: const Icon(Icons.location_on, color: Color(0xFF13B99D)),
                                      title: const Text('Rajkot, Gujarat'),
                                      trailing: _selectedCity == 'Rajkot' ? const Icon(Icons.check, color: Color(0xFF13B99D)) : null,
                                      onTap: () {
                                        setState(() {
                                          _selectedCity = 'Rajkot';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.location_on, color: Color(0xFF13B99D)),
                                      title: const Text('Ahmedabad, Gujarat'),
                                      trailing: _selectedCity == 'Ahmedabad' ? const Icon(Icons.check, color: Color(0xFF13B99D)) : null,
                                      onTap: () {
                                        setState(() {
                                          _selectedCity = 'Ahmedabad';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                  ],
                                ),
                              );
                            },
                          );
                        },
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              color: Color(0xFFE53935),
                              size: 18,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _selectedCity == 'Rajkot' ? 'Rajkot, Gujarat' : 'Prahlad Nagar',
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF091A2A),
                              ),
                            ),
                            const SizedBox(width: 2),
                            const Icon(
                              Icons.keyboard_arrow_down,
                              color: Color(0xFF091A2A),
                              size: 18,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Search Bar
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _searchController,
                      onChanged: (value) {
                        setState(() {
                          _searchQuery = value;
                        });
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search PG, location or area...',
                        hintStyle: TextStyle(
                          color: Color(0xFFB0BAC5),
                          fontSize: 14,
                        ),
                        prefixIcon: Icon(
                          Icons.search,
                          color: Color(0xFF758595),
                          size: 22,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 14, horizontal: 16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Browse by Category Title
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Browse by Category',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF091A2A),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          setState(() {
                            _selectedCategory = ''; // Reset filter
                          });
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            color: Color(0xFF13B99D),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 4),

                // Category List
                SizedBox(
                  height: 96,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    children: [
                      _buildCategoryItem(
                        title: 'Boys PG',
                        icon: Icons.person_rounded,
                        color: const Color(0xFFEBFDFB),
                        isSelected: _selectedCategory == 'Boys PG',
                        onTap: () => _toggleCategory('Boys PG'),
                      ),
                      _buildCategoryItem(
                        title: 'Girls PG',
                        icon: Icons.person_3_rounded,
                        color: const Color(0xFFFFF0F5),
                        isSelected: _selectedCategory == 'Girls PG',
                        onTap: () => _toggleCategory('Girls PG'),
                      ),
                      _buildCategoryItem(
                        title: 'Hostels',
                        icon: Icons.domain_rounded,
                        color: const Color(0xFFF0FDF4),
                        isSelected: _selectedCategory == 'Hostels',
                        onTap: () => _toggleCategory('Hostels'),
                      ),
                      _buildCategoryItem(
                        title: 'Flats',
                        icon: Icons.apartment_rounded,
                        color: const Color(0xFFFFF8EE),
                        isSelected: _selectedCategory == 'Flats',
                        onTap: () => _toggleCategory('Flats'),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Popular PGs Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Popular PGs',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF091A2A),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            color: Color(0xFF13B99D),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Popular PGs ListView
                ValueListenableBuilder<List<PGAccommodation>>(
                  valueListenable: _dataService.pgsNotifier,
                  builder: (context, pgs, child) {
                    // Filter logic
                    final filteredPgs = pgs.where((pg) {
                      final matchesCity = pg.city.toLowerCase() == _selectedCity.toLowerCase();
                      final matchesCategory = _selectedCategory.isEmpty || pg.category == _selectedCategory;
                      final matchesSearch = _searchQuery.isEmpty ||
                          pg.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          pg.location.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          pg.category.toLowerCase().contains(_searchQuery.toLowerCase());
                      return matchesCity && matchesCategory && matchesSearch;
                    }).toList();

                    final popularPgs = filteredPgs.where((pg) => pg.isPopular || pg.rating >= 4.5).toList();

                    if (popularPgs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                        child: Text(
                          'No popular PGs found matching criteria in this location.',
                          style: TextStyle(color: Color(0xFF758595), fontSize: 13),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        itemCount: popularPgs.length,
                        itemBuilder: (context, index) {
                          final pg = popularPgs[index];
                          return _buildPGCard(pg, screenWidth);
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 18),

                // Nearby You Section
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Nearby You',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF091A2A),
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            color: Color(0xFF13B99D),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Nearby PGs ListView
                ValueListenableBuilder<List<PGAccommodation>>(
                  valueListenable: _dataService.pgsNotifier,
                  builder: (context, pgs, child) {
                    // Filter logic
                    final filteredPgs = pgs.where((pg) {
                      final matchesCity = pg.city.toLowerCase() == _selectedCity.toLowerCase();
                      final matchesCategory = _selectedCategory.isEmpty || pg.category == _selectedCategory;
                      final matchesSearch = _searchQuery.isEmpty ||
                          pg.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                          pg.location.toLowerCase().contains(_searchQuery.toLowerCase());
                      return matchesCity && matchesCategory && matchesSearch;
                    }).toList();

                    final nearbyPgs = filteredPgs.where((pg) => pg.isNearby || !pg.isPopular).toList();

                    if (nearbyPgs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                        child: Text(
                          'No nearby PGs found matching criteria in this location.',
                          style: TextStyle(color: Color(0xFF758595), fontSize: 13),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                        itemCount: nearbyPgs.length,
                        itemBuilder: (context, index) {
                          final pg = nearbyPgs[index];
                          return _buildPGCard(pg, screenWidth);
                        },
                      ),
                    );
                  },
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _toggleCategory(String category) {
    setState(() {
      if (_selectedCategory == category) {
        _selectedCategory = ''; // Deselect
      } else {
        _selectedCategory = category;
      }
    });
  }

  Widget _buildCategoryItem({
    required String title,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 80,
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? const Color(0xFF13B99D) : Colors.black.withValues(alpha: 0.04),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected ? const Color(0xFF13B99D) : const Color(0xFF091A2A),
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected ? const Color(0xFF13B99D) : const Color(0xFF091A2A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPGCard(PGAccommodation pg, double screenWidth) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: _dataService.savedPgIdsNotifier,
      builder: (context, savedIds, child) {
        final isFavorited = savedIds.contains(pg.id);

        return Container(
          width: 190,
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child: Image.network(
                      pg.imageUrl,
                      height: 105,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 105,
                          color: const Color(0xFFEBFDFB),
                          child: const Center(
                            child: Icon(Icons.home_work_rounded, color: Color(0xFF13B99D), size: 40),
                          ),
                        );
                      },
                    ),
                  ),

                  // Favorite Button Overlay
                  Positioned(
                    top: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: () {
                        _dataService.toggleFavorite(pg.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorited ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                          color: isFavorited ? Colors.red : const Color(0xFF758595),
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Info Section
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Name & Rating Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              pg.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF091A2A),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                              const SizedBox(width: 2),
                              Text(
                                pg.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF758595),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      // Price Row
                      Row(
                        children: [
                          Text(
                            '₹${pg.price.toInt()}',
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF13B99D),
                            ),
                          ),
                          const Text(
                            '/month',
                            style: TextStyle(
                              fontSize: 10,
                              color: Color(0xFF758595),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Row(
                            children: [
                              const Icon(Icons.location_on, color: Color(0xFF758595), size: 12),
                              const SizedBox(width: 2),
                              Text(
                                pg.location,
                                style: const TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF758595),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Amenities row
                      Row(
                        children: [
                          if (pg.hasWifi)
                            Container(
                              margin: const EdgeInsets.only(right: 6),
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBFDFB),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.wifi, size: 10, color: Color(0xFF13B99D)),
                                  SizedBox(width: 2),
                                  Text('Wifi', style: TextStyle(fontSize: 8, color: Color(0xFF13B99D), fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                          if (pg.hasAC)
                            Container(
                              padding: const EdgeInsets.all(3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF0F5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Row(
                                children: const [
                                  Icon(Icons.ac_unit, size: 10, color: Colors.pink),
                                  SizedBox(width: 2),
                                  Text('A.C', style: TextStyle(fontSize: 8, color: Colors.pink, fontWeight: FontWeight.bold)),
                                ],
                              ),
                            ),
                        ],
                      ),

                      const Spacer(),

                      // Book Now Button
                      SizedBox(
                        width: double.infinity,
                        height: 28,
                        child: ElevatedButton(
                          onPressed: () => _showBookingDialog(pg),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF13B99D),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Book Now',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ==========================================
// 2. SAVED TAB (FAVORITES)
// ==========================================
class SavedTab extends StatelessWidget {
  const SavedTab({super.key});

  @override
  Widget build(BuildContext context) {
    final DataService dataService = DataService();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFD),
      appBar: AppBar(
        title: const Text('Saved PGs', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF091A2A))),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<String>>(
        valueListenable: dataService.savedPgIdsNotifier,
        builder: (context, savedIds, child) {
          return ValueListenableBuilder<List<PGAccommodation>>(
            valueListenable: dataService.pgsNotifier,
            builder: (context, pgs, child) {
              final savedPgs = pgs.where((pg) => savedIds.contains(pg.id)).toList();

              if (savedPgs.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1FBFA),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.favorite_border_rounded,
                          size: 60,
                          color: Color(0xFF13B99D),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No Saved PGs yet',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF091A2A)),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Tap the heart icon on PGs to save them here.',
                        style: TextStyle(fontSize: 14, color: Color(0xFF758595)),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: savedPgs.length,
                itemBuilder: (context, index) {
                  final pg = savedPgs[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(12),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          pg.imageUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 80,
                            height: 80,
                            color: const Color(0xFFEBFDFB),
                            child: const Icon(Icons.home_work_rounded, color: Color(0xFF13B99D)),
                          ),
                        ),
                      ),
                      title: Text(
                        pg.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF091A2A)),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(Icons.location_on, size: 14, color: Color(0xFF758595)),
                              const SizedBox(width: 2),
                              Text(pg.location, style: const TextStyle(fontSize: 12)),
                              const SizedBox(width: 8),
                              const Icon(Icons.star_rounded, size: 14, color: Colors.amber),
                              const SizedBox(width: 2),
                              Text(pg.rating.toString(), style: const TextStyle(fontSize: 12)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '₹${pg.price.toInt()}/month',
                            style: const TextStyle(fontWeight: FontWeight.w700, color: Color(0xFF13B99D)),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.favorite_rounded, color: Colors.red),
                        onPressed: () {
                          dataService.toggleFavorite(pg.id);
                        },
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

// ==========================================
// 3. BOOKING TAB (STATEFUL FLOW)
// ==========================================
class BookingTab extends StatelessWidget {
  const BookingTab({super.key});

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final DataService dataService = DataService();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFD),
      appBar: AppBar(
        title: const Text('My Bookings', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF091A2A))),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
      ),
      body: ValueListenableBuilder<List<PGBooking>>(
        valueListenable: dataService.bookingsNotifier,
        builder: (context, bookings, child) {
          if (bookings.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1FBFA),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.book_online_rounded,
                      size: 60,
                      color: Color(0xFF13B99D),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'No Bookings yet',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF091A2A)),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Go to Home and book your first PG accommodation!',
                    style: TextStyle(fontSize: 14, color: Color(0xFF758595)),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final booking = bookings[index];
              final pg = booking.pg;

              Color statusColor = Colors.orange;
              IconData statusIcon = Icons.hourglass_empty_rounded;
              if (booking.status == 'Approved') {
                statusColor = const Color(0xFF13B99D);
                statusIcon = Icons.check_circle_rounded;
              } else if (booking.status == 'Cancelled') {
                statusColor = Colors.red;
                statusIcon = Icons.cancel_rounded;
              }

              return Container(
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.network(
                          pg.imageUrl,
                          width: 64,
                          height: 64,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: 64,
                            height: 64,
                            color: const Color(0xFFEBFDFB),
                            child: const Icon(Icons.home_work_rounded, color: Color(0xFF13B99D)),
                          ),
                        ),
                      ),
                      title: Text(
                        pg.name,
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF091A2A)),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Text('Sharing: ${booking.roomType}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
                          const SizedBox(height: 2),
                          Text('Check-in: ${_formatDate(booking.checkInDate)}', style: const TextStyle(fontSize: 12, color: Color(0xFF758595))),
                        ],
                      ),
                      trailing: Text(
                        '₹${pg.price.toInt()}/mo',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF091A2A)),
                      ),
                    ),
                    const Divider(height: 1, thickness: 1),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(statusIcon, color: statusColor, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                booking.status == 'Pending' ? 'Pending Approval' : booking.status,
                                style: TextStyle(
                                  color: statusColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                ),
                              ),
                              if (booking.status == 'Pending') ...[
                                const SizedBox(width: 8),
                                const SizedBox(
                                  width: 12,
                                  height: 12,
                                  child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation(Color(0xFF13B99D))),
                                ),
                              ]
                            ],
                          ),
                          if (booking.status != 'Cancelled')
                            TextButton(
                              onPressed: () {
                                dataService.cancelBooking(booking.id);
                              },
                              style: TextButton.styleFrom(foregroundColor: Colors.red),
                              child: const Text('Cancel Booking', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

// ==========================================
// 4. PROFILE TAB
// ==========================================
class ProfileTab extends StatelessWidget {
  const ProfileTab({super.key});

  @override
  Widget build(BuildContext context) {
    final DataService dataService = DataService();

    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFD),
      appBar: AppBar(
        title: const Text('Profile', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF091A2A))),
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
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'User 13',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF091A2A)),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'user13@gmail.com',
                    style: TextStyle(fontSize: 14, color: Color(0xFF758595), fontWeight: FontWeight.w500),
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
                      valueListenable: dataService.bookingsNotifier,
                      builder: (context, bookings, child) {
                        final active = bookings.where((b) => b.status != 'Cancelled').length;
                        return _buildStatCard('Active Bookings', active.toString(), Icons.home_work_outlined);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ValueListenableBuilder<List<String>>(
                      valueListenable: dataService.savedPgIdsNotifier,
                      builder: (context, saved, child) {
                        return _buildStatCard('Saved Listings', saved.length.toString(), Icons.favorite_border_rounded);
                      },
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Profile List items
            _buildProfileListTile(context, 'Edit Profile', Icons.edit_outlined, () {}),
            _buildProfileListTile(context, 'My Preferred Location', Icons.pin_drop_outlined, () {}),
            _buildProfileListTile(context, 'Notifications', Icons.notifications_none_rounded, () {}),
            _buildProfileListTile(context, 'Privacy Policy', Icons.security_rounded, () {}),
            _buildProfileListTile(context, 'Help & Support', Icons.support_agent_rounded, () {}),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),

            // Logout
            _buildProfileListTile(
              context,
              'Log Out',
              Icons.logout_rounded,
              () {
                // Show confirm logout dialog
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Log Out'),
                    content: const Text('Are you sure you want to log out of the PG Finder application?'),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel', style: TextStyle(color: Color(0xFF758595))),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context); // Pop dialog
                          Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => const LoginPage()),
                            (route) => false,
                          );
                        },
                        child: const Text('Log Out', style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
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
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF091A2A)),
              ),
              Text(
                title,
                style: const TextStyle(fontSize: 11, color: Color(0xFF758595), fontWeight: FontWeight.w500),
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
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ListTile(
          onTap: onTap,
          leading: Icon(icon, color: iconColor),
          title: Text(
            title,
            style: TextStyle(fontWeight: FontWeight.w600, color: textColor, fontSize: 14.5),
          ),
          trailing: Icon(Icons.chevron_right_rounded, color: Colors.grey[400]),
        ),
      ),
    );
  }
}
