import 'package:flutter/material.dart';
import 'package:pg_findar/resources/theme.dart';
import 'package:pg_findar/widgets/dashboard_background.dart';
import '../../widgets/pg_card.dart';
import '../pg_details/pg_list_page.dart';

class PGRoom {
  final String id;
  final String roomNumber;
  final String floor;
  final String sharingType;
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

class PGAccommodation {
  final String id;
  final String name;
  final String location;
  final String city;
  final double price;
  final double rating;
  final String category;
  final String gender;
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

  List<String> get facilities {
    final List<String> list = [];
    if (hasWifi) list.add('Wifi');
    if (hasAC) list.add('AC');
    if (hasFood) list.add('Food');
    if (hasParking) list.add('Parking');
    if (hasLaundry) list.add('Laundry');
    if (hasTV) list.add('TV');
    if (hasFridge) list.add('Fridge');
    if (hasGeyser) list.add('Geyser');
    return list;
  }

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
      case 'geyser':
      case 'gyser':
        return hasGeyser;
      default:
        return false;
    }
  }

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

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

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
      imageUrl: AppPlaceholders.defaultPgImage,
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

  static final List<PGAccommodation> popularPGs = samplePGs
      .where((pg) => pg.isPopular || pg.rating >= 4.5)
      .toList();

  static final List<PGAccommodation> nearbyPGs = samplePGs
      .where((pg) => pg.isNearby || !pg.isPopular)
      .toList();

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<String> _favoritePgIds = {};

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    const double horizontalPadding = 16.0;

    void openCategory(String category) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PGListPage(
            title: category,
            listType: PGListType.category,
            categoryFilter: category,
            selectedCity: 'Rajkot',
          ),
        ),
      );
    }

    Widget buildCategoryItem({
      required String title,
      required IconData icon,
      required Color color,
      VoidCallback? onTap,
    }) {
      return GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF091A2A).withValues(alpha: 0.07),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
              BoxShadow(
                color: const Color(0xFF091A2A).withValues(alpha: 0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
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
        ),
      );
    }

    Widget buildPGCard(PGAccommodation pg) {
      return PGCard(
        pg: pg,
        isFavorited: _favoritePgIds.contains(pg.id),
        onFavoriteToggle: () {
          setState(() {
            if (_favoritePgIds.contains(pg.id)) {
              _favoritePgIds.remove(pg.id);
            } else {
              _favoritePgIds.add(pg.id);
            }
          });
        },
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: DashboardBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                    left: horizontalPadding,
                    right: horizontalPadding,
                    top: screenHeight * 0.02,
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, User',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
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

                      Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Color(0xFFE53935),
                            size: 18,
                          ),
                          SizedBox(width: 4),
                          Text(
                            'Rajkot, Gujarat',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF091A2A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

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
                      readOnly: true,
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const PGListPage(
                              title: 'Search PGs',
                              listType: PGListType.all,
                              selectedCity: 'Rajkot',
                              autoFocusSearch: true,
                            ),
                          ),
                        );
                      },
                      decoration: const InputDecoration(
                        hintText: AppPlaceholders.searchHint,
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
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        filled: false,
                        contentPadding: EdgeInsets.symmetric(
                          vertical: 14,
                          horizontal: 16,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 95),

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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const PGListPage(
                                title: 'All PGs',
                                listType: PGListType.all,
                                selectedCity: 'Rajkot',
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
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: buildCategoryItem(
                          title: 'Boys PG',
                          icon: Icons.person_rounded,
                          color: AppColors.primaryLight,
                          onTap: () => openCategory('Boys PG'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: buildCategoryItem(
                          title: 'Girls PG',
                          icon: Icons.person_3_rounded,
                          color: const Color(0xFFFFF0F5),
                          onTap: () => openCategory('Girls PG'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: buildCategoryItem(
                          title: 'Hostels',
                          icon: Icons.domain_rounded,
                          color: const Color(0xFFF0FDF4),
                          onTap: () => openCategory('Hostels'),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: buildCategoryItem(
                          title: 'Flats',
                          icon: Icons.apartment_rounded,
                          color: const Color(0xFFFFF8EE),
                          onTap: () => openCategory('Flats'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 18),

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
                              builder: (context) => const PGListPage(
                                title: 'Popular PGs',
                                listType: PGListType.popular,
                                selectedCity: 'Rajkot',
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

                SizedBox(
                  height: 242,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: horizontalPadding - 8,
                      right: horizontalPadding - 8,
                    ),
                    itemCount: HomeScreen.popularPGs.length,
                    itemBuilder: (context, index) {
                      final pg = HomeScreen.popularPGs[index];
                      return buildPGCard(pg);
                    },
                  ),
                ),

                const SizedBox(height: 18),

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
                              builder: (context) => const PGListPage(
                                title: 'Nearby PGs',
                                listType: PGListType.nearby,
                                selectedCity: 'Rajkot',
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

                SizedBox(
                  height: 242,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.only(
                      left: horizontalPadding - 8,
                      right: horizontalPadding - 8,
                    ),
                    itemCount: HomeScreen.nearbyPGs.length,
                    itemBuilder: (context, index) {
                      final pg = HomeScreen.nearbyPGs[index];
                      return buildPGCard(pg);
                    },
                  ),
                ),

                const SizedBox(height: 95),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
