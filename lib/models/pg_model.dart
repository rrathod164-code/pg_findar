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
  final String category; // 'Boys', 'Girls', 'Both'
  final String imageUrl;
  final bool hasWifi;
  final bool hasAC;
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
    this.hasWifi = false,
    this.hasAC = false,
    this.isPopular = false,
    this.isNearby = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'city': city,
      'price': price,
      'rating': rating,
      'category': category,
      'imageUrl': imageUrl,
      'hasWifi': hasWifi,
      'hasAC': hasAC,
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
      imageUrl: map['imageUrl'] ?? '',
      hasWifi: map['hasWifi'] ?? false,
      hasAC: map['hasAC'] ?? false,
      isPopular: map['isPopular'] ?? false,
      isNearby: map['isNearby'] ?? false,
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
  final String status; // 'Pending', 'Approved', 'Cancelled'
  final String roomType; // 'Single Sharing', 'Double Sharing', 'Triple Sharing'

  PGBooking({
    required this.id,
    required this.pg,
    required this.checkInDate,
    required this.status,
    required this.roomType,
  });

  PGBooking copyWith({
    String? status,
  }) {
    return PGBooking(
      id: id,
      pg: pg,
      checkInDate: checkInDate,
      status: status ?? this.status,
      roomType: roomType,
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
