import 'package:flutter/material.dart';
import '../models/pg_model.dart';

/// ============================================================================
/// COMPLETE BACKEND & MOCK API SERVICE
/// ============================================================================
/// Centralized service handling all mock API calls, auth simulations,
/// and reactive state notifiers for the PG Finder application.
/// ============================================================================

class ApiService {
  // Singleton instance
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal() {
    _initSampleData();
  }

  // --------------------------------------------------------------------------
  // Reactive Notifiers (UI updates automatically)
  // --------------------------------------------------------------------------
  final ValueNotifier<List<PGAccommodation>> pgsNotifier = ValueNotifier([]);
  final ValueNotifier<List<String>> savedPgIdsNotifier = ValueNotifier([]);
  final ValueNotifier<List<PGBooking>> bookingsNotifier = ValueNotifier([]);

  // --------------------------------------------------------------------------
  // Initial Mock PG Data
  // --------------------------------------------------------------------------
  void _initSampleData() {
    pgsNotifier.value = [
      PGAccommodation(
        id: '1',
        name: 'Green Villa PG',
        location: 'Kalawad Road',
        city: 'Rajkot',
        price: 6500,
        rating: 4.8,
        category: 'Boys',
        imageUrl:
            'https://images.unsplash.com/photo-1555854877-bab0e564b8d5?auto=format&fit=crop&w=600&q=80',
        hasWifi: true,
        hasAC: true,
        isPopular: true,
        isNearby: false,
      ),
      PGAccommodation(
        id: '2',
        name: 'Sunshine Residency',
        location: '150 Feet Ring Road',
        city: 'Rajkot',
        price: 7500,
        rating: 4.9,
        category: 'Girls',
        imageUrl:
            'https://images.unsplash.com/photo-1595526114035-0d45ed16cfbf?auto=format&fit=crop&w=600&q=80',
        hasWifi: true,
        hasAC: true,
        isPopular: true,
        isNearby: false,
      ),
      PGAccommodation(
        id: '3',
        name: 'Comfort Stay PG',
        location: 'University Road',
        city: 'Rajkot',
        price: 5500,
        rating: 4.5,
        category: 'Both',
        imageUrl:
            'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?auto=format&fit=crop&w=600&q=80',
        hasWifi: true,
        hasAC: false,
        isPopular: true,
        isNearby: true,
      ),
      PGAccommodation(
        id: '4',
        name: 'Royal Palace Hostel',
        location: 'Yagnik Road',
        city: 'Rajkot',
        price: 8000,
        rating: 4.7,
        category: 'Boys',
        imageUrl:
            'https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=600&q=80',
        hasWifi: true,
        hasAC: true,
        isPopular: false,
        isNearby: true,
      ),
      PGAccommodation(
        id: '5',
        name: 'Shanti Girls PG',
        location: 'Astron Chowk',
        city: 'Rajkot',
        price: 6000,
        rating: 4.6,
        category: 'Girls',
        imageUrl:
            'https://images.unsplash.com/photo-1560448204-e02f11c3d0e2?auto=format&fit=crop&w=600&q=80',
        hasWifi: true,
        hasAC: false,
        isPopular: false,
        isNearby: true,
      ),
    ];
  }

  // --------------------------------------------------------------------------
  // Authentication Backend Methods (Mock API)
  // --------------------------------------------------------------------------

  /// Simulate User Login
  Future<bool> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return email.isNotEmpty && password.isNotEmpty;
  }

  /// Simulate User Sign Up
  Future<bool> signUp(String name, String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return name.isNotEmpty && email.isNotEmpty && password.isNotEmpty;
  }

  /// Simulate Password Reset Request
  Future<bool> forgotPassword(String email) async {
    await Future.delayed(const Duration(seconds: 1));
    return email.isNotEmpty;
  }

  // --------------------------------------------------------------------------
  // Accommodation & Booking Backend Methods (Mock API)
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

  /// Create a new PG booking request
  void bookPG(PGAccommodation pg, DateTime checkInDate, String roomType) {
    final newBooking = PGBooking(
      id: 'book_${DateTime.now().millisecondsSinceEpoch}',
      pg: pg,
      checkInDate: checkInDate,
      roomType: roomType,
      status: 'Pending',
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
}

// Alias for compatibility
typedef DataService = ApiService;
