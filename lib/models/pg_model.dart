class PGAccommodation {
  final String id;
  final String name;
  final String location; // Detailed location, e.g., "Rajkot" or "Prahlad Nagar"
  final String city;     // E.g., "Rajkot" or "Ahmedabad"
  final double price;    // Price per month
  final double rating;
  final String category; // 'Boys PG', 'Girls PG', 'Hostels', 'Flats'
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
}

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
}
