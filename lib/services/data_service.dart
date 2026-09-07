import 'package:flutter/material.dart';
import '../models/pg_model.dart';

class DataService {
  // Singleton pattern
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal();

  // PG Accommodations list
  final ValueNotifier<List<PGAccommodation>> pgsNotifier = ValueNotifier<List<PGAccommodation>>([
    PGAccommodation(
      id: '1',
      name: 'Green Valley PG',
      location: 'Rajkot',
      city: 'Rajkot',
      price: 6500,
      rating: 4.8,
      category: 'Boys PG',
      imageUrl: 'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?q=80&w=600&auto=format&fit=crop',
      hasWifi: true,
      hasAC: true,
      isPopular: true,
      isNearby: false,
    ),
    PGAccommodation(
      id: '2',
      name: 'Royal PG',
      location: 'Rajkot',
      city: 'Rajkot',
      price: 6500,
      rating: 4.8,
      category: 'Girls PG',
      imageUrl: 'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?q=80&w=600&auto=format&fit=crop',
      hasWifi: true,
      hasAC: true,
      isPopular: true,
      isNearby: false,
    ),
    PGAccommodation(
      id: '3',
      name: 'Shivam PG',
      location: 'Prahlad Nagar',
      city: 'Ahmedabad',
      price: 6200,
      rating: 4.6,
      category: 'Boys PG',
      imageUrl: 'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?q=80&w=600&auto=format&fit=crop',
      hasWifi: true,
      hasAC: false,
      isPopular: false,
      isNearby: true,
    ),
    PGAccommodation(
      id: '4',
      name: 'Beary best hostel',
      location: 'Prahlad Nagar',
      city: 'Ahmedabad',
      price: 6200,
      rating: 4.2,
      category: 'Hostels',
      imageUrl: 'https://images.unsplash.com/photo-1564013799919-ab600027ffc6?q=80&w=600&auto=format&fit=crop',
      hasWifi: true,
      hasAC: false,
      isPopular: false,
      isNearby: true,
    ),
    PGAccommodation(
      id: '5',
      name: 'Metro Heights',
      location: 'Mavdi, Rajkot',
      city: 'Rajkot',
      price: 8500,
      rating: 4.5,
      category: 'Flats',
      imageUrl: 'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?q=80&w=600&auto=format&fit=crop',
      hasWifi: true,
      hasAC: true,
      isPopular: false,
      isNearby: false,
    ),
    PGAccommodation(
      id: '6',
      name: 'Sunshine Girls PG',
      location: 'Prahlad Nagar',
      city: 'Ahmedabad',
      price: 5800,
      rating: 4.4,
      category: 'Girls PG',
      imageUrl: 'https://images.unsplash.com/photo-1598928506311-c55ded91a20c?q=80&w=600&auto=format&fit=crop',
      hasWifi: true,
      hasAC: true,
      isPopular: false,
      isNearby: true,
    ),
    PGAccommodation(
      id: '7',
      name: 'Alpha Boys Hostel',
      location: 'Kalawad Road, Rajkot',
      city: 'Rajkot',
      price: 5000,
      rating: 4.1,
      category: 'Hostels',
      imageUrl: 'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?q=80&w=600&auto=format&fit=crop',
      hasWifi: true,
      hasAC: false,
      isPopular: false,
      isNearby: false,
    ),
    PGAccommodation(
      id: '8',
      name: 'Elite Luxury Flat',
      location: 'Prahlad Nagar',
      city: 'Ahmedabad',
      price: 12000,
      rating: 4.9,
      category: 'Flats',
      imageUrl: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?q=80&w=600&auto=format&fit=crop',
      hasWifi: true,
      hasAC: true,
      isPopular: true,
      isNearby: true,
    ),
  ]);

  // Saved/Favorited PGs list (stores ID)
  final ValueNotifier<List<String>> savedPgIdsNotifier = ValueNotifier<List<String>>([]);

  // Bookings list
  final ValueNotifier<List<PGBooking>> bookingsNotifier = ValueNotifier<List<PGBooking>>([]);

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
  void bookPG(PGAccommodation pg, DateTime checkInDate, String roomType) {
    final newBooking = PGBooking(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      pg: pg,
      checkInDate: checkInDate,
      status: 'Pending',
      roomType: roomType,
    );

    final currentBookings = List<PGBooking>.from(bookingsNotifier.value);
    currentBookings.add(newBooking);
    bookingsNotifier.value = currentBookings;

    // Simulate auto-approval by admin/organizer after 6 seconds
    Future.delayed(const Duration(seconds: 6), () {
      final updatedBookings = List<PGBooking>.from(bookingsNotifier.value);
      final index = updatedBookings.indexWhere((b) => b.id == newBooking.id);
      if (index != -1 && updatedBookings[index].status == 'Pending') {
        updatedBookings[index] = updatedBookings[index].copyWith(status: 'Approved');
        bookingsNotifier.value = updatedBookings;
      }
    });
  }

  // Cancel a Booking
  void cancelBooking(String bookingId) {
    final currentBookings = List<PGBooking>.from(bookingsNotifier.value);
    final index = currentBookings.indexWhere((b) => b.id == bookingId);
    if (index != -1) {
      currentBookings[index] = currentBookings[index].copyWith(status: 'Cancelled');
      bookingsNotifier.value = currentBookings;
    }
  }
}
