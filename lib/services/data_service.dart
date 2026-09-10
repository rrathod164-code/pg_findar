import 'package:flutter/material.dart';
import '../models/pg_model.dart';

class DataService {
  // Singleton pattern
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // PG Accommodations list
  final ValueNotifier<List<PGAccommodation>>
  pgsNotifier = ValueNotifier<List<PGAccommodation>>([
    PGAccommodation(
      id: '1',
      name: 'Green Valley PG',
      location: 'Kalawad Road, Rajkot',
      city: 'Rajkot',
      price: 6500,
      rating: 4.8,
      category: 'Boys PG',
      gender: 'Boys',
      imageUrl:
          'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?q=80&w=600&auto=format&fit=crop',
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
      name: 'Royal PG',
      location: '150ft Ring Road, Rajkot',
      city: 'Rajkot',
      price: 6500,
      rating: 4.8,
      category: 'Girls PG',
      gender: 'Girls',
      imageUrl:
          'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?q=80&w=600&auto=format&fit=crop',
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
      name: 'Shivam PG',
      location: 'University Road, Rajkot',
      city: 'Rajkot',
      price: 6500,
      rating: 4.8,
      category: 'Boys PG',
      gender: 'Boys',
      imageUrl:
          'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?q=80&w=600&auto=format&fit=crop',
      hasWifi: true,
      hasAC: true,
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
      name: 'Beary besti hostel',
      location: 'Yagnik Road, Rajkot',
      city: 'Rajkot',
      price: 6500,
      rating: 4.8,
      category: 'Hostels',
      gender: 'Both',
      imageUrl:
          'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?q=80&w=600&auto=format&fit=crop',
      hasWifi: true,
      hasAC: true,
      hasFood: true,
      hasParking: true,
      hasLaundry: true,
      hasTV: false,
      hasFridge: false,
      hasGeyser: true,
      isPopular: true,
      isNearby: true,
    ),
    PGAccommodation(
      id: '5',
      name: "Kashmira's  PG",
      location: 'Indira Circle, Rajkot',
      city: 'Rajkot',
      price: 6500,
      rating: 4.8,
      category: 'Girls PG',
      gender: 'Girls',
      imageUrl:
          'https://images.unsplash.com/photo-1590490360182-c33d57733427?q=80&w=600&auto=format&fit=crop',
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
      id: '6',
      name: 'Galaxy Prime Hostel',
      location: 'Kalawad Road, Rajkot',
      city: 'Rajkot',
      price: 6500,
      rating: 4.8,
      category: 'Hostels',
      gender: 'Boys',
      imageUrl:
          'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?q=80&w=600&auto=format&fit=crop',
      hasWifi: true,
      hasAC: true,
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
      id: '7',
      name: 'Metro Heights Luxury Flat',
      location: 'Mavdi, Rajkot',
      city: 'Rajkot',
      price: 8500,
      rating: 4.5,
      category: 'Flats',
      gender: 'Both',
      imageUrl:
          'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?q=80&w=600&auto=format&fit=crop',
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
    PGAccommodation(
      id: '8',
      name: 'Sunshine Girls PG & Hostel',
      location: 'SG Highway',
      city: 'Ahmedabad',
      price: 5800,
      rating: 4.4,
      category: 'Girls PG',
      gender: 'Girls',
      imageUrl:
          'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?q=80&w=600&auto=format&fit=crop',
      hasWifi: true,
      hasAC: true,
      hasFood: true,
      hasParking: false,
      hasLaundry: true,
      hasTV: false,
      hasFridge: true,
      hasGeyser: true,
      isPopular: false,
      isNearby: true,
    ),
    PGAccommodation(
      id: '9',
      name: 'Alpha Boys Hostel & PG',
      location: 'Kalawad Road, Rajkot',
      city: 'Rajkot',
      price: 4800,
      rating: 4.1,
      category: 'Hostels',
      gender: 'Boys',
      imageUrl:
          'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?q=80&w=600&auto=format&fit=crop',
      hasWifi: true,
      hasAC: false,
      hasFood: true,
      hasParking: true,
      hasLaundry: false,
      hasTV: false,
      hasFridge: false,
      hasGeyser: true,
      isPopular: false,
      isNearby: false,
    ),
    PGAccommodation(
      id: '10',
      name: 'Elite Living Co-ed PG',
      location: 'Prahlad Nagar',
      city: 'Ahmedabad',
      price: 9500,
      rating: 4.9,
      category: 'Flats',
      gender: 'Both',
      imageUrl:
          'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=600&auto=format&fit=crop',
      hasWifi: true,
      hasAC: true,
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
      id: '11',
      name: 'Radhe Krishna Boys PG',
      location: 'University Road, Rajkot',
      city: 'Rajkot',
      price: 5200,
      rating: 4.3,
      category: 'Boys PG',
      gender: 'Boys',
      imageUrl:
          'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?q=80&w=600&auto=format&fit=crop',
      hasWifi: true,
      hasAC: false,
      hasFood: true,
      hasParking: true,
      hasLaundry: true,
      hasTV: true,
      hasFridge: false,
      hasGeyser: false,
      isPopular: false,
      isNearby: true,
    ),
    PGAccommodation(
      id: '12',
      name: 'Shreeji Girls Haven PG',
      location: 'Indira Circle, Rajkot',
      city: 'Rajkot',
      price: 7200,
      rating: 4.7,
      category: 'Girls PG',
      gender: 'Girls',
      imageUrl:
          'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?q=80&w=600&auto=format&fit=crop',
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
      id: '13',
      name: 'Shivam Residency PG',
      location: 'Prahlad Nagar',
      city: 'Ahmedabad',
      price: 6200,
      rating: 4.6,
      category: 'Boys PG',
      gender: 'Boys',
      imageUrl:
          'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?q=80&w=600&auto=format&fit=crop',
      hasWifi: true,
      hasAC: false,
      hasFood: true,
      hasParking: true,
      hasLaundry: false,
      hasTV: true,
      hasFridge: false,
      hasGeyser: true,
      isPopular: false,
      isNearby: true,
    ),
    PGAccommodation(
      id: '14',
      name: 'Beary Best Youth Hostel',
      location: 'Prahlad Nagar',
      city: 'Ahmedabad',
      price: 4500,
      rating: 4.2,
      category: 'Hostels',
      gender: 'Both',
      imageUrl:
          'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?q=80&w=600&auto=format&fit=crop',
      hasWifi: true,
      hasAC: false,
      hasFood: true,
      hasParking: true,
      hasLaundry: true,
      hasTV: false,
      hasFridge: false,
      hasGeyser: true,
      isPopular: false,
      isNearby: true,
    ),
  ]);

  // Saved/Favorited PGs list (stores ID)
  final ValueNotifier<List<String>> savedPgIdsNotifier =
      ValueNotifier<List<String>>([]);

  // Bookings list (seeded with bookings matching screenshot)
  late final ValueNotifier<List<PGBooking>> bookingsNotifier =
      ValueNotifier<List<PGBooking>>([
        PGBooking(
          id: 'b1',
          pg: pgsNotifier.value[0], // Green Valley PG
          checkInDate: DateTime(2025, 5, 23),
          status: 'Confirmed',
          roomType: 'Double Sharing',
          totalPaid: 6500,
          customDateRange: '23 May 2025',
        ),
        PGBooking(
          id: 'b2',
          pg: pgsNotifier.value[1], // Royal PG
          checkInDate: DateTime(2025, 5, 23),
          status: 'Confirmed',
          roomType: 'Single Sharing',
          totalPaid: 6500,
          customDateRange: '23 May 2025',
        ),
        PGBooking(
          id: 'b3',
          pg: pgsNotifier.value[2], // Shivam PG
          checkInDate: DateTime(2025, 5, 23),
          status: 'Cancelled',
          roomType: 'Triple Sharing',
          totalPaid: 8500,
          customDateRange: '23 May 2025',
        ),
        PGBooking(
          id: 'b4',
          pg: PGAccommodation(
            id: 'maple',
            name: 'Maple PG',
            location: 'Rajkot, Gujarat',
            city: 'Rajkot',
            price: 7500,
            rating: 4.6,
            category: 'Boys PG',
            imageUrl:
                'https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?q=80&w=600&auto=format&fit=crop',
          ),
          checkInDate: DateTime(2025, 5, 23),
          status: 'Confirmed',
          roomType: 'Double Sharing',
          totalPaid: 7500,
          customDateRange: '23 May 2025',
        ),
        PGBooking(
          id: 'b5',
          pg: pgsNotifier.value[3], // Beary besti hostel
          checkInDate: DateTime(2025, 5, 23),
          status: 'Pending',
          roomType: 'Four Sharing',
          totalPaid: 8500,
          customDateRange: '23 May 2025',
        ),
        PGBooking(
          id: 'b6',
          pg: pgsNotifier.value[5], // Galaxy Prime Hostel
          checkInDate: DateTime(2025, 5, 23),
          status: 'Confirmed',
          roomType: 'Single Sharing',
          totalPaid: 10500,
          customDateRange: '23 May 2025',
        ),
        PGBooking(
          id: 'b7',
          pg: pgsNotifier.value[4], // Kashmira's PG
          checkInDate: DateTime(2025, 5, 23),
          status: 'Confirmed',
          roomType: 'Double Sharing',
          totalPaid: 6500,
          customDateRange: '23 May 2025',
        ),
      ]);

  // Update booking status by admin (Confirmed, Pending, Cancelled)
  void updateBookingStatus(String bookingId, String newStatus) {
    final currentBookings = List<PGBooking>.from(bookingsNotifier.value);
    final index = currentBookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      currentBookings[index] = currentBookings[index].copyWith(
        status: newStatus,
      );
      bookingsNotifier.value = currentBookings;
    }
  }

