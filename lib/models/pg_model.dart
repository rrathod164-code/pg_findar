class PGAccommodation {
  final String id;
  final String name;
  final String location; // Detailed location, e.g., "Rajkot" or "Prahlad Nagar"
  final String city;     // E.g., "Rajkot" or "Ahmedabad"
  final double price;    // Price per month
  final double rating;
  final String category; // 'Boys PG', 'Girls PG', 'Hostels', 'Flats'
  final String gender;   // 'Boys', 'Girls', 'Both'
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

class PGBooking {
  final String id;
  final PGAccommodation pg;
  final DateTime checkInDate;
  final DateTime? checkOutDate;
  final String status; // 'completed', 'Cancelled', 'Pending', 'Approved'
  final String roomType; // 'Single Sharing', 'Double Sharing', 'Triple Sharing'
  final double totalPaid;
  final String? customDateRange;

  PGBooking({
    required this.id,
    required this.pg,
    required this.checkInDate,
    this.checkOutDate,
    required this.status,
    this.roomType = 'Double Sharing',
    this.totalPaid = 0,
    this.customDateRange,
  });

  String get dateRangeFormatted {
    if (customDateRange != null && customDateRange!.isNotEmpty) {
      return customDateRange!;
    }
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    final inStr = '${checkInDate.day} ${months[checkInDate.month - 1]} ${checkInDate.year}';
    if (checkOutDate != null) {
      final outStr = '${checkOutDate!.day} ${months[checkOutDate!.month - 1]} ${checkOutDate!.year}';
      return '$inStr - $outStr';
    }
    return inStr;
  }

  PGBooking copyWith({
    String? status,
    double? totalPaid,
  }) {
    return PGBooking(
      id: id,
      pg: pg,
      checkInDate: checkInDate,
      checkOutDate: checkOutDate,
      status: status ?? this.status,
      roomType: roomType,
      totalPaid: totalPaid ?? this.totalPaid,
      customDateRange: customDateRange,
    );
  }
}
