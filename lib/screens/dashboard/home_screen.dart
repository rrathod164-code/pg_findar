import 'package:flutter/material.dart';
import '../../models/pg_model.dart';
import '../../services/api_service.dart';

/// ============================================================================
/// HOME SCREEN (EXPLORE & BOOK PGS)
/// ============================================================================
/// Displays city selector, search filter, categories, popular PGs,
/// nearby PGs, and booking bottom sheet.
/// ============================================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  final TextEditingController _searchController = TextEditingController();

  String _selectedCity = 'Rajkot';
  String _selectedCategory = ''; // Empty means all categories
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Format date helper (DD/MM/YYYY)
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // --------------------------------------------------------------------------
  // Booking Bottom Sheet Modal
  // --------------------------------------------------------------------------
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
                  const Text(
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
                        onTap: () => setModalState(
                            () => selectedRoomType = 'Single Sharing'),
                      ),
                      const SizedBox(width: 10),
                      _buildSharingOption(
                        title: 'Double',
                        price: pg.price,
                        isSelected: selectedRoomType == 'Double Sharing',
                        onTap: () => setModalState(
                            () => selectedRoomType = 'Double Sharing'),
                      ),
                      const SizedBox(width: 10),
                      _buildSharingOption(
                        title: 'Triple',
                        price: pg.price - 1000,
                        isSelected: selectedRoomType == 'Triple Sharing',
                        onTap: () => setModalState(
                            () => selectedRoomType = 'Triple Sharing'),
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
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
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
                          const Icon(Icons.calendar_today_rounded,
                              color: Color(0xFF13B99D), size: 20),
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
                        _apiService.bookPG(pg, selectedDate, selectedRoomType);
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Row(
                              children: [
                                const Icon(Icons.check_circle_rounded,
                                    color: Colors.white),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                      'Booking request for ${pg.name} sent successfully!'),
                                ),
                              ],
                            ),
                            backgroundColor: const Color(0xFF13B99D),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF13B99D),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14)),
                      ),
                      child: const Text(
                        'Confirm & Request Booking',
                        style: TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
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
                  color: isSelected
                      ? const Color(0xFF13B99D)
                      : const Color(0xFF091A2A),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₹${price.toInt()}/mo',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF13B99D)
                      : const Color(0xFF758595),
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

    return Scaffold(
      backgroundColor: const Color(0xFFFBFDFD),
      body: Stack(
        children: [
          // Background Color
          Container(
            width: double.infinity,
            height: double.infinity,
            color: const Color(0xFFFBFDFD),
          ),

          // Translucent background circles
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
                        Expanded(
                          child: Column(
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
                        ),

                        // Location selector dropdown
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(20)),
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
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 16),
                                    ListTile(
                                      leading: const Icon(Icons.location_on,
                                          color: Color(0xFF13B99D)),
                                      title: const Text('Rajkot, Gujarat'),
                                      trailing: _selectedCity == 'Rajkot'
                                          ? const Icon(Icons.check,
                                              color: Color(0xFF13B99D))
                                          : null,
                                      onTap: () {
                                        setState(() {
                                          _selectedCity = 'Rajkot';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(Icons.location_on,
                                          color: Color(0xFF13B99D)),
                                      title: const Text('Ahmedabad, Gujarat'),
                                      trailing: _selectedCity == 'Ahmedabad'
                                          ? const Icon(Icons.check,
                                              color: Color(0xFF13B99D))
                                          : null,
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
                              _selectedCity == 'Rajkot'
                                  ? 'Rajkot, Gujarat'
                                  : 'Ahmedabad, Gujarat',
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
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 14, horizontal: 16),
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
                    padding:
                        EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                    children: [
                      _buildCategoryItem(
                        title: 'Boys PG',
                        icon: Icons.person_rounded,
                        color: const Color(0xFFEBFDFB),
                        isSelected: _selectedCategory == 'Boys',
                        onTap: () => _toggleCategory('Boys'),
                      ),
                      _buildCategoryItem(
                        title: 'Girls PG',
                        icon: Icons.person_3_rounded,
                        color: const Color(0xFFFFF0F5),
                        isSelected: _selectedCategory == 'Girls',
                        onTap: () => _toggleCategory('Girls'),
                      ),
                      _buildCategoryItem(
                        title: 'Hostels',
                        icon: Icons.domain_rounded,
                        color: const Color(0xFFF0FDF4),
                        isSelected: _selectedCategory == 'Both',
                        onTap: () => _toggleCategory('Both'),
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

                // Popular PGs Section Header
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
                  valueListenable: _apiService.pgsNotifier,
                  builder: (context, pgs, child) {
                    final filteredPgs = pgs.where((pg) {
                      final matchesCity =
                          pg.city.toLowerCase() == _selectedCity.toLowerCase();
                      final matchesCategory = _selectedCategory.isEmpty ||
                          pg.category == _selectedCategory;
                      final matchesSearch = _searchQuery.isEmpty ||
                          pg.name
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()) ||
                          pg.location
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()) ||
                          pg.category
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase());
                      return matchesCity && matchesCategory && matchesSearch;
                    }).toList();

                    final popularPgs = filteredPgs
                        .where((pg) => pg.isPopular || pg.rating >= 4.5)
                        .toList();

                    if (popularPgs.isEmpty) {
                      return const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                        child: Text(
                          'No popular PGs found matching criteria in this location.',
                          style:
                              TextStyle(color: Color(0xFF758595), fontSize: 13),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05),
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

                // Nearby You Section Header
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
                  valueListenable: _apiService.pgsNotifier,
                  builder: (context, pgs, child) {
                    final filteredPgs = pgs.where((pg) {
                      final matchesCity =
                          pg.city.toLowerCase() == _selectedCity.toLowerCase();
                      final matchesCategory = _selectedCategory.isEmpty ||
                          pg.category == _selectedCategory;
                      final matchesSearch = _searchQuery.isEmpty ||
                          pg.name
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()) ||
                          pg.location
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase()) ||
                          pg.category
                              .toLowerCase()
                              .contains(_searchQuery.toLowerCase());
                      return matchesCity && matchesCategory && matchesSearch;
                    }).toList();

                    final nearbyPgs = filteredPgs
                        .where((pg) => pg.isNearby || !pg.isPopular)
                        .toList();

                    if (nearbyPgs.isEmpty) {
                      return const Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                        child: Text(
                          'No nearby PGs found matching criteria in this location.',
                          style:
                              TextStyle(color: Color(0xFF758595), fontSize: 13),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 250,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.05),
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
    ),
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
        margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 6),
        padding: const EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected
                ? const Color(0xFF13B99D)
                : Colors.black.withValues(alpha: 0.04),
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
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: isSelected
                    ? const Color(0xFF13B99D)
                    : const Color(0xFF091A2A),
                size: 19,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                color: isSelected
                    ? const Color(0xFF13B99D)
                    : const Color(0xFF091A2A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPGCard(PGAccommodation pg, double screenWidth) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: _apiService.savedPgIdsNotifier,
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
                            child: Icon(Icons.home_work_rounded,
                                color: Color(0xFF13B99D), size: 40),
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
                        _apiService.toggleFavorite(pg.id);
                      },
                      child: Container(
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isFavorited
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          color: isFavorited
                              ? Colors.red
                              : const Color(0xFF758595),
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
                              const Icon(Icons.star_rounded,
                                  color: Colors.amber, size: 14),
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
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF13B99D),
                            ),
                          ),
                          const Text(
                            '/mo',
                            style: TextStyle(
                              fontSize: 9.5,
                              color: Color(0xFF758595),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const Spacer(),
                          Flexible(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.location_on,
                                    color: Color(0xFF758595), size: 11),
                                const SizedBox(width: 2),
                                Flexible(
                                  child: Text(
                                    pg.location,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w500,
                                      color: Color(0xFF758595),
                                    ),
                                  ),
                                ),
                              ],
                            ),
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
                                  Icon(Icons.wifi,
                                      size: 10, color: Color(0xFF13B99D)),
                                  SizedBox(width: 2),
                                  Text('Wifi',
                                      style: TextStyle(
                                          fontSize: 8,
                                          color: Color(0xFF13B99D),
                                          fontWeight: FontWeight.bold)),
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
                                  Icon(Icons.ac_unit,
                                      size: 10, color: Colors.pink),
                                  SizedBox(width: 2),
                                  Text('A.C',
                                      style: TextStyle(
                                          fontSize: 8,
                                          color: Colors.pink,
                                          fontWeight: FontWeight.bold)),
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

// Alias for compatibility
typedef HomeTab = HomeScreen;