  // Toggle favorite status of a PG
  void toggleFavorite(String pgId) {
    final currentSaved = List<String>.from(savedPgIdsNotifier.value);
    if (currentSaved.contains(pgId)) {
      currentSaved.remove(pgId);
    } else {
      currentSaved.add(pgId);
    }
    savedPgIdsNotifier.value = currentSaved;
  }

  // Check if a PG is favorited
  bool isSaved(String pgId) {
    return savedPgIdsNotifier.value.contains(pgId);
  }

  // Book a PG
  void bookPG(
    PGAccommodation pg,
    DateTime checkInDate,
    String roomType, {
    double? totalPaid,
    String? dateRange,
  }) {
    final newBooking = PGBooking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      pg: pg,
      checkInDate: checkInDate,
      status: 'Pending',
      roomType: roomType,
      totalPaid: totalPaid ?? pg.price * 2,
      customDateRange: dateRange,
    );

    final currentBookings = List<PGBooking>.from(bookingsNotifier.value);
    currentBookings.insert(0, newBooking);
    bookingsNotifier.value = currentBookings;

    // Simulate auto-approval by admin/organizer after 6 seconds
    Future.delayed(const Duration(seconds: 6), () {
      final updatedBookings = List<PGBooking>.from(bookingsNotifier.value);
      final index = updatedBookings.indexWhere((b) => b.id == newBooking.id);
      if (index != -1 && updatedBookings[index].status == 'Pending') {
        updatedBookings[index] = updatedBookings[index].copyWith(
          status: 'Approved',
        );
        bookingsNotifier.value = updatedBookings;
      }
    });
  }

  // Cancel a Booking
  void cancelBooking(String bookingId) {
    final currentBookings = List<PGBooking>.from(bookingsNotifier.value);
    final index = currentBookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      currentBookings[index] = currentBookings[index].copyWith(
        status: 'Cancelled',
      );
      bookingsNotifier.value = currentBookings;
    }
  }

  // User submitted reviews list
  final ValueNotifier<List<UserReview>> userReviewsNotifier =
      ValueNotifier<List<UserReview>>([]);

  // Add or update a review submitted by the user
  void addReview(UserReview review) {
    final currentReviews = List<UserReview>.from(userReviewsNotifier.value);
    // If review already exists for this booking or pg, update it
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

  // Delete a review
  void deleteReview(String reviewId) {
    final currentReviews = List<UserReview>.from(userReviewsNotifier.value);
    currentReviews.removeWhere((r) => r.id == reviewId);
    userReviewsNotifier.value = currentReviews;
  }
}
