library;

/// ============================================================================
/// PG ACCOMMODATION DATA MODEL
/// ============================================================================
/// Represents a single PG accommodation listing with all properties.
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

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'city': city,
      'price': price,
      'rating': rating,
      'category': category,
      'gender': gender,
      'imageUrl': imageUrl,
      'hasWifi': hasWifi,
      'hasAC': hasAC,
      'hasFood': hasFood,
      'hasParking': hasParking,
      'hasLaundry': hasLaundry,
      'hasTV': hasTV,
      'hasFridge': hasFridge,
      'hasGeyser': hasGeyser,
      'isPopular': isPopular,
      'isNearby': isNearby,
    };
  }

  factory PGAccommodation.fromMap(Map<String, dynamic> map) {
    return PGAccommodation(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      location: map['location'] ?? '',
      city: map['city'] ?? '',
      price: (map['price'] as num?)?.toDouble() ?? 0.0,
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      category: map['category'] ?? 'Both',
      gender: map['gender'] ?? 'Both',
      imageUrl: map['imageUrl'] ?? '',
      hasWifi: map['hasWifi'] ?? false,
      hasAC: map['hasAC'] ?? false,
      hasFood: map['hasFood'] ?? false,
      hasParking: map['hasParking'] ?? false,
      hasLaundry: map['hasLaundry'] ?? false,
      hasTV: map['hasTV'] ?? false,
      hasFridge: map['hasFridge'] ?? false,
      hasGeyser: map['hasGeyser'] ?? false,
      isPopular: map['isPopular'] ?? false,
      isNearby: map['isNearby'] ?? false,
    );
  }

  PGAccommodation copyWith({
    String? id,
    String? name,
    String? location,
    String? city,
    double? price,
    double? rating,
    String? category,
    String? gender,
    String? imageUrl,
    bool? hasWifi,
    bool? hasAC,
    bool? hasFood,
    bool? hasParking,
    bool? hasLaundry,
    bool? hasTV,
    bool? hasFridge,
    bool? hasGeyser,
    bool? isPopular,
    bool? isNearby,
    String? organizerId,
    List<PGRoom>? rooms,
  }) {
    return PGAccommodation(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      city: city ?? this.city,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      category: category ?? this.category,
      gender: gender ?? this.gender,
      imageUrl: imageUrl ?? this.imageUrl,
      hasWifi: hasWifi ?? this.hasWifi,
      hasAC: hasAC ?? this.hasAC,
      hasFood: hasFood ?? this.hasFood,
      hasParking: hasParking ?? this.hasParking,
      hasLaundry: hasLaundry ?? this.hasLaundry,
      hasTV: hasTV ?? this.hasTV,
      hasFridge: hasFridge ?? this.hasFridge,
      hasGeyser: hasGeyser ?? this.hasGeyser,
      isPopular: isPopular ?? this.isPopular,
      isNearby: isNearby ?? this.isNearby,
      organizerId: organizerId ?? this.organizerId,
      rooms: rooms ?? this.rooms,
    );
  }
}

class PGFilterCriteria {
  final double minPrice;
  final double maxPrice;
  final String gender; // 'Boys', 'Girls', 'Both'
  final List<String> facilities; // ['Wifi', 'AC', 'Food', 'Parking', 'Laundry', 'TV', 'Fridge', 'Gyser']

  const PGFilterCriteria({
    this.minPrice = 3000,
    this.maxPrice = 10000,
    this.gender = 'Both',
    this.facilities = const [],
  });

  bool get isDefault =>
      minPrice == 3000 &&
      maxPrice == 10000 &&
      gender == 'Both' &&
      facilities.isEmpty;

  bool get hasActiveFilters => !isDefault;

  int get activeFiltersCount {
    int count = 0;
    if (minPrice > 3000 || maxPrice < 10000) count++;
    if (gender != 'Both') count++;
    count += facilities.length;
    return count;
  }

  PGFilterCriteria copyWith({
    double? minPrice,
    double? maxPrice,
    String? gender,
    List<String>? facilities,
  }) {
    return PGFilterCriteria(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      gender: gender ?? this.gender,
      facilities: facilities ?? this.facilities,
    );
  }
}

/// ============================================================================
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

  PGRoom copyWith({
    String? id,
    String? roomNumber,
    String? floor,
    String? sharingType,
    int? totalBeds,
    int? occupiedBeds,
    double? price,
    List<String>? amenities,
  }) {
    return PGRoom(
      id: id ?? this.id,
      roomNumber: roomNumber ?? this.roomNumber,
      floor: floor ?? this.floor,
      sharingType: sharingType ?? this.sharingType,
      totalBeds: totalBeds ?? this.totalBeds,
      occupiedBeds: occupiedBeds ?? this.occupiedBeds,
      price: price ?? this.price,
      amenities: amenities ?? this.amenities,
    );
  }
}

/// ============================================================================
/// PG BOOKING DATA MODEL
/// ============================================================================
/// Represents a booking created by the user for a PG property.
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
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
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

  PGBooking copyWith({
    String? status,
    double? totalPaid,
    String? userName,
    String? userPhone,
    String? roomNumber,
    String? floor,
    String? roomType,
  }) {
    return PGBooking(
      id: id,
      pg: pg,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      status: status ?? this.status,
      roomType: roomType ?? this.roomType,
      totalPaid: totalPaid ?? this.totalPaid,
      customDateRange: customDateRange,
      userName: userName ?? this.userName,
      userPhone: userPhone ?? this.userPhone,
      roomNumber: roomNumber ?? this.roomNumber,
      floor: floor ?? this.floor,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pg': pg.toMap(),
      'checkInDate': checkInDate.toIso8601String(),
      'status': status,
      'roomType': roomType,
    };
  }

  factory PGBooking.fromMap(Map<String, dynamic> map) {
    return PGBooking(
      id: map['id'] ?? '',
      pg: PGAccommodation.fromMap(map['pg'] ?? {}),
      checkInDate:
          DateTime.tryParse(map['checkInDate'] ?? '') ?? DateTime.now(),
      status: map['status'] ?? 'Pending',
      roomType: map['roomType'] ?? 'Double Sharing',
    );
  }
}

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
