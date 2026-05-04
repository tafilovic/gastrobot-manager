import 'package:gastrobotmanager/features/notifications/domain/notification_payload.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

class NotificationText {
  const NotificationText({required this.title, this.body});

  final String title;
  final String? body;
}

class NotificationLocalizer {
  const NotificationLocalizer();

  NotificationText resolve(NotificationPayload payload, AppLocalizations l10n) {
    final title = _resolveTitle(payload.titleKey, payload.body, l10n);
    final messageKey = payload.messageKey;
    final body = messageKey == null
        ? _resolveFallbackBody(payload.titleKey, payload.body, l10n)
        : _resolveMessage(messageKey, payload.body, l10n);

    return NotificationText(title: title, body: body);
  }

  String _resolveTitle(
    String key,
    Map<String, dynamic> values,
    AppLocalizations l10n,
  ) {
    return switch (key) {
      'order.for_table' => l10n.notificationOrderForTableTitle(
        _s(values, 'table'),
      ),
      'order.kitchen_for_table' => l10n.notificationOrderKitchenForTableTitle(
        _s(values, 'table'),
      ),
      'order.bar_for_table' => l10n.notificationOrderBarForTableTitle(
        _s(values, 'table'),
      ),
      'order.rejected' => l10n.notificationOrderRejectedTitle(
        _s(values, 'orderNumber'),
      ),
      'order.confirmed' => l10n.notificationOrderConfirmedTitle(
        _s(values, 'orderNumber'),
      ),
      'order.completion_time' => l10n.notificationOrderCompletionTimeTitle,
      'order_item.rejected_title' => l10n.notificationOrderItemRejectedTitle(
        _s(values, 'productName'),
      ),
      'order_item.rejected_waiter_title' =>
        l10n.notificationOrderItemRejectedWaiterTitle(_s(values, 'table')),
      'order_item.eta_title' => l10n.notificationOrderItemEtaTitle(
        _s(values, 'table'),
      ),
      'order_item.accepted_title' => l10n.notificationOrderItemAcceptedTitle(
        _s(values, 'productName'),
      ),
      'reservation.new_request' => l10n.notificationReservationNewRequestTitle,
      'reservation.confirmed' => l10n.notificationReservationConfirmedTitle(
        _s(values, 'reservationNumber'),
      ),
      'reservation.rejected' => l10n.notificationReservationRejectedTitle(
        _s(values, 'reservationNumber'),
      ),
      'reservation.cancelled' => l10n.notificationReservationCancelledTitle(
        _s(values, 'reservationNumber'),
      ),
      'reservation_reminder.title' => l10n.notificationReservationReminderTitle,
      'kitchen.start_preparation_title' =>
        l10n.notificationKitchenStartPreparationTitle,
      'food_ready.title' => l10n.notificationFoodReadyTitle(
        _s(values, 'table'),
      ),
      'drinks_ready.title' => l10n.notificationDrinksReadyTitle(
        _s(values, 'table'),
      ),
      _ => key,
    };
  }

  String? _resolveMessage(
    String key,
    Map<String, dynamic> values,
    AppLocalizations l10n,
  ) {
    return switch (key) {
      'order_item.rejected_customer_body' =>
        l10n.notificationOrderItemRejectedCustomerBody(
          _s(values, 'productName'),
        ),
      'order_item.rejected_waiter_body' =>
        l10n.notificationOrderItemRejectedWaiterBody(_s(values, 'productName')),
      'order_item.eta_body' => l10n.notificationOrderItemEtaBody(
        _s(values, 'minutes'),
        _s(values, 'productName'),
      ),
      'order_item.accepted_body' => l10n.notificationOrderItemAcceptedBody(
        _s(values, 'productName'),
      ),
      'reservation_reminder.body' => l10n.notificationReservationReminderBody,
      'kitchen.start_preparation_body' =>
        l10n.notificationKitchenStartPreparationBody(
          _s(values, 'reservationNumber'),
          _s(values, 'time'),
        ),
      'food_ready.body' => l10n.notificationFoodReadyBody(_s(values, 'items')),
      'drinks_ready.body' => l10n.notificationDrinksReadyBody(
        _s(values, 'items'),
      ),
      _ => _fallbackBody(values),
    };
  }

  String? _resolveFallbackBody(
    String key,
    Map<String, dynamic> values,
    AppLocalizations l10n,
  ) {
    return switch (key) {
      'order.for_table' => l10n.notificationOrderForTableBody(
        _s(values, 'items'),
      ),
      'order.kitchen_for_table' => l10n.notificationOrderKitchenForTableBody(
        _s(values, 'items'),
      ),
      'order.bar_for_table' => l10n.notificationOrderBarForTableBody(
        _s(values, 'items'),
      ),
      'order.rejected' => l10n.notificationOrderRejectedBody(
        _s(values, 'table'),
        _s(values, 'rejectionNote'),
      ),
      'order.confirmed' => l10n.notificationOrderConfirmedBody(
        _s(values, 'table'),
        _s(values, 'venueName'),
      ),
      'order.completion_time' => l10n.notificationOrderCompletionTimeBody(
        _s(values, 'time'),
      ),
      'reservation.new_request' => l10n.notificationReservationNewRequestBody(
        _s(values, 'people'),
        _s(values, 'time'),
        _s(values, 'table'),
      ),
      'reservation.confirmed' => l10n.notificationReservationConfirmedBody(
        _s(values, 'table'),
        _s(values, 'venueName'),
      ),
      'reservation.rejected' => l10n.notificationReservationRejectedBody(
        _s(values, 'reason'),
      ),
      'reservation.cancelled' => l10n.notificationReservationCancelledBody(
        _s(values, 'venueName'),
      ),
      _ => _fallbackBody(values),
    };
  }

  static String _s(Map<String, dynamic> values, String key) {
    final value = values[key];
    if (value == null) return '';
    if (value is Iterable) return value.map(_formatValue).join(', ');
    return _formatValue(value);
  }

  static String? _fallbackBody(Map<String, dynamic> values) {
    final message = values['message'];
    if (message is String && message.isNotEmpty) return message;
    final items = values['items'];
    if (items is Iterable && items.isNotEmpty) {
      return items.map(_formatValue).join(', ');
    }
    return null;
  }

  static String _formatValue(dynamic value) {
    if (value is Map) {
      final productName = value['productName'];
      final quantity = value['quantity'];
      if (productName != null && quantity != null) {
        return '${quantity}x $productName';
      }
      if (productName != null) return productName.toString();
    }
    return value.toString();
  }
}
