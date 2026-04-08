import 'package:flutter_test/flutter_test.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/pending_reservation.dart';

void main() {
  test('fromJson maps API pending reservation fields', () {
    final r = PendingReservation.fromJson({
      'id': 'a4d79732-9b3a-45ed-bff8-2011b1dfc118',
      'peopleCount': 4,
      'reservationStart': '2026-02-09T19:00:00.000Z',
      'status': 'pending',
      'type': 'classic',
      'reservationNumber': 'UA066ET',
      'region': null,
    });

    expect(r.id, 'a4d79732-9b3a-45ed-bff8-2011b1dfc118');
    expect(r.reservationNumber, 'UA066ET');
    expect(r.reservationStart, '2026-02-09T19:00:00.000Z');
    expect(r.peopleCount, 4);
    expect(r.regionTitle, isNull);
  });

  test('region.title is used for regionTitle', () {
    final r = PendingReservation.fromJson({
      'id': 'id-1',
      'reservationNumber': 'X1',
      'reservationStart': '2026-01-01T12:00:00.000Z',
      'peopleCount': 2,
      'type': 'classic',
      'status': 'pending',
      'region': {
        'id': 'reg-1',
        'title': 'Stolovi 1-10',
        'area': 'inside',
      },
    });

    expect(r.regionTitle, 'Stolovi 1-10');
  });
}
