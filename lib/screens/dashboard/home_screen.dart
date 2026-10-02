import 'package:flutter/material.dart';
import 'package:pg_findar/resources/theme.dart';
import 'package:pg_findar/widgets/dashboard_background.dart';
import '../../models/pg_model.dart';
import '../../services/api_service.dart';
import '../../widgets/app_image.dart';
import '../pg_details/pg_detail_screen.dart';
import '../pg_details/pg_list_page.dart';

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
  final String _searchQuery = '';

  // Stores favorited PG IDs (beginner-friendly frontend state)
  final Set<String> _favoritePgIds = {};

  @override
  void initState() {
    super.initState();
    _apiService.reloadSampleData();
  }

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
  // ignore: unused_element
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
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
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
                      color: AppColors.primary,
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
                          () => selectedRoomType = 'Single Sharing',
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildSharingOption(
                        title: 'Double',
                        price: pg.price,
                        isSelected: selectedRoomType == 'Double Sharing',
                        onTap: () => setModalState(
                          () => selectedRoomType = 'Double Sharing',
                        ),
                      ),
                      const SizedBox(width: 10),
                      _buildSharingOption(
                        title: 'Triple',
                        price: pg.price - 1000,
                        isSelected: selectedRoomType == 'Triple Sharing',
                        onTap: () => setModalState(
                          () => selectedRoomType = 'Triple Sharing',
                        ),
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
                                primary: AppColors.primary,
                                onPrimary: Colors.white,
                                onSurface: AppColors.textDark,
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
                        horizontal: 16,
                        vertical: 14,
                      ),
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
                          const Icon(
                            Icons.calendar_today_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
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
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    'Booking request for ${pg.name} sent successfully!',
                                  ),
                                ),
                              ],
                            ),
                            backgroundColor: AppColors.primary,
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Confirm & Request Booking',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
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
            color: isSelected ? AppColors.primaryLight : Colors.white,
            border: Border.all(
              color: isSelected ? AppColors.primary : Colors.grey[300]!,
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
                      ? AppColors.primary
                      : AppColors.textDark,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '₹${price.toInt()}/mo',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textGrey,
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
    const double horizontalPadding = 16.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: DashboardBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Header (Hello User & Location Selector)
                Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    top: screenHeight * 0.02,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ValueListenableBuilder<String>(
                              valueListenable: _apiService.userNameNotifier,
                              builder: (context, userName, _) {
                                return Text(
                                  'Hello, $userName',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF091A2A),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 4),
                            const Text(
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
                                top: Radius.circular(20),
                              ),
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
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.location_on,
                                        color: AppColors.primary,
                                      ),
                                      title: const Text('Rajkot, Gujarat'),
                                      trailing: _selectedCity == 'Rajkot'
                                          ? const Icon(
                                              Icons.check,
                                              color: AppColors.primary,
                                            )
                                          : null,
                                      onTap: () {
                                        setState(() {
                                          _selectedCity = 'Rajkot';
                                        });
                                        Navigator.pop(context);
                                      },
                                    ),
                                    ListTile(
                                      leading: const Icon(
                                        Icons.location_on,
                                        color: AppColors.primary,
                                      ),
                                      title: const Text('Ahmedabad, Gujarat'),
                                      trailing: _selectedCity == 'Ahmedabad'
                                          ? const Icon(
                                              Icons.check,
                                              color: AppColors.primary,
                                            )
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

                // Search Bar (Tap redirects to the search filter page)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
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
                      readOnly:
                          true, // Prevents keyboard on home screen, triggers onTap instead
                      onTap: () {
                        // Redirect to the Search & Filter page (PGListPage)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PGListPage(
                              title: 'Search PGs',
                              listType: PGListType.all,
                              selectedCity: _selectedCity,
                              autoFocusSearch: true,
                            ),
                          ),
                        );
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
                        suffixIcon: Padding(
                          padding: EdgeInsets.only(right: 6),
                          child: Icon(
                            Icons.tune_rounded,
                            color: AppColors.primary,
                            size: 20,
                          ),
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // Browse by Category Title
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
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
                          // Tap to view all PGs list
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PGListPage(
                                title: 'All PGs',
                                listType: PGListType.all,
                                selectedCity: _selectedCity,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),
                // Category Row (Static Cards - No horizontal scrolling)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: _buildCategoryItem(
                          title: 'Boys PG',
                          icon: Icons.person_rounded,
                          color: AppColors.primaryLight,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCategoryItem(
                          title: 'Girls PG',
                          icon: Icons.person_3_rounded,
                          color: const Color(0xFFFFF0F5),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCategoryItem(
                          title: 'Hostels',
                          icon: Icons.domain_rounded,
                          color: const Color(0xFFF0FDF4),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: _buildCategoryItem(
                          title: 'Flats',
                          icon: Icons.apartment_rounded,
                          color: const Color(0xFFFFF8EE),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

                // Popular PGs Section Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PGListPage(
                                title: 'Popular PGs',
                                listType: PGListType.popular,
                                selectedCity: _selectedCity,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            color: AppColors.primary,
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
                      final matchesSearch =
                          _searchQuery.isEmpty ||
                          pg.name.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          ) ||
                          pg.location.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          ) ||
                          pg.category.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          );
                      return matchesCity && matchesSearch;
                    }).toList();

                    // Show popular PGs (rating >= 4.5 or isPopular)
                    final popularPgs = filteredPgs
                        .where((pg) => pg.isPopular || pg.rating >= 4.5)
                        .toList();

                    if (popularPgs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 24,
                        ),
                        child: Text(
                          'No popular PGs found matching criteria in this location.',
                          style: TextStyle(
                            color: Color(0xFF758595),
                            fontSize: 13,
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 242,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(
                          left: horizontalPadding - 8,
                          right: horizontalPadding - 8,
                        ),
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
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
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
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PGListPage(
                                title: 'Nearby PGs',
                                listType: PGListType.nearby,
                                selectedCity: _selectedCity,
                              ),
                            ),
                          );
                        },
                        child: const Text(
                          'See All',
                          style: TextStyle(
                            color: AppColors.primary,
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
                      final matchesSearch =
                          _searchQuery.isEmpty ||
                          pg.name.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          ) ||
                          pg.location.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          ) ||
                          pg.category.toLowerCase().contains(
                            _searchQuery.toLowerCase(),
                          );
                      return matchesCity && matchesSearch;
                    }).toList();

                    // Show nearby PGs
                    final nearbyPgs = filteredPgs
                        .where((pg) => pg.isNearby || !pg.isPopular)
                        .toList();

                    if (nearbyPgs.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 20,
                          horizontal: 24,
                        ),
                        child: Text(
                          'No nearby PGs found matching criteria in this location.',
                          style: TextStyle(
                            color: Color(0xFF758595),
                            fontSize: 13,
                          ),
                        ),
                      );
                    }

                    return SizedBox(
                      height: 242,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.only(
                          left: horizontalPadding - 8,
                          right: horizontalPadding - 8,
                        ),
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
      ),
    );
  }

  // --------------------------------------------------------------------------
  // CATEGORY CARD WIDGET (Display Only - No Click Action, Beginner Friendly)
  // --------------------------------------------------------------------------
  // CATEGORY CARD WIDGET (Static Display Only - Beginner Friendly)
  // --------------------------------------------------------------------------
  // Clean card widget to display Boys PG, Girls PG, etc. evenly in a Row.
  Widget _buildCategoryItem({
    required String title,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.black.withValues(alpha: 0.04),
          width: 1,
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
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            child: Icon(icon, color: const Color(0xFF091A2A), size: 19),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF091A2A),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPGCard(PGAccommodation pg, double screenWidth) {
    final bool isFavorited = _favoritePgIds.contains(pg.id);

    return Container(
      width: 190,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
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
                child: AppImage(
                  imageUrl: pg.imageUrl,
                  height: 92,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),

              // Heart Icon Button (Tapping turns it red, does NOT open details)
              Positioned(
                top: 8,
                right: 8,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      if (_favoritePgIds.contains(pg.id)) {
                        _favoritePgIds.remove(pg.id);
                      } else {
                        _favoritePgIds.add(pg.id);
                      }
                    });
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
                      color: isFavorited ? Colors.red : const Color(0xFF758595),
                      size: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),

          // Info Section
          Padding(
            padding: const EdgeInsets.fromLTRB(10, 5, 10, 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
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
                        const Icon(
                          Icons.star_rounded,
                          color: Colors.amber,
                          size: 14,
                        ),
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

                const SizedBox(height: 5),

                // Price Row
                Row(
                  children: [
                    Text(
                      '₹${pg.price.toInt()}',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                      ),
                    ),
                    const Text(
                      '/month',
                      style: TextStyle(fontSize: 10, color: Color(0xFF758595)),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                // Location Row
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 11,
                      color: Color(0xFF758595),
                    ),
                    const SizedBox(width: 2),
                    Expanded(
                      child: Text(
                        pg.location,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          color: Color(0xFF758595),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 5),

                // Badges Row (Gender & AC side-by-side)
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryLight,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        pg.gender,
                        style: const TextStyle(
                          fontSize: 9,
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    if (pg.hasAC) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF0F5),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.ac_unit, size: 10, color: Colors.pink),
                            SizedBox(width: 2),
                            Text(
                              'A.C',
                              style: TextStyle(
                                fontSize: 8,
                                color: Colors.pink,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),

                const SizedBox(height: 6),

                // Book Now Button
                SizedBox(
                  width: double.infinity,
                  height: 28,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PgDetailScreen(pg: pg),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
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
        ],
      ),
    );
  }
}

// Alias for compatibility
typedef HomeTab = HomeScreen;
