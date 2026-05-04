import 'dart:ui';

import 'package:gastrobotmanager/features/notifications/domain/notification_payload.dart';

class NotificationText {
  const NotificationText({required this.title, this.body});

  final String title;
  final String? body;
}

class NotificationLocalizer {
  const NotificationLocalizer();

  NotificationText resolve(NotificationPayload payload, Locale locale) {
    final translations = _translationsFor(locale);
    final values = payload.body;
    final titleTemplate = translations[payload.titleKey] ?? payload.titleKey;
    final messageKey = payload.messageKey;
    final bodyTemplate = messageKey == null ? null : translations[messageKey];

    return NotificationText(
      title: _interpolate(titleTemplate, values),
      body: bodyTemplate == null
          ? _fallbackBody(values)
          : _interpolate(bodyTemplate, values),
    );
  }

  Map<String, String> _translationsFor(Locale locale) {
    return switch (locale.languageCode) {
      _ => _englishTranslations,
    };
  }

  static String _interpolate(String template, Map<String, dynamic> values) {
    return template.replaceAllMapped(RegExp(r'\{\{(\w+)\}\}'), (match) {
      final key = match.group(1)!;
      final value = values[key];
      if (value == null) return '';
      if (value is Iterable) return value.map(_formatValue).join(', ');
      return _formatValue(value);
    });
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

const _englishTranslations = <String, String>{
  'order.for_table': 'Order for table {{table}}',
  'order.kitchen_for_table': 'Kitchen Order for table {{table}}',
  'order.bar_for_table': 'Bar Order for table {{table}}',
  'order.rejected': 'Order {{orderNumber}} rejected',
  'order.confirmed': 'Order {{orderNumber}} confirmed',
  'order.completion_time': 'Order completion time',
  'order_item.rejected_title': 'Item Rejected: {{productName}}',
  'order_item.rejected_customer_body':
      'We are sorry, but "{{productName}}" is currently unavailable. It has been removed from your order bill.',
  'order_item.rejected_waiter_title': 'Item Rejected: {{table}}',
  'order_item.rejected_waiter_body':
      '"{{productName}}" was rejected and removed from the order.',
  'order_item.eta_title': 'ETA Set: {{table}}',
  'order_item.eta_body':
      'Kitchen set {{minutes}} min estimate for {{productName}}',
  'order_item.accepted_title': 'Item Accepted: {{productName}}',
  'order_item.accepted_body':
      '"{{productName}}" has been accepted and is being prepared.',
  'reservation.new_request': 'New Reservation Request',
  'reservation.confirmed': 'Reservation {{reservationNumber}} confirmed',
  'reservation.rejected': 'Reservation {{reservationNumber}} rejected',
  'reservation.cancelled': 'Reservation {{reservationNumber}} cancelled',
  'reservation_reminder.title': 'Reservation Reminder',
  'reservation_reminder.body': 'Your reservation is in 8 hours',
  'kitchen.start_preparation_title': 'Start Preparation: Reservation Order',
  'kitchen.start_preparation_body':
      'Time to prepare food for Reservation #{{reservationNumber}}. Guests arrive at {{time}}.',
  'food_ready.title': 'Food Ready: Table {{table}}',
  'food_ready.body': '{{items}} are ready to serve.',
  'drinks_ready.title': 'Drinks Ready: Table {{table}}',
  'drinks_ready.body': '{{items}} are ready at the bar.',
};
