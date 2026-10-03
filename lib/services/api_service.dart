/// ============================================================================
/// PG ROOM DATA MODEL
/// ============================================================================
class PGRoom {
  final String id;
  final String roomNumber;
  final String floor;
  final String
  sharingType; // 'Single Sharing', 'Double Sharing', 'Triple Sharing'
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
  final String
  category; // 'Boys PG', 'Girls PG', 'Hostels', 'Flats' / 'Boys', 'Girls', 'Both'
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
/// PG BOOKING DATA MODEL
/// ============================================================================
class PGBooking {
  final String id;
  final PGAccommodation pg;
  final DateTime checkInDate;
  final DateTime? checkOutDate;
  final String status; // 'completed', 'Cancelled', 'Pending', 'Approved'
  final String roomType; // 'Single Sharing', 'Double Sharing', 'Triple Sharing'
  final double totalPaid;
  final String? customDateRange;
  final String userName;
  final String userPhone;
  final String roomNumber;
  final String floor;

  PGBooking({
    required this.id,
    required this.pg,
    required this.checkInDate,
    this.checkOutDate,
    required this.status,
    this.roomType = 'Double Sharing',
    this.totalPaid = 0,
    this.customDateRange,
    this.userName = 'Guest Tenant',
    this.userPhone = '+91 98765 43210',
    this.roomNumber = 'Room 102',
    this.floor = '1st Floor',
  });

  String get dateRangeFormatted {
    if (customDateRange != null && customDateRange!.isNotEmpty) {
      return customDateRange!;
    }
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final inStr =
        '${checkInDate.day} ${months[checkInDate.month - 1]} ${checkInDate.year}';
    if (checkOutDate != null) {
      final outStr =
          '${checkOutDate!.day} ${months[checkOutDate!.month - 1]} ${checkOutDate!.year}';
      return '$inStr - $outStr';
    }
    return inStr;
  }
}

/// ============================================================================
/// USER REVIEW DATA MODEL
/// ============================================================================
class UserReview {
  final String id;
  final String? bookingId;
  final String pgId;
  final String pgName;
  final String location;
  final String roomType;
  final double rating;
  final String comment;
  final DateTime createdAt;

  UserReview({
    required this.id,
    this.bookingId,
    required this.pgId,
    required this.pgName,
    required this.location,
    this.roomType = 'Double Sharing',
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  String get formattedDate {
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${createdAt.day.toString().padLeft(2, '0')} ${months[createdAt.month - 1]} ${createdAt.year}';
  }
}

/// ============================================================================
/// SAMPLE UI PRESENTATION DATA & STATE
/// ============================================================================
/// Provides sample mock data for UI presentation and interactive demo.
/// 100% Pure Flutter Frontend UI — No backend or local storage required.
/// ============================================================================

class ApiService {
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

  static final List<PGBooking> sampleBookings = [
    PGBooking(
      id: 'b1',
      pg: samplePGs[0],
      checkInDate: DateTime(2025, 5, 10),
      checkOutDate: DateTime(2025, 6, 10),
      status: 'completed',
      roomType: 'Double Sharing',
      totalPaid: 13000,
      customDateRange: '10 May 2025 - 10 Jun 2025',
    ),
    PGBooking(
      id: 'b2',
      pg: samplePGs[3], // Royal PG
      checkInDate: DateTime(2025, 3, 5),
      checkOutDate: DateTime(2025, 5, 5),
      status: 'Cancelled',
      roomType: 'Single Sharing',
      totalPaid: 0,
      customDateRange: '5 Mar 2025 - 5 May 2025',
    ),
    PGBooking(
      id: 'b3',
      pg: samplePGs[0],
      checkInDate: DateTime(2024, 12, 1),
      checkOutDate: DateTime(2025, 3, 1),
      status: 'completed',
      roomType: 'Double Sharing',
      totalPaid: 19500,
      customDateRange: '1 Dec 2024 - 1 Mar 2025',
    ),
  ];

  static final List<UserReview> sampleReviews = [
    UserReview(
      id: 'rev_1',
      pgId: '1',
      pgName: 'Green Valley PG',
      location: 'Kalawad Road, Rajkot',
      roomType: 'Double Sharing',
      rating: 5.0,
      comment:
          'The rooms are extremely clean and spacious. The high-speed Wi-Fi was amazing for my remote work, and hot delicious food is served on time daily!',
      createdAt: DateTime(2025, 5, 12),
    ),
    UserReview(
      id: 'rev_2',
      pgId: '3',
      pgName: 'Royal PG',
      location: 'University Road, Rajkot',
      roomType: 'Triple Sharing',
      rating: 4.0,
      comment:
          'Overall a great stay. The air conditioning works perfectly, though laundry service was occasionally delayed. Prime location close to transit hubs.',
      createdAt: DateTime(2025, 3, 28),
    ),
  ];
}
