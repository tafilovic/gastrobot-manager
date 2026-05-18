import 'package:gastrobotmanager/features/notifications/domain/bot_response_payload.dart';
import 'package:gastrobotmanager/features/notifications/domain/notification_payload.dart';

/// Which main-shell tab should refresh when a realtime notification arrives.
enum NotificationRefreshTarget {
  orders,
  reservations,
  none,
}

/// Maps socket/FCM payloads to [NotificationRefreshTarget].
abstract final class NotificationRefreshTargetMapper {
  NotificationRefreshTargetMapper._();

  static NotificationRefreshTarget fromPayload(NotificationPayload payload) {
    final type = payload.type;
    if (type == null || type.isEmpty) return NotificationRefreshTarget.none;

    switch (type) {
      case 'order':
      case 'bill_request':
      case 'item_rejection':
      case 'item_accepted':
      case 'kitchen':
        return NotificationRefreshTarget.orders;
      case 'reservation':
      case 'reservation_reminder':
        return NotificationRefreshTarget.reservations;
      default:
        return NotificationRefreshTarget.none;
    }
  }

  static NotificationRefreshTarget fromBotResponse(BotResponsePayload payload) {
    if (payload.type == 'reservation_created') {
      return NotificationRefreshTarget.reservations;
    }
    return NotificationRefreshTarget.none;
  }

  static String? routeKeyFor(NotificationRefreshTarget target) {
    switch (target) {
      case NotificationRefreshTarget.orders:
        return 'orders';
      case NotificationRefreshTarget.reservations:
        return 'reservations';
      case NotificationRefreshTarget.none:
        return null;
    }
  }
}
