import 'package:flutter/material.dart';
import '../models/pg_model.dart';

/// ============================================================================
/// SAMPLE UI PRESENTATION DATA & STATE
/// ============================================================================
/// Provides sample mock data for UI presentation and interactive demo.
/// 100% Pure Flutter Frontend UI — No backend or local storage required.
/// ============================================================================

class ApiService {
  // Singleton instance
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal() {
    _initSampleData();
  }

  void reloadSampleData() {
    _initSampleData();
  }

  // --------------------------------------------------------------------------
  // Reactive Notifiers (UI updates automatically)
  // --------------------------------------------------------------------------
  final ValueNotifier<List<PGAccommodation>> pgsNotifier = ValueNotifier([]);
  final ValueNotifier<List<String>> savedPgIdsNotifier = ValueNotifier([]);
  final ValueNotifier<List<PGBooking>> bookingsNotifier = ValueNotifier([]);
  final ValueNotifier<List<UserReview>> userReviewsNotifier = ValueNotifier([]);

  // In-memory User Profile (No backend needed)
  final ValueNotifier<String> userNameNotifier = ValueNotifier('User');
  final ValueNotifier<String> userEmailNotifier = ValueNotifier('user@gmail.com');
  final ValueNotifier<String> userPasswordNotifier = ValueNotifier('123456');

  /// Update user profile details
  void updateProfile({
    required String name,
    required String email,
    String? password,
  }) {
    userNameNotifier.value = name.trim();
    userEmailNotifier.value = email.trim();
    if (password != null && password.trim().isNotEmpty) {
      userPasswordNotifier.value = password.trim();
    }
  }

  // --------------------------------------------------------------------------
  // Initial Mock PG Data
  // --------------------------------------------------------------------------
  void _initSampleData() {
    pgsNotifier.value = [
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

    bookingsNotifier.value = [
      PGBooking(
        id: 'b1',
        pg: pgsNotifier.value[0],
        checkInDate: DateTime(2025, 5, 10),
        checkOutDate: DateTime(2025, 6, 10),
        status: 'completed',
        roomType: 'Double Sharing',
        totalPaid: 13000,
        customDateRange: '10 May 2025 - 10 Jun 2025',
      ),
      PGBooking(
        id: 'b2',
        pg: pgsNotifier.value[3], // Royal PG
        checkInDate: DateTime(2025, 3, 5),
        checkOutDate: DateTime(2025, 5, 5),
        status: 'Cancelled',
        roomType: 'Single Sharing',
        totalPaid: 0,
        customDateRange: '5 Mar 2025 - 5 May 2025',
      ),
      PGBooking(
        id: 'b3',
        pg: pgsNotifier.value[0],
        checkInDate: DateTime(2024, 12, 1),
        checkOutDate: DateTime(2025, 3, 1),
        status: 'completed',
        roomType: 'Double Sharing',
        totalPaid: 19500,
        customDateRange: '1 Dec 2024 - 1 Mar 2025',
      ),
    ];

    userReviewsNotifier.value = [
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

  // --------------------------------------------------------------------------
  // Interactive UI Methods (Pure In-Memory Presentation)
  // --------------------------------------------------------------------------

  /// Toggle PG in Favorites list
  void toggleFavorite(String pgId) {
    final currentList = List<String>.from(savedPgIdsNotifier.value);
    if (currentList.contains(pgId)) {
      currentList.remove(pgId);
    } else {
      currentList.add(pgId);
    }
    savedPgIdsNotifier.value = currentList;
  }

  /// Check if PG is favorited
  bool isFavorite(String pgId) {
    return savedPgIdsNotifier.value.contains(pgId);
  }

  bool isSaved(String pgId) {
    return savedPgIdsNotifier.value.contains(pgId);
  }

  /// Create a new PG booking request
  void bookPG(
    PGAccommodation pg,
    DateTime checkInDate,
    String roomType, {
    double? totalPaid,
    String? dateRange,
  }) {
    final newBooking = PGBooking(
      id: 'book_${DateTime.now().millisecondsSinceEpoch}',
      pg: pg,
      checkInDate: checkInDate,
      roomType: roomType,
      status: 'Pending',
      totalPaid: totalPaid ?? pg.price * 2,
      customDateRange: dateRange,
    );

    final currentBookings = List<PGBooking>.from(bookingsNotifier.value);
    currentBookings.insert(0, newBooking);
    bookingsNotifier.value = currentBookings;
  }

  /// Cancel an existing booking
  void cancelBooking(String bookingId) {
    final currentBookings = bookingsNotifier.value.map((booking) {
      if (booking.id == bookingId) {
        return booking.copyWith(status: 'Cancelled');
      }
      return booking;
    }).toList();

    bookingsNotifier.value = currentBookings;
  }

  // User Reviews methods
  void addReview(UserReview review) {
    final currentReviews = List<UserReview>.from(userReviewsNotifier.value);
    final existingIndex = currentReviews.indexWhere(
      (r) =>
          (review.bookingId != null && r.bookingId == review.bookingId) ||
          (r.pgId == review.pgId && r.id == review.id),
    );
    if (existingIndex != -1) {
      currentReviews[existingIndex] = review;
    } else {
      currentReviews.insert(0, review);
    }
    userReviewsNotifier.value = currentReviews;
  }

  void deleteReview(String reviewId) {
    final currentReviews = List<UserReview>.from(userReviewsNotifier.value);
    currentReviews.removeWhere((r) => r.id == reviewId);
    userReviewsNotifier.value = currentReviews;
  }
}

// Alias for compatibility
typedef DataService = ApiService;
