import 'package:flutter/material.dart';
import 'package:pg_findar/resources/theme.dart';
import 'package:pg_findar/widgets/dashboard_background.dart';
import '../../widgets/app_image.dart';
import '../pg_details/pg_detail_screen.dart';
import '../pg_details/pg_list_page.dart';

/// ============================================================================
/// PG ROOM DATA MODEL
/// ============================================================================
class PGRoom {
  final String id;
  final String roomNumber;
  final String floor;
  final String sharingType; // 'Single Sharing', 'Double Sharing', 'Triple Sharing'
  final int totalBeds;
  final int occupiedBeds;
  final double price;
  final List<String> amenities;

  const PGRoom({
    required this.id,
    required this.roomNumber,
    required this.floor,
    required this.sharingType,
    required this.totalBeds,
    this.occupiedBeds = 0,
    required this.price,
    this.amenities = const ['Attached Bath', 'Wi-Fi'],
  });

  int get availableBeds => totalBeds - occupiedBeds;
  bool get isAvailable => availableBeds > 0;
  bool get isFull => occupiedBeds >= totalBeds;
}

/// ============================================================================
/// PG ACCOMMODATION DATA MODEL
/// ============================================================================
class PGAccommodation {
  final String id;
  final String name;
  final String location;
  final String city;
  final double price;
  final double rating;
  final String category; // 'Boys PG', 'Girls PG', 'Hostels', 'Flats' / 'Boys', 'Girls', 'Both'
  final String gender; // 'Boys', 'Girls', 'Both'
  final String imageUrl;
  final bool hasWifi;
  final bool hasAC;
  final bool hasFood;
  final bool hasParking;
  final bool hasLaundry;
  final bool hasTV;
  final bool hasFridge;
  final bool hasGeyser;
  final bool isPopular;
  final bool isNearby;
  final String organizerId;
  String get ownerId => organizerId;
  final List<PGRoom>? rooms;

  List<PGRoom> get roomsList {
    if (rooms != null && rooms!.isNotEmpty) return rooms!;
    return [
      PGRoom(
        id: '${id}_r101',
        roomNumber: 'Room 101',
        floor: '1st Floor',
        sharingType: 'Single Sharing',
        totalBeds: 1,
        occupiedBeds: 0,
        price: price + 2000,
        amenities: const ['Attached Bath', 'AC', 'Balcony'],
      ),
      PGRoom(
        id: '${id}_r102',
        roomNumber: 'Room 102',
        floor: '1st Floor',
        sharingType: 'Double Sharing',
        totalBeds: 2,
        occupiedBeds: 1,
        price: price,
        amenities: const ['Attached Bath', 'Wi-Fi', 'Study Desk'],
      ),
      PGRoom(
        id: '${id}_r201',
        roomNumber: 'Room 201',
        floor: '2nd Floor',
        sharingType: 'Triple Sharing',
        totalBeds: 3,
        occupiedBeds: 1,
        price: price > 2000 ? price - 1500 : price,
        amenities: const ['Spacious Balcony', 'Wardrobe', 'Wi-Fi'],
      ),
      PGRoom(
        id: '${id}_r202',
        roomNumber: 'Room 202',
        floor: '2nd Floor',
        sharingType: 'Double Sharing',
        totalBeds: 2,
        occupiedBeds: 2,
        price: price,
        amenities: const ['Attached Bath', 'AC'],
      ),
    ];
  }

  PGAccommodation({
    required this.id,
    required this.name,
    required this.location,
    required this.city,
    required this.price,
    required this.rating,
    required this.category,
    required this.imageUrl,
    this.gender = 'Both',
    this.hasWifi = false,
    this.hasAC = false,
    this.hasFood = false,
    this.hasParking = false,
    this.hasLaundry = false,
    this.hasTV = false,
    this.hasFridge = false,
    this.hasGeyser = false,
    this.isPopular = false,
    this.isNearby = false,
    this.organizerId = 'organizer13',
    this.rooms,
  });

  /// Returns a list of all active facilities for this PG
  List<String> get facilities {
    final List<String> list = [];
    if (hasWifi) list.add('Wifi');
    if (hasAC) list.add('AC');
    if (hasFood) list.add('Food');
    if (hasParking) list.add('Parking');
    if (hasLaundry) list.add('Laundry');
    if (hasTV) list.add('TV');
    if (hasFridge) list.add('Fridge');
    if (hasGeyser) list.add('Gyser');
    return list;
  }

  /// Checks if this PG has a specific facility
  bool hasFacility(String facility) {
    switch (facility.toLowerCase()) {
      case 'wifi':
        return hasWifi;
      case 'ac':
        return hasAC;
      case 'food':
        return hasFood;
      case 'parking':
        return hasParking;
      case 'laundry':
        return hasLaundry;
      case 'tv':
        return hasTV;
      case 'fridge':
        return hasFridge;
      case 'gyser':
      case 'geyser':
        return hasGeyser;
      default:
        return false;
    }
  }

