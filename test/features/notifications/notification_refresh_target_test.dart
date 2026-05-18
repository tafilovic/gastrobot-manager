import 'package:flutter_test/flutter_test.dart';
import 'package:gastrobotmanager/features/notifications/domain/bot_response_payload.dart';
import 'package:gastrobotmanager/features/notifications/domain/notification_payload.dart';
import 'package:gastrobotmanager/features/notifications/domain/notification_refresh_target.dart';

void main() {
  group('NotificationRefreshTargetMapper', () {
    test('maps order notification to orders', () {
      const payload = NotificationPayload(
        titleKey: 'order.for_table',
        body: {},
        type: 'order',
      );
      expect(
        NotificationRefreshTargetMapper.fromPayload(payload),
        NotificationRefreshTarget.orders,
      );
    });

    test('maps reservation notification to reservations', () {
      const payload = NotificationPayload(
        titleKey: 'reservation.new_request',
        body: {},
        type: 'reservation',
      );
      expect(
        NotificationRefreshTargetMapper.fromPayload(payload),
        NotificationRefreshTarget.reservations,
      );
    });

    test('maps bot reservation_created to reservations', () {
      const payload = BotResponsePayload(
        type: 'reservation_created',
        body: {'reservationId': 'r1'},
      );
      expect(
        NotificationRefreshTargetMapper.fromBotResponse(payload),
        NotificationRefreshTarget.reservations,
      );
    });

    test('maps null type to none', () {
      const payload = NotificationPayload(
        titleKey: 'order.completion_time',
        body: {},
      );
      expect(
        NotificationRefreshTargetMapper.fromPayload(payload),
        NotificationRefreshTarget.none,
      );
    });
  });
}
