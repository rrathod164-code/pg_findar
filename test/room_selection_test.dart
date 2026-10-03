import 'package:flutter_test/flutter_test.dart';
import 'package:pg_findar/services/api_service.dart';

void main() {
  group('Transparent Room Selection and Owner Approval Tests', () {
    test('PGAccommodation provides transparent room list with numbers and sharing', () {
      final pgs = ApiService.samplePGs;
      expect(pgs.isNotEmpty, true);

      final pg = pgs.first;
      expect(pg.roomsList.isNotEmpty, true);

      final room101 = pg.roomsList.firstWhere((r) => r.roomNumber == 'Room 101');
      expect(room101.floor, '1st Floor');
      expect(room101.sharingType, 'Single Sharing');
      expect(room101.totalBeds, 1);
      expect(room101.availableBeds, greaterThanOrEqualTo(0));

      final room102 = pg.roomsList.firstWhere((r) => r.roomNumber == 'Room 102');
      expect(room102.floor, '1st Floor');
      expect(room102.sharingType, 'Double Sharing');
      expect(room102.totalBeds, 2);
    });

    test('Static bookings list contains valid booking details', () {
      final bookings = ApiService.sampleBookings;
      expect(bookings.isNotEmpty, true);

      final booking = bookings.first;
      expect(booking.roomNumber.isNotEmpty, true);
      expect(booking.floor.isNotEmpty, true);
      expect(booking.roomType.isNotEmpty, true);
      expect(booking.status.isNotEmpty, true);
    });

    test('PGRoom calculates bed availability correctly', () {
      const room = PGRoom(
        id: 'test_r1',
        roomNumber: 'Room 301',
        floor: '3rd Floor',
        sharingType: 'Single Sharing',
        totalBeds: 2,
        occupiedBeds: 1,
        price: 9000,
        amenities: ['AC', 'Wi-Fi'],
      );

      expect(room.availableBeds, 1);
      expect(room.isAvailable, true);
      expect(room.isFull, false);
    });
  });
}
