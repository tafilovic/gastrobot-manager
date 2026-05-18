import 'package:flutter_test/flutter_test.dart';
import 'package:gastrobotmanager/features/notifications/domain/notification_payload.dart';

void main() {
  group('NotificationPayload.fromMap', () {
    test('parses socket notification with map body', () {
      final payload = NotificationPayload.fromMap({
        'id': 'n1',
        'title': 'order.for_table',
        'body': {'table': 'A5', 'orderId': 'o1'},
        'type': 'order',
        'entityId': 'o1',
      });

      expect(payload, isNotNull);
      expect(payload!.id, 'n1');
      expect(payload.titleKey, 'order.for_table');
      expect(payload.body['table'], 'A5');
      expect(payload.type, 'order');
    });

    test('returns null when title missing', () {
      expect(
        NotificationPayload.fromMap({'type': 'order'}),
        isNull,
      );
    });

    test('fromDynamic accepts Map from socket event', () {
      final payload = NotificationPayload.fromDynamic({
        'title': 'reservation.new_request',
        'body': {'reservationId': 'r1'},
        'type': 'reservation',
      });
      expect(payload?.type, 'reservation');
    });
  });
}
