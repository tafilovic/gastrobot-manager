import 'package:flutter_test/flutter_test.dart';
import 'package:gastrobotmanager/features/reservations/data/waiter_reservation_json.dart';

void main() {
  test('waiter pending response fields (id, reservationNumber, reservationStart, peopleCount)', () {
    final o = pendingOrderFromWaiterReservationJson({
      'id': 'a4d79732-9b3a-45ed-bff8-2011b1dfc118',
      'peopleCount': 4,
      'reservationStart': '2026-02-09T19:00:00.000Z',
      'status': 'pending',
      'type': 'classic',
      'reservationNumber': 'UA066ET',
      'region': null,
    });

    expect(o.orderId, 'a4d79732-9b3a-45ed-bff8-2011b1dfc118');
    expect(o.orderNumber, 'UA066ET');
    expect(o.targetTime, '2026-02-09T19:00:00.000Z');
    final rd = o.reservationDetails as Map?;
    expect(rd?['partySize'], 4);
  });

  test('maps reservationId and referenceCode to PendingOrder fields', () {
    final o = pendingOrderFromWaiterReservationJson({
      'reservationId': 'uuid-1',
      'referenceCode': 'RE3459C',
      'reservationDate': '2025-11-27T19:00:00.000Z',
      'region': 'Bašta',
      'partySize': 2,
    });

    expect(o.orderId, 'uuid-1');
    expect(o.orderNumber, 'RE3459C');
    expect(o.targetTime, contains('2025-11-27'));
    expect(o.reservationDetails, isA<Map>());
    final rd = o.reservationDetails as Map;
    expect(rd['region'], 'Bašta');
    expect(rd['partySize'], 2);
  });

  test('snake_case API fields', () {
    final o = pendingOrderFromWaiterReservationJson({
      'reservation_id': 'r2',
      'reference_code': 'RE2079Y',
      'scheduled_at': '2026-11-27T20:30:00.000Z',
      'seating_area': 'Unutra',
      'number_of_guests': 6,
    });

    expect(o.orderId, 'r2');
    expect(o.orderNumber, 'RE2079Y');
    expect((o.reservationDetails as Map)['region'], 'Unutra');
    expect((o.reservationDetails as Map)['partySize'], 6);
  });
}
