import 'package:flutter_test/flutter_test.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/pending_reservations_filters.dart';

void main() {
  group('PendingReservationsFilters', () {
    test('isEmpty is true when no criteria set', () {
      expect(PendingReservationsFilters().isEmpty, isTrue);
    });

    test('trimmedReservationNumber strips hash and whitespace', () {
      final filters = PendingReservationsFilters(
        reservationNumber: '  #ABC-1  ',
      );
      expect(filters.trimmedReservationNumber, 'ABC-1');
    });

    test('copyWith clearRegionId removes region', () {
      final filters = PendingReservationsFilters(regionId: 'region-1');
      final cleared = filters.copyWith(clearRegionId: true);
      expect(cleared.regionId, isNull);
      expect(cleared.isEmpty, isTrue);
    });

    test('copyWith clearReservationNumber removes code', () {
      final filters = PendingReservationsFilters(reservationNumber: 'X1');
      final cleared = filters.copyWith(clearReservationNumber: true);
      expect(cleared.trimmedReservationNumber, isNull);
      expect(cleared.isEmpty, isTrue);
    });
  });
}
