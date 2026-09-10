import 'package:flutter_test/flutter_test.dart';
import 'package:pg_findar/models/pg_model.dart';
import 'package:pg_findar/services/data_service.dart';

void main() {
  group('PG Functionality and Filter Matcher Tests', () {
    final dataService = DataService();

    test('DataService initial PGs have full facility profiles', () {
      final pgs = dataService.pgsNotifier.value;
      expect(pgs.isNotEmpty, true);

      final greenValley = pgs.firstWhere(
        (p) => p.name.contains('Green Valley'),
      );
      expect(greenValley.hasWifi, true);
      expect(greenValley.hasAC, true);
      expect(greenValley.hasFood, true);
      expect(greenValley.hasParking, true);
      expect(greenValley.hasLaundry, true);
      expect(greenValley.hasTV, true);
      expect(greenValley.hasFridge, true);
      expect(greenValley.hasGeyser, true);
      expect(greenValley.facilities.length, 8);
    });

    test('Filter criteria exact matching logic', () {
      final pgs = dataService.pgsNotifier.value;

      // Filter: Wifi + AC + Food + Parking
      const criteria = PGFilterCriteria(
        minPrice: 3000,
        maxPrice: 10000,
        gender: 'Both',
        facilities: ['Wifi', 'AC', 'Food', 'Parking'],
      );

      final exactMatches = pgs.where((pg) {
        final inPrice =
            pg.price >= criteria.minPrice && pg.price <= criteria.maxPrice;
        final matchGender =
            criteria.gender == 'Both' ||
            pg.gender == criteria.gender ||
            pg.gender == 'Both';
        final matchesAllFacilities = criteria.facilities.every(
          (f) => pg.hasFacility(f),
        );
        return inPrice && matchGender && matchesAllFacilities;
      }).toList();

      expect(exactMatches.isNotEmpty, true);
      for (final pg in exactMatches) {
        expect(pg.hasWifi, true);
        expect(pg.hasAC, true);
        expect(pg.hasFood, true);
        expect(pg.hasParking, true);
      }
    });

    test('Reference PGs matching calculation logic', () {
      final pgs = dataService.pgsNotifier.value;

      // Filter: All 8 facilities
      const criteria = PGFilterCriteria(
        facilities: [
          'Wifi',
          'AC',
          'Food',
          'Parking',
          'Laundry',
          'TV',
          'Fridge',
          'Gyser',
        ],
      );

      final referencePgs = pgs.where((pg) {
        return pg.matchingFacilitiesCount(criteria.facilities) > 0;
      }).toList();

      referencePgs.sort(
        (a, b) => b
            .matchingFacilitiesCount(criteria.facilities)
            .compareTo(a.matchingFacilitiesCount(criteria.facilities)),
      );

      expect(referencePgs.isNotEmpty, true);
      expect(
        referencePgs.first.matchingFacilitiesCount(criteria.facilities),
        8,
      );
    });
  });
}