  /// Count how many of the selected facilities this PG fulfills
  int matchingFacilitiesCount(List<String> selectedFacilities) {
    if (selectedFacilities.isEmpty) return 0;
    int count = 0;
    for (final facility in selectedFacilities) {
      if (hasFacility(facility)) {
        count++;
      }
    }
    return count;
  }
}

/// ============================================================================
/// HOME SCREEN (EXPLORE & BOOK PGS)
/// ============================================================================
/// Displays city selector, search filter, categories, popular PGs,
/// nearby PGs, and booking bottom sheet.
/// ============================================================================

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  // Static dummy/mock data for clean, static UI presentation
  static final List<PGAccommodation> samplePGs = [
    PGAccommodation(
      id: '1',
      name: 'Green Valley PG',
      location: 'Kalawad Road, Rajkot',
      city: 'Rajkot',
      price: 6500,
      rating: 4.8,
      category: 'Boys PG',
      gender: 'Boys',
      imageUrl: 'assets/images/GreenVally.png',
      hasWifi: true,
      hasAC: true,
      hasFood: true,
      hasParking: true,
      hasLaundry: true,
      hasTV: true,
      hasFridge: true,
      hasGeyser: true,
      isPopular: true,
      isNearby: false,
    ),
    PGAccommodation(
      id: '2',
      name: 'Sunshine Residency',
      location: '150 Feet Ring Road, Rajkot',
      city: 'Rajkot',
      price: 7500,
      rating: 4.9,
      category: 'Girls PG',
      gender: 'Girls',
      imageUrl: 'assets/images/Sunshine.png',
      hasWifi: true,
      hasAC: true,
      hasFood: true,
      hasParking: false,
      hasLaundry: true,
      hasTV: true,
      hasFridge: true,
      hasGeyser: true,
      isPopular: true,
      isNearby: false,
    ),
    PGAccommodation(
      id: '3',
      name: 'Comfort Stay PG',
      location: 'University Road, Rajkot',
      city: 'Rajkot',
      price: 5500,
      rating: 4.5,
      category: 'Hostels',
      gender: 'Both',
      imageUrl: 'assets/images/Comfert.png',
      hasWifi: true,
      hasAC: false,
      hasFood: true,
      hasParking: true,
      hasLaundry: true,
      hasTV: true,
      hasFridge: true,
      hasGeyser: true,
      isPopular: true,
      isNearby: true,
    ),
    PGAccommodation(
      id: '4',
      name: 'Royal PG',
      location: 'Rajkot , Gujarat',
      city: 'Rajkot',
      price: 6500,
      rating: 4.7,
      category: 'Boys PG',
      gender: 'Boys',
      imageUrl: 'assets/images/royal.png',
      hasWifi: true,
      hasAC: true,
      hasFood: true,
      hasParking: true,
      hasLaundry: false,
      hasTV: false,
      hasFridge: false,
      hasGeyser: true,
      isPopular: false,
      isNearby: true,
    ),
    PGAccommodation(
      id: '5',
      name: 'Shanti Girls PG',
      location: 'Astron Chowk, Rajkot',
      city: 'Rajkot',
      price: 7000,
      rating: 4.6,
      category: 'Girls PG',
      gender: 'Girls',
      imageUrl: 'assets/images/Shanti.png',
      hasWifi: true,
      hasAC: false,
      hasFood: true,
      hasParking: false,
      hasLaundry: true,
      hasTV: true,
      hasFridge: true,
      hasGeyser: true,
      isPopular: false,
      isNearby: true,
    ),
    PGAccommodation(
      id: '6',
      name: 'Metro Heights Luxury Flat',
      location: 'Mavdi, Rajkot',
      city: 'Rajkot',
      price: 8500,
      rating: 4.5,
      category: 'Flats',
      gender: 'Both',
      imageUrl: 'assets/images/metro.png',
      hasWifi: true,
      hasAC: true,
      hasFood: false,
      hasParking: true,
      hasLaundry: true,
      hasTV: true,
      hasFridge: true,
      hasGeyser: true,
      isPopular: false,
      isNearby: false,
    ),
  ];

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();

  String _selectedCity = 'Rajkot';
  final String _searchQuery = '';

  // Stores favorited PG IDs (beginner-friendly frontend state)
  final Set<String> _favoritePgIds = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
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
                            const Text(
                              'Hello, User',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w800,
                                color: Color(0xFF091A2A),
                              ),
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
                Builder(
                  builder: (context) {
                    final pgs = HomeScreen.samplePGs;
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
                Builder(
                  builder: (context) {
                    final pgs = HomeScreen.samplePGs;
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
