import 'package:flutter_test/flutter_test.dart';
import 'package:gastrobotmanager/features/reservations/utils/trim_reservation_number.dart';

void main() {
  group('trimReservationNumber', () {
    test('returns null for empty or whitespace', () {
      expect(trimReservationNumber(null), isNull);
      expect(trimReservationNumber(''), isNull);
      expect(trimReservationNumber('   '), isNull);
    });

    test('strips hash and trims', () {
      expect(trimReservationNumber('  #ABC-1  '), 'ABC-1');
      expect(trimReservationNumber('X2'), 'X2');
    });
  });
}
