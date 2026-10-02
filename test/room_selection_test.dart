import 'package:flutter_test/flutter_test.dart';
import 'package:pg_findar/models/pg_model.dart';
import 'package:pg_findar/services/data_service.dart';

void main() {
  group('Transparent Room Selection and Owner Approval Tests', () {
    final dataService = DataService();

    test('PGAccommodation provides transparent room list with numbers and sharing', () {
      final pgs = dataService.pgsNotifier.value;
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

    test('Student room booking registers with room number, floor, and pending status', () {
      final pg = dataService.pgsNotifier.value.first;
      final selectedRoom = pg.roomsList.firstWhere((r) => r.roomNumber == 'Room 201');

      final initialCount = dataService.bookingsNotifier.value.length;

      dataService.addBooking(
        pg: pg,
        checkInDate: DateTime.now().add(const Duration(days: 3)),
        roomType: selectedRoom.sharingType,
        totalPaid: selectedRoom.price.toDouble(),
        dateRange: '3 Months',
        roomNumber: selectedRoom.roomNumber,
        floor: selectedRoom.floor,
        userName: 'Test Student',
        userPhone: '+91 99999 88888',
      );

      final updatedBookings = dataService.bookingsNotifier.value;
      expect(updatedBookings.length, initialCount + 1);

      final newBooking = updatedBookings.first;
      expect(newBooking.roomNumber, 'Room 201');
      expect(newBooking.floor, '2nd Floor');
      expect(newBooking.roomType, 'Triple Sharing');
      expect(newBooking.status.toLowerCase(), 'pending');
      expect(newBooking.userName, 'Test Student');
    });

    test('Owner approves student booking request and status transitions to Confirmed', () {
      final pendingBooking = dataService.bookingsNotifier.value.firstWhere(
        (b) => b.status.toLowerCase() == 'pending',
      );

      dataService.updateBookingStatus(pendingBooking.id, 'Confirmed');

      final updatedBooking = dataService.bookingsNotifier.value.firstWhere(
        (b) => b.id == pendingBooking.id,
      );
      expect(updatedBooking.status, 'Confirmed');
    });

    test('Owner can upload new room details and students can see them', () {
      final pg = dataService.pgsNotifier.value.first;
      const newRoom = PGRoom(
        id: 'room_custom_301',
        roomNumber: 'Room 301',
        floor: '3rd Floor',
        sharingType: 'Single Sharing',
        totalBeds: 1,
        price: 9000,
        amenities: ['AC', 'Wi-Fi', 'Balcony', 'Attached Bath'],
      );

      // Owner uploads room
      dataService.addOrUpdateRoom(pg.id, newRoom);

      // Verify room is published and visible on the PG
      final updatedPg = dataService.pgsNotifier.value.firstWhere(
        (p) => p.id == pg.id,
      );
      final uploadedRoom = updatedPg.roomsList.firstWhere(
        (r) => r.id == 'room_custom_301',
      );
      expect(uploadedRoom.roomNumber, 'Room 301');
      expect(uploadedRoom.floor, '3rd Floor');
      expect(uploadedRoom.price, 9000);
      expect(uploadedRoom.sharingType, 'Single Sharing');

      // Owner can update/edit room
      final editedRoom = uploadedRoom.copyWith(price: 9500);
      dataService.addOrUpdateRoom(pg.id, editedRoom);
      final pgAfterEdit = dataService.pgsNotifier.value.firstWhere(
        (p) => p.id == pg.id,
      );
      expect(
        pgAfterEdit.roomsList.firstWhere((r) => r.id == 'room_custom_301').price,
        9500,
      );

      // Owner can delete room
      dataService.deleteRoom(pg.id, 'room_custom_301');
      final pgAfterDelete = dataService.pgsNotifier.value.firstWhere(
        (p) => p.id == pg.id,
      );
      expect(
        pgAfterDelete.roomsList.any((r) => r.id == 'room_custom_301'),
        false,
      );
    });
  });
}
