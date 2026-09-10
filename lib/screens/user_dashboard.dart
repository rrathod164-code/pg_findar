import 'package:flutter/material.dart';

import '../models/pg_model.dart';
import '../services/data_service.dart';
import '../login.dart'; // To navigate back on logout
import 'widgets/filter_bottom_sheet.dart';
import 'pg_list_page.dart';

class UserDashboardPage extends StatefulWidget {
  const UserDashboardPage({super.key});

  @override
  State<UserDashboardPage> createState() => _UserDashboardPageState();
}

class _UserDashboardPageState extends State<UserDashboardPage> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final tabs = [
      const HomeTab(),
      const SavedTab(),
      const BookingTab(),
      ProfileTab(
        onNavigateTab: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    ];

    return Scaffold(
      body: tabs[_currentIndex],
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
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 12,
          ),
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
// 1. HOME TAB (WITH SMART SEARCH & FUNCTIONALITY FILTERS)
// ==========================================
class HomeTab extends StatefulWidget {
  const HomeTab({super.key});

  @override
  State<HomeTab> createState() => _HomeTabState();
}

class _HomeTabState extends State<HomeTab> {
  final DataService _dataService = DataService();

  String _selectedCity = 'Rajkot';
  String _selectedCategory = ''; // Empty means all
  bool _isSearchView = false;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  PGFilterCriteria _filterCriteria = const PGFilterCriteria();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  // Format date helper to avoid packages
  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  // Open the Apply Filters Modal Sheet matching user's design
  void _openFilterSheet() {
    FilterBottomSheet.show(
      context,
      initialCriteria: _filterCriteria,
      onApply: (newCriteria) {
        setState(() {
          _filterCriteria = newCriteria;
          _isSearchView = true;
        });
      },
    );
  }

  // Show detailed PG info with all facilities and booking option
  void _showPGDetailsDialog(PGAccommodation pg) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(28),
              topRight: Radius.circular(28),
            ),
          ),
          padding: EdgeInsets.only(
            top: 20,
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
                  width: 48,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      pg.imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        width: 90,
                        height: 90,
                        color: const Color(0xFFEBFDFB),
                        child: const Icon(
                          Icons.home_work_rounded,
                          color: Color(0xFF13B99D),
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          pg.name,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF091A2A),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 14,
                              color: Color(0xFF13B99D),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              '${pg.location}, ${pg.city}',
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF758595),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEBFDFB),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(
                                pg.category,
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF13B99D),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 16,
                            ),
                            const SizedBox(width: 2),
                            Text(
                              pg.rating.toString(),
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF091A2A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Available Facilities & Amenities',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF091A2A),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _buildFacilityBadge('Wifi', pg.hasWifi, Icons.wifi),
                  _buildFacilityBadge('AC', pg.hasAC, Icons.ac_unit),
                  _buildFacilityBadge('Food', pg.hasFood, Icons.restaurant),
                  _buildFacilityBadge(
                    'Parking',
                    pg.hasParking,
                    Icons.local_parking,
                  ),
                  _buildFacilityBadge(
                    'Laundry',
                    pg.hasLaundry,
                    Icons.local_laundry_service,
                  ),
                  _buildFacilityBadge('TV', pg.hasTV, Icons.tv),
                  _buildFacilityBadge('Fridge', pg.hasFridge, Icons.kitchen),
                  _buildFacilityBadge('Gyser', pg.hasGeyser, Icons.water_drop),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Monthly Rent',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFF758595),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '₹${pg.price.toInt()}/mo',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF13B99D),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _showBookingDialog(pg);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF13B99D),
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 28),
                      ),
                      child: const Text(
                        'Book Now',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFacilityBadge(String name, bool isAvailable, IconData icon) {
    final bool isUserRequested = _filterCriteria.facilities.contains(name);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: isAvailable
            ? (isUserRequested
                  ? const Color(0xFF13B99D)
                  : const Color(0xFFF1FBFA))
            : Colors.grey.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isAvailable
              ? (isUserRequested
                    ? const Color(0xFF13B99D)
                    : const Color(0xFF13B99D).withValues(alpha: 0.3))
              : Colors.transparent,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: isAvailable
                ? (isUserRequested ? Colors.white : const Color(0xFF13B99D))
                : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            name,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: isAvailable
                  ? (isUserRequested ? Colors.white : const Color(0xFF091A2A))
                  : Colors.grey,
            ),
          ),
          if (isAvailable) ...[
            const SizedBox(width: 3),
            Icon(
              Icons.check,
              size: 12,
              color: isUserRequested ? Colors.white : const Color(0xFF13B99D),
            ),
          ],
        ],
      ),
    );
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
                            color: Color(0xFF13B99D),
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
                        _dataService.bookPG(pg, selectedDate, selectedRoomType);
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
                            backgroundColor: const Color(0xFF13B99D),
                            behavior: SnackBarBehavior.floating,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF13B99D),
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

    if (_isSearchView) {
      return _buildSearchView(screenWidth, screenHeight);
    }

    return Stack(
      children: [
        // Background
        Container(
          width: double.infinity,
          height: double.infinity,
          color: const Color(0xFFFBFDFD),
        ),

        // Translucent background circles matching design
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
                                        color: Color(0xFF13B99D),
                                      ),
                                      title: const Text('Rajkot, Gujarat'),
                                      trailing: _selectedCity == 'Rajkot'
                                          ? const Icon(
                                              Icons.check,
                                              color: Color(0xFF13B99D),
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
                                        color: Color(0xFF13B99D),
                                      ),
                                      title: const Text('Ahmedabad, Gujarat'),
                                      trailing: _selectedCity == 'Ahmedabad'
                                          ? const Icon(
                                              Icons.check,
                                              color: Color(0xFF13B99D),
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
                                  : 'Prahlad Nagar, Ahmedabad',
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

                // Search Bar with Filter Button (Clicking anywhere opens Apply Filters)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: _filterCriteria.hasActiveFilters
                          ? Border.all(
                              color: const Color(0xFF13B99D),
                              width: 1.5,
                            )
                          : null,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 16,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search,
                          color: Color(0xFF758595),
                          size: 22,
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                _isSearchView = true;
                              });
                            },
                            child: Text(
                              _filterCriteria.hasActiveFilters
                                  ? (_filterCriteria.facilities.isNotEmpty
                                        ? 'Filters: ${_filterCriteria.facilities.join(', ')}'
                                        : 'Filtered: ${_filterCriteria.gender}, ₹${_filterCriteria.minPrice.toInt()}-₹${_filterCriteria.maxPrice.toInt()}')
                                  : 'Search PG, location or area...',
                              style: TextStyle(
                                color: _filterCriteria.hasActiveFilters
                                    ? const Color(0xFF091A2A)
                                    : const Color(0xFFB0BAC5),
                                fontSize: 14,
                                fontWeight: _filterCriteria.hasActiveFilters
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Interactive Filter Icon Button
                        GestureDetector(
                          onTap: _openFilterSheet,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: _filterCriteria.hasActiveFilters
                                  ? const Color(0xFF13B99D)
                                  : const Color(0xFFF1FBFA),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.tune_rounded,
                                  color: _filterCriteria.hasActiveFilters
                                      ? Colors.white
                                      : const Color(0xFF13B99D),
                                  size: 16,
                                ),
                                if (_filterCriteria.hasActiveFilters) ...[
                                  const SizedBox(width: 4),
                                  Text(
                                    '${_filterCriteria.activeFiltersCount}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Active Filter Tags Row
                if (_filterCriteria.hasActiveFilters) ...[
                  const SizedBox(height: 12),
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.06,
                    ),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      child: Row(
                        children: [
                          if (_filterCriteria.gender != 'Both')
                            _buildActiveFilterChip(
                              'Gender: ${_filterCriteria.gender}',
                              () {
                                setState(() {
                                  _filterCriteria = _filterCriteria.copyWith(
                                    gender: 'Both',
                                  );
                                });
                              },
                            ),
                          if (_filterCriteria.minPrice > 3000 ||
                              _filterCriteria.maxPrice < 10000)
                            _buildActiveFilterChip(
                              '₹${_filterCriteria.minPrice.toInt()} - ₹${_filterCriteria.maxPrice.toInt()}',
                              () {
                                setState(() {
                                  _filterCriteria = _filterCriteria.copyWith(
                                    minPrice: 3000,
                                    maxPrice: 10000,
                                  );
                                });
                              },
                            ),
                          for (final facility in _filterCriteria.facilities)
                            _buildActiveFilterChip(facility, () {
                              final updated = List<String>.from(
                                _filterCriteria.facilities,
                              )..remove(facility);
                              setState(() {
                                _filterCriteria = _filterCriteria.copyWith(
                                  facilities: updated,
                                );
                              });
                            }),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _filterCriteria = const PGFilterCriteria();
                              });
                            },
                            child: Container(
                              margin: const EdgeInsets.only(left: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.red.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Text(
                                'Clear All',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],

                const SizedBox(height: 20),

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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PGListPage(
                                title: 'All Accommodations',
                                listType: PGListType.all,
                                selectedCity: _selectedCity,
                              ),
                            ),
                          );
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
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                    ),
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

                // Main listings container using Smart Functionality & Filter Matcher
                ValueListenableBuilder<List<PGAccommodation>>(
                  valueListenable: _dataService.pgsNotifier,
                  builder: (context, pgs, child) {
                    // Base filtering for City & Search Query
                    final baseFiltered = pgs.where((pg) {
                      final matchesCity =
                          pg.city.toLowerCase() == _selectedCity.toLowerCase();
                      final matchesCategory =
                          _selectedCategory.isEmpty ||
                          pg.category == _selectedCategory;
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
                          ) ||
                          pg.facilities.any(
                            (f) => f.toLowerCase().contains(
                              _searchQuery.toLowerCase(),
                            ),
                          );
                      return matchesCity && matchesCategory && matchesSearch;
                    }).toList();

                    // If user applied filters (Price, Gender, or Facilities)
                    if (_filterCriteria.hasActiveFilters) {
                      // 1. Direct/Exact Matches: satisfies Price, Gender, AND 100% of requested facilities
                      final exactMatches = baseFiltered.where((pg) {
                        final inPrice =
                            pg.price >= _filterCriteria.minPrice &&
                            pg.price <= _filterCriteria.maxPrice;
                        final matchGender =
                            _filterCriteria.gender == 'Both' ||
                            pg.gender == _filterCriteria.gender ||
                            pg.gender == 'Both';
                        final matchesAllFacilities = _filterCriteria.facilities
                            .every((f) => pg.hasFacility(f));
                        return inPrice && matchGender && matchesAllFacilities;
                      }).toList();

                      // 2. Reference / Suggested PGs:
                      // PGs that match price/gender or fulfill some/most requested facilities
                      final referencePgs = baseFiltered.where((pg) {
                        final isNotExact = !exactMatches.contains(pg);
                        final matchCount = pg.matchingFacilitiesCount(
                          _filterCriteria.facilities,
                        );
                        final inPrice =
                            pg.price >= _filterCriteria.minPrice &&
                            pg.price <= _filterCriteria.maxPrice;
                        final matchGender =
                            _filterCriteria.gender == 'Both' ||
                            pg.gender == _filterCriteria.gender ||
                            pg.gender == 'Both';

                        if (_filterCriteria.facilities.isNotEmpty) {
                          // Has at least 1 matching facility
                          return isNotExact && matchCount > 0;
                        } else {
                          // Filtered by price/gender
                          return isNotExact && (inPrice || matchGender);
                        }
                      }).toList();

                      // Sort reference PGs by how many facilities they fulfill (descending)
                      referencePgs.sort(
                        (a, b) => b
                            .matchingFacilitiesCount(_filterCriteria.facilities)
                            .compareTo(
                              a.matchingFacilitiesCount(
                                _filterCriteria.facilities,
                              ),
                            ),
                      );

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Exact Match Section Header
                          Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth * 0.06,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF13B99D),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${exactMatches.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Exact Matches',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w800,
                                    color: Color(0xFF091A2A),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 10),

                          if (exactMatches.isEmpty)
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.06,
                                vertical: 12,
                              ),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.amber.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: Colors.amber.withValues(alpha: 0.3),
                                  ),
                                ),
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.info_outline_rounded,
                                      color: Colors.amber,
                                    ),
                                    SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        'No PG matches 100% of the selected criteria. Check the reference PGs below!',
                                        style: TextStyle(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w600,
                                          color: Color(0xFF091A2A),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          else
                            SizedBox(
                              height: 236,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05,
                                ),
                                itemCount: exactMatches.length,
                                itemBuilder: (context, index) {
                                  final pg = exactMatches[index];
                                  return _buildPGCard(
                                    pg,
                                    screenWidth,
                                    isExactMatch: true,
                                  );
                                },
                              ),
                            ),

                          const SizedBox(height: 22),

                          // Reference / Alternative PGs Section Header
                          if (referencePgs.isNotEmpty) ...[
                            Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.06,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF758595),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      '${referencePgs.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  const Text(
                                    'Reference & Alternative PGs',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w800,
                                      color: Color(0xFF091A2A),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 10),

                            SizedBox(
                              height: 236,
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(
                                  horizontal: screenWidth * 0.05,
                                ),
                                itemCount: referencePgs.length,
                                itemBuilder: (context, index) {
                                  final pg = referencePgs[index];
                                  return _buildPGCard(
                                    pg,
                                    screenWidth,
                                    isExactMatch: false,
                                  );
                                },
                              ),
                            ),
                          ],
                        ],
                      );
                    }

                    // Default View (No filters applied): Show Popular & Nearby Sections
                    final popularPgs = baseFiltered
                        .where((pg) => pg.isPopular || pg.rating >= 4.5)
                        .toList();
                    final nearbyPgs = baseFiltered
                        .where((pg) => pg.isNearby || !pg.isPopular)
                        .toList();

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Popular PGs Section Header
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06,
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
                        if (popularPgs.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 20,
                              horizontal: 24,
                            ),
                            child: Text(
                              'No popular PGs found in this location.',
                              style: TextStyle(
                                color: Color(0xFF758595),
                                fontSize: 13,
                              ),
                            ),
                          )
                        else
                          SizedBox(
                            height: 236,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05,
                              ),
                              itemCount: popularPgs.length,
                              itemBuilder: (context, index) {
                                final pg = popularPgs[index];
                                return _buildPGCard(pg, screenWidth);
                              },
                            ),
                          ),

                        const SizedBox(height: 18),

                        // Nearby You Section Header
                        Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.06,
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
                        if (nearbyPgs.isEmpty)
                          const Padding(
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
                          )
                        else
                          SizedBox(
                            height: 236,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                horizontal: screenWidth * 0.05,
                              ),
                              itemCount: nearbyPgs.length,
                              itemBuilder: (context, index) {
                                final pg = nearbyPgs[index];
                                return _buildPGCard(pg, screenWidth);
                              },
                            ),
                          ),
                      ],
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

  Widget _buildSearchView(double screenWidth, double screenHeight) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          setState(() {
            _isSearchView = false;
            _searchController.clear();
            _searchQuery = '';
          });
        }
      },
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 6),
            // Top Bar: Back button and Search Bar with Filter Icon
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Color(0xFF091A2A),
                      size: 26,
                    ),
                    onPressed: () {
                      setState(() {
                        _isSearchView = false;
                        _searchController.clear();
                        _searchQuery = '';
                      });
                    },
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search,
                            color: Color(0xFF758595),
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              autofocus: true,
                              onChanged: (val) {
                                setState(() {
                                  _searchQuery = val;
                                });
                              },
                              style: const TextStyle(
                                fontSize: 13.5,
                                color: Color(0xFF091A2A),
                              ),
                              decoration: const InputDecoration(
                                hintText: 'Search PG, location or area...',
                                hintStyle: TextStyle(
                                  color: Color(0xFFB0BAC5),
                                  fontSize: 13.5,
                                ),
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.symmetric(
                                  vertical: 10,
                                ),
                              ),
                            ),
                          ),
                          if (_searchQuery.isNotEmpty)
                            GestureDetector(
                              onTap: () {
                                _searchController.clear();
                                setState(() {
                                  _searchQuery = '';
                                });
                              },
                              child: const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 4),
                                child: Icon(
                                  Icons.clear,
                                  size: 18,
                                  color: Color(0xFF758595),
                                ),
                              ),
                            ),
                          GestureDetector(
                            onTap: _openFilterSheet,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: _filterCriteria.hasActiveFilters
                                    ? const Color(0xFF13B99D)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Icon(
                                Icons.tune_rounded,
                                color: _filterCriteria.hasActiveFilters
                                    ? Colors.white
                                    : const Color(0xFF091A2A),
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Active Filter Tags Row
            if (_filterCriteria.hasActiveFilters) ...[
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 4,
                ),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  physics: const BouncingScrollPhysics(),
                  child: Row(
                    children: [
                      if (_filterCriteria.gender != 'Both')
                        _buildActiveFilterChip(
                          'Gender: ${_filterCriteria.gender}',
                          () {
                            setState(() {
                              _filterCriteria = _filterCriteria.copyWith(
                                gender: 'Both',
                              );
                            });
                          },
                        ),
                      if (_filterCriteria.minPrice > 3000 ||
                          _filterCriteria.maxPrice < 10000)
                        _buildActiveFilterChip(
                          '₹${_filterCriteria.minPrice.toInt()} - ₹${_filterCriteria.maxPrice.toInt()}',
                          () {
                            setState(() {
                              _filterCriteria = _filterCriteria.copyWith(
                                minPrice: 3000,
                                maxPrice: 10000,
                              );
                            });
                          },
                        ),
                      for (final facility in _filterCriteria.facilities)
                        _buildActiveFilterChip(facility, () {
                          final updated = List<String>.from(
                            _filterCriteria.facilities,
                          )..remove(facility);
                          setState(() {
                            _filterCriteria = _filterCriteria.copyWith(
                              facilities: updated,
                            );
                          });
                        }),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _filterCriteria = const PGFilterCriteria();
                          });
                        },
                        child: Container(
                          margin: const EdgeInsets.only(left: 4),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Clear All',
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // PG Grid Results
            Expanded(
              child: ValueListenableBuilder<List<PGAccommodation>>(
                valueListenable: _dataService.pgsNotifier,
                builder: (context, pgs, child) {
                  // Filter by city
                  var baseList = pgs
                      .where(
                        (pg) =>
                            pg.city.toLowerCase() ==
                            _selectedCity.toLowerCase(),
                      )
                      .toList();

                  // Filter by search query
                  if (_searchQuery.isNotEmpty) {
                    final q = _searchQuery.toLowerCase().trim();
                    baseList = baseList.where((pg) {
                      return pg.name.toLowerCase().contains(q) ||
                          pg.location.toLowerCase().contains(q) ||
                          pg.category.toLowerCase().contains(q) ||
                          pg.facilities.any((f) => f.toLowerCase().contains(q));
                    }).toList();
                  }

                  // If user applied filters (Price, Gender, or Facilities)
                  if (_filterCriteria.hasActiveFilters) {
                    // Exact matches
                    final exactMatches = baseList.where((pg) {
                      final inPrice =
                          pg.price >= _filterCriteria.minPrice &&
                          pg.price <= _filterCriteria.maxPrice;
                      final matchGender =
                          _filterCriteria.gender == 'Both' ||
                          pg.gender == _filterCriteria.gender ||
                          pg.gender == 'Both';
                      final matchesAllFacilities = _filterCriteria.facilities
                          .every((f) => pg.hasFacility(f));
                      return inPrice && matchGender && matchesAllFacilities;
                    }).toList();

                    // Reference PGs that fulfill some/most requested facilities
                    final referencePgs = baseList.where((pg) {
                      final isNotExact = !exactMatches.contains(pg);
                      final matchCount = pg.matchingFacilitiesCount(
                        _filterCriteria.facilities,
                      );
                      final inPrice =
                          pg.price >= _filterCriteria.minPrice &&
                          pg.price <= _filterCriteria.maxPrice;
                      final matchGender =
                          _filterCriteria.gender == 'Both' ||
                          pg.gender == _filterCriteria.gender ||
                          pg.gender == 'Both';

                      if (_filterCriteria.facilities.isNotEmpty) {
                        return isNotExact && matchCount > 0;
                      } else {
                        return isNotExact && (inPrice || matchGender);
                      }
                    }).toList();

                    referencePgs.sort(
                      (a, b) => b
                          .matchingFacilitiesCount(_filterCriteria.facilities)
                          .compareTo(
                            a.matchingFacilitiesCount(
                              _filterCriteria.facilities,
                            ),
                          ),
                    );

                    if (exactMatches.isEmpty && referencePgs.isEmpty) {
                      return _buildEmptyState();
                    }

                    return ListView(
                      padding: const EdgeInsets.fromLTRB(14, 4, 14, 16),
                      physics: const BouncingScrollPhysics(),
                      children: [
                        if (exactMatches.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 4,
                              bottom: 8,
                              top: 4,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF13B99D),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${exactMatches.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Exact Matches',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF091A2A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          _buildGridFromList(exactMatches),
                          const SizedBox(height: 16),
                        ],
                        if (referencePgs.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 4,
                              bottom: 4,
                              top: 6,
                            ),
                            child: Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.shade700,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: Text(
                                    '${referencePgs.length}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 11,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Reference PGs (Matching Amenities)',
                                  style: TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF091A2A),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(left: 4, bottom: 8),
                            child: Text(
                              'These accommodations fulfill some of your requested amenities',
                              style: TextStyle(
                                fontSize: 11.5,
                                color: Color(0xFF758595),
                              ),
                            ),
                          ),
                          _buildGridFromList(referencePgs),
                        ],
                      ],
                    );
                  }

                  // Default: No filters, show 2-column Grid of all PGs
                  if (baseList.isEmpty) {
                    return _buildEmptyState();
                  }

                  return GridView.builder(
                    padding: const EdgeInsets.fromLTRB(14, 4, 14, 16),
                    physics: const BouncingScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 12,
                          childAspectRatio: 0.65,
                        ),
                    itemCount: baseList.length,
                    itemBuilder: (context, index) {
                      return _buildGridPGCard(baseList[index]);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridFromList(List<PGAccommodation> list) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 12,
        childAspectRatio: 0.65,
      ),
      itemCount: list.length,
      itemBuilder: (context, index) {
        return _buildGridPGCard(list[index]);
      },
    );
  }

  Widget _buildGridPGCard(PGAccommodation pg) {
    return ValueListenableBuilder<List<String>>(
      valueListenable: _dataService.savedPgIdsNotifier,
      builder: (context, savedIds, child) {
        final isFavorited = savedIds.contains(pg.id);

        return GestureDetector(
          onTap: () => _showPGDetailsDialog(pg),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
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
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                      child: Image.network(
                        pg.imageUrl,
                        height: 105,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          height: 105,
                          color: const Color(0xFFEBFDFB),
                          child: const Center(
                            child: Icon(
                              Icons.home_work_rounded,
                              color: Color(0xFF13B99D),
                              size: 36,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6,
                      right: 6,
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

                // Content
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                pg.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.bold,
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
                                const SizedBox(width: 1),
                                Text(
                                  pg.rating.toString(),
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF758595),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
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
                              ),
                            ),
                            const Spacer(),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  size: 10,
                                  color: Color(0xFF758595),
                                ),
                                const SizedBox(width: 1),
                                Text(
                                  pg.location.split(',').first,
                                  style: const TextStyle(
                                    fontSize: 9,
                                    color: Color(0xFF758595),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        // Amenities Row
                        Row(
                          children: [
                            if (pg.hasWifi)
                              Container(
                                margin: const EdgeInsets.only(right: 3),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1.5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEBFDFB),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Wifi',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Color(0xFF13B99D),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (pg.hasAC)
                              Container(
                                margin: const EdgeInsets.only(right: 3),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1.5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFF0F5),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'AC',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.pink,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (pg.hasFood)
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 1.5,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0FDF4),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: const Text(
                                  'Food',
                                  style: TextStyle(
                                    fontSize: 8,
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const Spacer(),
                        SizedBox(
                          width: double.infinity,
                          height: 26,
                          child: ElevatedButton(
                            onPressed: () => _showPGDetailsDialog(pg),
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
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
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
          ),
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Color(0xFFF1FBFA),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.home_work_outlined,
              size: 50,
              color: Color(0xFF13B99D),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'No PGs Found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF091A2A),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Try changing search query or reset filters',
            style: TextStyle(fontSize: 13, color: Color(0xFF758595)),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _searchController.clear();
                _searchQuery = '';
                _filterCriteria = const PGFilterCriteria();
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF13B99D),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text('Reset All'),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: const Color(0xFFEBFDFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF13B99D).withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF13B99D),
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 14,
              color: Color(0xFF13B99D),
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
        margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
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
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              child: Icon(
                icon,
                color: isSelected
                    ? const Color(0xFF13B99D)
                    : const Color(0xFF091A2A),
                size: 20,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              title,
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

  Widget _buildPGCard(
    PGAccommodation pg,
    double screenWidth, {
    bool? isExactMatch,
  }) {
    final int matchedFacilities = pg.matchingFacilitiesCount(
      _filterCriteria.facilities,
    );
    final int totalRequestedFacilities = _filterCriteria.facilities.length;

    return ValueListenableBuilder<List<String>>(
      valueListenable: _dataService.savedPgIdsNotifier,
      builder: (context, savedIds, child) {
        final isFavorited = savedIds.contains(pg.id);

        return GestureDetector(
          onTap: () => _showPGDetailsDialog(pg),
          child: Container(
            width: 195,
            margin: const EdgeInsets.symmetric(horizontal: 7, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: isExactMatch == true
                  ? Border.all(color: const Color(0xFF13B99D), width: 1.5)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Image Section
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(18),
                        topRight: Radius.circular(18),
                      ),
                      child: Image.network(
                        pg.imageUrl,
                        height: 102,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 102,
                            color: const Color(0xFFEBFDFB),
                            child: const Center(
                              child: Icon(
                                Icons.home_work_rounded,
                                color: Color(0xFF13B99D),
                                size: 36,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    // Top Left Match Badge if user requested facilities
                    if (totalRequestedFacilities > 0)
                      Positioned(
                        top: 7,
                        left: 7,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2.5,
                          ),
                          decoration: BoxDecoration(
                            color: isExactMatch == true
                                ? const Color(0xFF13B99D)
                                : Colors.black87,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            isExactMatch == true
                                ? '100% Match'
                                : '$matchedFacilities/$totalRequestedFacilities Facilities',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                    // Favorite Button Overlay
                    Positioned(
                      top: 7,
                      right: 7,
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
                            isFavorited
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            color: isFavorited
                                ? Colors.red
                                : const Color(0xFF758595),
                            size: 15,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                // Info Section
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 8, 10, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
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
                                fontSize: 13,
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
                              const SizedBox(width: 1),
                              Text(
                                pg.rating.toString(),
                                style: const TextStyle(
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF091A2A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 2),

                      // Price Row & Location
                      Row(
                        children: [
                          Text(
                            '₹${pg.price.toInt()}',
                            style: const TextStyle(
                              fontSize: 13.5,
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
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: Color(0xFF758595),
                                size: 11,
                              ),
                              const SizedBox(width: 1),
                              Text(
                                pg.location.split(',').first,
                                style: const TextStyle(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF758595),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 4),

                      // Amenities row with pastel colors matching design
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        physics: const BouncingScrollPhysics(),
                        child: Row(
                          children: pg.facilities.take(3).map((facility) {
                            final bool isFiltered = _filterCriteria.facilities
                                .contains(facility);
                            Color bgColor;
                            Color textColor;

                            if (isFiltered) {
                              bgColor = const Color(0xFF13B99D);
                              textColor = Colors.white;
                            } else {
                              switch (facility.toLowerCase()) {
                                case 'wifi':
                                  bgColor = const Color(0xFFEBFDFB);
                                  textColor = const Color(0xFF13B99D);
                                  break;
                                case 'ac':
                                  bgColor = const Color(0xFFFFF0F5);
                                  textColor = const Color(0xFFE91E63);
                                  break;
                                case 'food':
                                  bgColor = const Color(0xFFF0FDF4);
                                  textColor = const Color(0xFF4CAF50);
                                  break;
                                case 'parking':
                                  bgColor = const Color(0xFFF3F4F6);
                                  textColor = const Color(0xFF6B7280);
                                  break;
                                case 'laundry':
                                  bgColor = const Color(0xFFEFF6FF);
                                  textColor = const Color(0xFF3B82F6);
                                  break;
                                default:
                                  bgColor = const Color(0xFFF8FAFC);
                                  textColor = const Color(0xFF64748B);
                              }
                            }

                            return Container(
                              margin: const EdgeInsets.only(right: 4),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 5,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: bgColor,
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                facility,
                                style: TextStyle(
                                  fontSize: 8.5,
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),

                      const SizedBox(height: 7),

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
              ],
            ),
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
        title: const Text(
          'Saved PGs',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Color(0xFF091A2A),
          ),
        ),
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
              final savedPgs = pgs
                  .where((pg) => savedIds.contains(pg.id))
                  .toList();

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
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF091A2A),
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Tap the heart icon on PGs to save them here.',
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF758595),
                        ),
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
                          errorBuilder: (context, error, stackTrace) =>
                              Container(
                                width: 80,
                                height: 80,
                                color: const Color(0xFFEBFDFB),
                                child: const Icon(
                                  Icons.home_work_rounded,
                                  color: Color(0xFF13B99D),
                                ),
                              ),
                        ),
                      ),
                      title: Text(
                        pg.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF091A2A),
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                size: 14,
                                color: Color(0xFF758595),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                pg.location,
                                style: const TextStyle(fontSize: 12),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.star_rounded,
                                size: 14,
                                color: Colors.amber,
                              ),
                              const SizedBox(width: 2),
                              Text(
                                pg.rating.toString(),
                                style: const TextStyle(fontSize: 12),
                              ),
                            ],
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '₹${pg.price.toInt()}/month',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF13B99D),
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon: const Icon(
                          Icons.favorite_rounded,
                          color: Colors.red,
                        ),
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
// 3. BOOKING TAB (PAST BOOKINGS & MANAGEMENT)
// ==========================================
class BookingTab extends StatelessWidget {
  const BookingTab({super.key});

  void _showBookingDetailsDialog(BuildContext context, PGBooking booking) {
    final pg = booking.pg;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFEBFDFB),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.bookmark_outline_rounded,
                color: Color(0xFF13B99D),
              ),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Booking Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  pg.imageUrl,
                  height: 130,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    height: 130,
                    color: const Color(0xFFEBFDFB),
                    child: const Center(
                      child: Icon(
                        Icons.home_work_rounded,
                        color: Color(0xFF13B99D),
                        size: 40,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                pg.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF091A2A),
                ),
              ),
              const SizedBox(height: 4),
              Row(
                children: [
                  const Icon(
                    Icons.location_on_outlined,
                    size: 14,
                    color: Color(0xFF758595),
                  ),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(
                      '${pg.location}, ${pg.city}',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF758595),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(),
              const SizedBox(height: 8),
              _buildDetailRow(
                'Booking ID',
                '#BK-${booking.id.substring(0, booking.id.length > 6 ? 6 : booking.id.length)}',
              ),
              _buildDetailRow('Duration', booking.dateRangeFormatted),
              _buildDetailRow('Room Sharing', booking.roomType),
              _buildDetailRow('Status', booking.status),
              _buildDetailRow('Monthly Rent', '₹${pg.price.toInt()} / mo'),
              _buildDetailRow(
                'Total Paid',
                '₹${booking.totalPaid.toInt()}',
                isTotal: true,
              ),
              const SizedBox(height: 10),
              const Text(
                'Included Amenities',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF758595),
                ),
              ),
              const SizedBox(height: 6),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: pg.facilities
                    .map(
                      (f) => Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1FBFA),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(
                            color: const Color(
                              0xFF13B99D,
                            ).withValues(alpha: 0.2),
                          ),
                        ),
                        child: Text(
                          f,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF13B99D),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(
                color: Color(0xFF758595),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Connecting to ${pg.name} owner...'),
                  backgroundColor: const Color(0xFF13B99D),
                ),
              );
            },
            icon: const Icon(Icons.phone, size: 16),
            label: const Text('Call Owner'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF13B99D),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              color: isTotal
                  ? const Color(0xFF091A2A)
                  : const Color(0xFF758595),
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 14.5 : 12.5,
              color: isTotal
                  ? const Color(0xFF13B99D)
                  : const Color(0xFF091A2A),
              fontWeight: isTotal ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showBookAgainDialog(BuildContext context, PGAccommodation pg) {
    String selectedRoom = 'Double Sharing';
    DateTime selectedDate = DateTime.now().add(const Duration(days: 2));

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Book Again: ${pg.name}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF091A2A),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Monthly Rate: ₹${pg.price.toInt()} / month',
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFF13B99D),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Select Sharing Type',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF758595),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children:
                      [
                        'Single Sharing',
                        'Double Sharing',
                        'Triple Sharing',
                      ].map((type) {
                        final isSelected = selectedRoom == type;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8.0),
                          child: ChoiceChip(
                            label: Text(type.replaceAll(' Sharing', '')),
                            selected: isSelected,
                            selectedColor: const Color(0xFF13B99D),
                            labelStyle: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF091A2A),
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            onSelected: (val) {
                              if (val) setSheetState(() => selectedRoom = type);
                            },
                          ),
                        );
                      }).toList(),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Check-in Date',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF758595),
                  ),
                ),
                const SizedBox(height: 8),
                InkWell(
                  onTap: () async {
                    final picked = await showDatePicker(
                      context: context,
                      initialDate: selectedDate,
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (picked != null) {
                      setSheetState(() => selectedDate = picked);
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const Icon(
                          Icons.calendar_month_rounded,
                          color: Color(0xFF13B99D),
                          size: 20,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 46,
                  child: ElevatedButton(
                    onPressed: () {
                      DataService().bookPG(
                        pg,
                        selectedDate,
                        selectedRoom,
                        totalPaid: pg.price * 2,
                        dateRange:
                            '${selectedDate.day}/${selectedDate.month}/${selectedDate.year} - ${selectedDate.day}/${(selectedDate.month + 2) % 12}/${selectedDate.year}',
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Booking submitted successfully!'),
                          backgroundColor: Color(0xFF13B99D),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF13B99D),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Confirm Re-Booking',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _showWriteReviewDialog(
    BuildContext context,
    PGAccommodation pg, {
    PGBooking? booking,
  }) {
    int rating = 5;
    final commentController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) {
          return Dialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            insetPadding: const EdgeInsets.symmetric(
              horizontal: 24,
              vertical: 24,
            ),
            child: Padding(
              padding: const EdgeInsets.all(22),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Title and Close Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Write a Review',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F3B3E),
                          letterSpacing: -0.3,
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Color(0xFF334155),
                          size: 22,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Overall Rating Section
                  const Text(
                    'Overall Rating',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: List.generate(5, (index) {
                      final bool isFilled = index < rating;
                      return GestureDetector(
                        onTap: () {
                          setDialogState(() => rating = index + 1);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: Icon(
                            isFilled ? Icons.star : Icons.star_border,
                            color: const Color(0xFFD97706),
                            size: 28,
                          ),
                        ),
                      );
                    }),
                  ),
                  const SizedBox(height: 18),

                  // Your Review Section
                  const Text(
                    'Your Review',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: commentController,
                    maxLines: 4,
                    style: const TextStyle(
                      fontSize: 14.5,
                      color: Color(0xFF1E293B),
                    ),
                    decoration: InputDecoration(
                      hintText: 'Share your experience living here...',
                      hintStyle: const TextStyle(
                        fontSize: 14.5,
                        color: Color(0xFF94A3B8),
                        fontWeight: FontWeight.w400,
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(14),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFFCBD5E1),
                          width: 1.2,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFFCBD5E1),
                          width: 1.2,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                          color: Color(0xFF00B074),
                          width: 1.5,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),

                  // Action Buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: const Color(0xFF0F3B3E),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0F3B3E),
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      ElevatedButton(
                        onPressed: () {
                          final text = commentController.text.trim();
                          if (text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Please enter your review comments before submitting.',
                                ),
                                backgroundColor: Color(0xFFFF5252),
                              ),
                            );
                            return;
                          }

                          final review = UserReview(
                            id: DateTime.now().millisecondsSinceEpoch
                                .toString(),
                            bookingId: booking?.id,
                            pgId: pg.id,
                            pgName: pg.name,
                            location: '${pg.location}, ${pg.city}',
                            roomType: booking?.roomType ?? 'Double Sharing',
                            rating: rating.toDouble(),
                            comment: text,
                            createdAt: DateTime.now(),
                          );

                          DataService().addReview(review);
                          Navigator.pop(context);

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                'Thank you! Your review has been submitted.',
                              ),
                              backgroundColor: Color(0xFF00B074),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B074),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Submit Review',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
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
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final bool isCompleted =
        status.toLowerCase() == 'completed' || status == 'Approved';
    final bool isCancelled = status.toLowerCase() == 'cancelled';

    Color bgColor;
    Color textColor;
    Color borderColor;

    if (isCancelled) {
      bgColor = const Color(0xFFFFECEC);
      textColor = const Color(0xFFFF4D4F);
      borderColor = const Color(0xFFFF8B8B);
    } else if (isCompleted) {
      bgColor = const Color(0xFFE4F9EC);
      textColor = const Color(0xFF13B99D);
      borderColor = const Color(0xFF5ED5A8);
    } else {
      bgColor = const Color(0xFFFFF7E6);
      textColor = Colors.orange;
      borderColor = Colors.amber;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3.5),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor.withValues(alpha: 0.6)),
      ),
      child: Text(
        status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: textColor,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final DataService dataService = DataService();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFF7FEFB), Color(0xFFE2FBF1), Color(0xFFC7F8E6)],
            stops: [0.2, 0.6, 1.0],
          ),
        ),
        child: SafeArea(
          child: ValueListenableBuilder<List<PGBooking>>(
            valueListenable: dataService.bookingsNotifier,
            builder: (context, bookings, child) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header Title & Subtitle
                    const Text(
                      'My Bookings',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF091A2A),
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'View and manage your past bookings',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF758595),
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Section Heading
                    const Text(
                      'Your Past Bookings',
                      style: TextStyle(
                        fontSize: 16.5,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF091A2A),
                      ),
                    ),

                    const SizedBox(height: 12),

                    if (bookings.isEmpty)
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 40.0),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.calendar_today_outlined,
                                  size: 48,
                                  color: Color(0xFF13B99D),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'No bookings recorded yet',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF091A2A),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...bookings.map((booking) {
                        final pg = booking.pg;
                        final bool isCancelled =
                            booking.status.toLowerCase() == 'cancelled';

                        // Facilities to display
                        final displayFacilities = pg.facilities
                            .take(4)
                            .toList();
                        final int moreCount = pg.facilities.length > 4
                            ? pg.facilities.length - 4
                            : 0;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Top Row: Image, Middle Info, Right Status & Price
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Left Image Thumbnail
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(14),
                                    child: Image.network(
                                      pg.imageUrl,
                                      width: 82,
                                      height: 82,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) =>
                                              Container(
                                                width: 82,
                                                height: 82,
                                                color: const Color(0xFFEBFDFB),
                                                child: const Icon(
                                                  Icons.home_work_rounded,
                                                  color: Color(0xFF13B99D),
                                                ),
                                              ),
                                    ),
                                  ),

                                  const SizedBox(width: 10),

                                  // Middle Information
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          pg.name,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            fontSize: 14.5,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF091A2A),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.location_on_outlined,
                                              size: 11.5,
                                              color: Color(0xFF758595),
                                            ),
                                            const SizedBox(width: 2),
                                            Expanded(
                                              child: Text(
                                                '${pg.location.split(',').first} , ${pg.city}',
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 10.5,
                                                  color: Color(0xFF758595),
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.calendar_today_outlined,
                                              size: 11,
                                              color: Color(0xFF758595),
                                            ),
                                            const SizedBox(width: 3),
                                            Expanded(
                                              child: Text(
                                                booking.dateRangeFormatted,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                  fontSize: 10.5,
                                                  color: Color(0xFF091A2A),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          '₹ ${pg.price.toInt()} / month',
                                          style: const TextStyle(
                                            fontSize: 11.5,
                                            fontWeight: FontWeight.w800,
                                            color: Color(0xFF091A2A),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  const SizedBox(width: 8),

                                  // Right Column: Badge & Total Paid
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      _buildStatusBadge(booking.status),
                                      const SizedBox(height: 10),
                                      const Text(
                                        'Total Paid',
                                        style: TextStyle(
                                          fontSize: 10,
                                          color: Color(0xFF758595),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                      Text(
                                        '₹${booking.totalPaid.toInt()}',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w900,
                                          color: isCancelled
                                              ? const Color(0xFF13B99D)
                                              : const Color(0xFF13B99D),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 8),

                              // Amenities Chips Row
                              Wrap(
                                spacing: 4,
                                runSpacing: 4,
                                children: [
                                  ...displayFacilities.map(
                                    (f) => Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(
                                          color: const Color(0xFFE2E8F0),
                                        ),
                                      ),
                                      child: Text(
                                        f,
                                        style: const TextStyle(
                                          fontSize: 9.5,
                                          color: Color(0xFF091A2A),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  if (moreCount > 0)
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 5,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFF8FAFC),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        '+$moreCount more',
                                        style: const TextStyle(
                                          fontSize: 9,
                                          color: Color(0xFF758595),
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                ],
                              ),

                              const SizedBox(height: 10),
                              const Divider(
                                height: 1,
                                thickness: 1,
                                color: Color(0xFFF1F5F9),
                              ),
                              const SizedBox(height: 10),

                              // Action Buttons
                              if (isCancelled)
                                SizedBox(
                                  width: double.infinity,
                                  height: 34,
                                  child: OutlinedButton(
                                    onPressed: () => _showBookingDetailsDialog(
                                      context,
                                      booking,
                                    ),
                                    style: OutlinedButton.styleFrom(
                                      side: const BorderSide(
                                        color: Color(0xFF13B99D),
                                        width: 1.5,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      padding: EdgeInsets.zero,
                                    ),
                                    child: const Text(
                                      'View Details',
                                      style: TextStyle(
                                        color: Color(0xFF13B99D),
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                )
                              else
                                Row(
                                  children: [
                                    Expanded(
                                      child: SizedBox(
                                        height: 34,
                                        child: OutlinedButton(
                                          onPressed: () =>
                                              _showBookingDetailsDialog(
                                                context,
                                                booking,
                                              ),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                              color: Color(0xFF13B99D),
                                              width: 1.5,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.zero,
                                          ),
                                          child: const Text(
                                            'View Details',
                                            style: TextStyle(
                                              color: Color(0xFF13B99D),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: SizedBox(
                                        height: 34,
                                        child: ElevatedButton(
                                          onPressed: () => _showBookAgainDialog(
                                            context,
                                            booking.pg,
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF13B99D,
                                            ),
                                            foregroundColor: Colors.white,
                                            elevation: 0,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.zero,
                                          ),
                                          child: const Text(
                                            'Book Again',
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: SizedBox(
                                        height: 34,
                                        child: OutlinedButton(
                                          onPressed: () =>
                                              _showWriteReviewDialog(
                                                context,
                                                booking.pg,
                                                booking: booking,
                                              ),
                                          style: OutlinedButton.styleFrom(
                                            side: const BorderSide(
                                              color: Color(0xFFFF9F43),
                                              width: 1.5,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            padding: EdgeInsets.zero,
                                          ),
                                          child: const Text(
                                            'Review',
                                            style: TextStyle(
                                              color: Color(0xFFFF9F43),
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        );
                      }),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

// ==========================================
// 4. PROFILE TAB
// ==========================================
class ProfileTab extends StatefulWidget {
  final Function(int)? onNavigateTab;

  const ProfileTab({super.key, this.onNavigateTab});

  @override
  State<ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<ProfileTab> {
  String _userName = 'User';
  String _userEmail = 'user@gmail.com';
  String _userPhone = '+91 98765 43210';
  String _userGender = 'Boys';

  void _showEditProfileSheet(BuildContext context) {
    final nameController = TextEditingController(text: _userName);
    final emailController = TextEditingController(text: _userEmail);
    final phoneController = TextEditingController(text: _userPhone);
    String selectedGender = _userGender;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) {
          return Container(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              left: 20,
              right: 20,
              top: 20,
            ),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Edit Profile',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF091A2A),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: 'Full Name',
                      prefixIcon: const Icon(
                        Icons.person_outline,
                        color: Color(0xFF13B99D),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF13B99D),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: 'Email',
                      prefixIcon: const Icon(
                        Icons.email_outlined,
                        color: Color(0xFF13B99D),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF13B99D),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: phoneController,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: const Icon(
                        Icons.phone_outlined,
                        color: Color(0xFF13B99D),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(
                          color: Color(0xFF13B99D),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Gender Preference',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF758595),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: ['Boys', 'Girls'].map((g) {
                      final isSelected = selectedGender == g;
                      return Padding(
                        padding: const EdgeInsets.only(right: 12.0),
                        child: ChoiceChip(
                          label: Text(g),
                          selected: isSelected,
                          selectedColor: const Color(0xFF13B99D),
                          labelStyle: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : const Color(0xFF091A2A),
                            fontWeight: FontWeight.bold,
                          ),
                          onSelected: (val) {
                            if (val) {
                              setSheetState(() => selectedGender = g);
                            }
                          },
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 20),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _userName = nameController.text.trim().isEmpty
                              ? 'User'
                              : nameController.text.trim();
                          _userEmail = emailController.text.trim().isEmpty
                              ? 'user@gmail.com'
                              : emailController.text.trim();
                          _userPhone = phoneController.text.trim();
                          _userGender = selectedGender;
                        });
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Profile updated successfully!'),
                            backgroundColor: Color(0xFF13B99D),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF13B99D),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'Save Changes',
                        style: TextStyle(
                          fontSize: 16,
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
      ),
    );
  }

  void _showReviewsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        child: Padding(
          padding: const EdgeInsets.all(22),
          child: ValueListenableBuilder<List<UserReview>>(
            valueListenable: DataService().userReviewsNotifier,
            builder: (context, userReviews, _) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header: Title, Badge, and Close Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Text(
                            'My Reviews',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F3B3E),
                              letterSpacing: -0.3,
                            ),
                          ),
                          if (userReviews.isNotEmpty) ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 3,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFE6F7F2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                '${userReviews.length} ${userReviews.length == 1 ? 'Review' : 'Reviews'}',
                                style: const TextStyle(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF00B074),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.close,
                          color: Color(0xFF334155),
                          size: 22,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        splashRadius: 20,
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),

                  // Reviews List or Empty State
                  if (userReviews.isEmpty)
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 32,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFFE2E8F0),
                          width: 1.2,
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(14),
                            decoration: const BoxDecoration(
                              color: Color(0xFFE6F7F2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.rate_review_outlined,
                              color: Color(0xFF00B074),
                              size: 32,
                            ),
                          ),
                          const SizedBox(height: 14),
                          const Text(
                            'No Reviews Given Yet',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0F3B3E),
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Reviews you submit for your bookings will appear here.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    )
                  else
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          children: userReviews.map((review) {
                            final int filledStars = review.rating.round();
                            return Container(
                              margin: const EdgeInsets.only(bottom: 12),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: const Color(0xFFE2E8F0),
                                  width: 1.2,
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          review.pgName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 15,
                                            color: Color(0xFF0F3B3E),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8,
                                          vertical: 3,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFFFF7ED),
                                          borderRadius: BorderRadius.circular(
                                            6,
                                          ),
                                          border: Border.all(
                                            color: const Color(0xFFFED7AA),
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            const Icon(
                                              Icons.star_rounded,
                                              color: Color(0xFFD97706),
                                              size: 15,
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              review.rating.toStringAsFixed(1),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 12,
                                                color: Color(0xFF9A3412),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    '${review.location} • ${review.roomType}',
                                    style: const TextStyle(
                                      fontSize: 11.5,
                                      color: Color(0xFF64748B),
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '"${review.comment}"',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xFF334155),
                                      height: 1.4,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Row(
                                        children: List.generate(
                                          5,
                                          (index) => Padding(
                                            padding: const EdgeInsets.only(
                                              right: 2,
                                            ),
                                            child: Icon(
                                              index < filledStars
                                                  ? Icons.star
                                                  : Icons.star_border,
                                              color: const Color(0xFFD97706),
                                              size: 15,
                                            ),
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Text(
                                        review.formattedDate,
                                        style: const TextStyle(
                                          fontSize: 11,
                                          color: Color(0xFF94A3B8),
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                  const SizedBox(height: 20),

                  // Action Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00B074),
                          foregroundColor: Colors.white,
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 22,
                            vertical: 12,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: const Text(
                          'Close',
                          style: TextStyle(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  void _showHelpSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: const [
            Icon(
              Icons.support_agent_rounded,
              color: Color(0xFF13B99D),
              size: 28,
            ),
            SizedBox(width: 8),
            Text(
              'Help & Support',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Need assistance with your PG booking or listing inquiries? Reach out to us:',
              style: TextStyle(fontSize: 13, color: Color(0xFF4A5568)),
            ),
            const SizedBox(height: 16),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.phone, color: Color(0xFF13B99D)),
              title: const Text(
                '+91 98765 43210',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              subtitle: const Text('Mon - Sat (9 AM - 8 PM)'),
            ),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.zero,
              leading: const Icon(
                Icons.email_outlined,
                color: Color(0xFF13B99D),
              ),
              title: const Text(
                'support@pgfinder.com',
                style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
              ),
              subtitle: const Text('24/7 Email Support'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Close',
              style: TextStyle(
                color: Color(0xFF13B99D),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Logout',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF758595)),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Color(0xFFE8FAF3), Color(0xFFB5F4DC)],
            stops: [0.35, 0.75, 1.0],
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            children: [
              // Top Mint Curved Header
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 50,
                  left: 20,
                  right: 20,
                  bottom: 34,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFF88F2CE),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(38),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Back Arrow
                    GestureDetector(
                      onTap: () {
                        if (widget.onNavigateTab != null) {
                          widget.onNavigateTab!(0); // Go to Home
                        } else {
                          Navigator.maybePop(context);
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        color: Colors.transparent,
                        child: const Icon(
                          Icons.arrow_back,
                          color: Color(0xFF091A2A),
                          size: 26,
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Profile Details Row
                    Row(
                      children: [
                        // Avatar matching design
                        Container(
                          width: 86,
                          height: 86,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.6),
                              width: 3,
                            ),
                            image: const DecorationImage(
                              image: NetworkImage(
                                'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=400&q=80',
                              ),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),

                        const SizedBox(width: 18),

                        // Name and Email
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hi , $_userName',
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF091A2A),
                                  letterSpacing: -0.2,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _userEmail,
                                style: TextStyle(
                                  fontSize: 15,
                                  color: const Color(
                                    0xFF758595,
                                  ).withValues(alpha: 0.9),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Menu List Items
              _buildMenuItem(
                icon: Icons.edit_outlined,
                title: 'Edit profile',
                onTap: () => _showEditProfileSheet(context),
              ),
              _buildDivider(),

              _buildMenuItem(
                icon: Icons.calendar_today_outlined,
                title: 'My booking',
                onTap: () {
                  if (widget.onNavigateTab != null) {
                    widget.onNavigateTab!(2); // Go to Booking Tab
                  }
                },
              ),
              _buildDivider(),

              _buildMenuItem(
                icon: Icons.favorite_border_rounded,
                title: 'Favourite',
                onTap: () {
                  if (widget.onNavigateTab != null) {
                    widget.onNavigateTab!(1); // Go to Saved Tab
                  }
                },
              ),
              _buildDivider(),

              _buildMenuItem(
                icon: Icons.star_border_rounded,
                title: 'My Review',
                onTap: () => _showReviewsDialog(context),
              ),
              _buildDivider(),

              _buildMenuItem(
                icon: Icons.help_outline_rounded,
                title: 'Help & Support',
                onTap: () => _showHelpSupportDialog(context),
              ),
              _buildDivider(),

              _buildMenuItem(
                icon: Icons.logout_rounded,
                title: 'Logout',
                isLogout: true,
                onTap: () => _showLogoutDialog(context),
              ),
              _buildDivider(),

              const SizedBox(height: 50),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    bool isLogout = false,
  }) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
        child: Row(
          children: [
            Icon(icon, size: 22, color: const Color(0xFF091A2A)),
            const SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isLogout ? Colors.red : const Color(0xFF091A2A),
                  letterSpacing: -0.2,
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Color(0xFF091A2A),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Divider(
      height: 1,
      thickness: 1,
      color: const Color(0xFFD3E0EA).withValues(alpha: 0.7),
      indent: 20,
      endIndent: 20,
    );
  }
}
