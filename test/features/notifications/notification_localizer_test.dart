import 'package:flutter_test/flutter_test.dart';
import 'package:gastrobotmanager/features/notifications/data/notification_localizer.dart';
import 'package:gastrobotmanager/features/notifications/domain/notification_payload.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations_en.dart';

void main() {
  const localizer = NotificationLocalizer();
  final l10n = AppLocalizationsEn();

  test('resolves title and body for all documented notification keys', () {
    final payloads = [
      _payload('order.for_table', {
        'table': '5',
        'items': [
          {'productName': 'Burger', 'quantity': 2},
        ],
        'venueName': 'Brrm Restaurant',
      }),
      _payload('order.kitchen_for_table', {
        'table': '5',
        'items': [
          {'productName': 'Burger', 'quantity': 2},
        ],
      }),
      _payload('order.bar_for_table', {
        'table': '5',
        'items': [
          {'productName': 'Cola', 'quantity': 2},
        ],
      }),
      _payload('order.rejected', {
        'orderNumber': '1042',
        'table': '5',
        'rejectionNote': 'Kitchen is closed',
      }),
      _payload('order.confirmed', {
        'orderNumber': '1042',
        'table': '5',
        'venueName': 'Brrm Restaurant',
      }),
      _payload('order.completion_time', {'time': '20:30'}),
      _payload('order_item.rejected_title', {
        'messageKey': 'order_item.rejected_customer_body',
        'productName': 'Burger',
      }),
      _payload('order_item.rejected_waiter_title', {
        'messageKey': 'order_item.rejected_waiter_body',
        'table': '5',
        'productName': 'Burger',
      }),
      _payload('order_item.eta_title', {
        'messageKey': 'order_item.eta_body',
        'table': '5',
        'productName': 'Burger',
        'minutes': 15,
      }),
      _payload('order_item.accepted_title', {
        'messageKey': 'order_item.accepted_body',
        'productName': 'Burger',
      }),
      _payload('reservation.new_request', {
        'reservationNumber': 'R-0042',
        'table': 'N/A',
        'time': '2025-06-15T19:00:00.000Z',
        'people': 4,
      }),
      _payload('reservation.confirmed', {
        'reservationNumber': 'R-0042',
        'table': 'Table 3',
        'venueName': 'Brrm Restaurant',
      }),
      _payload('reservation.rejected', {
        'reservationNumber': 'R-0042',
        'reason': 'No available tables',
      }),
      _payload('reservation.cancelled', {
        'reservationNumber': 'R-0042',
        'venueName': 'Brrm Restaurant',
      }),
      _payload('reservation_reminder.title', {
        'messageKey': 'reservation_reminder.body',
        'reservationNumber': 'R-0042',
      }),
      _payload('kitchen.start_preparation_title', {
        'messageKey': 'kitchen.start_preparation_body',
        'reservationNumber': 'R-0042',
        'time': '07:00 PM',
      }),
      _payload('food_ready.title', {
        'messageKey': 'food_ready.body',
        'table': '5',
        'items': ['Burger', 'Fries'],
      }),
      _payload('drinks_ready.title', {
        'messageKey': 'drinks_ready.body',
        'table': '5',
        'items': ['Cola', 'Beer'],
      }),
    ];

    for (final payload in payloads) {
      final text = localizer.resolve(payload, l10n);
      expect(text.title, isNotEmpty, reason: payload.titleKey);
      expect(text.title, isNot(contains('{{')), reason: payload.titleKey);
      expect(text.body, isNotNull, reason: payload.titleKey);
      expect(text.body, isNotEmpty, reason: payload.titleKey);
      expect(text.body, isNot(contains('{{')), reason: payload.titleKey);
    }
  });
}

NotificationPayload _payload(String titleKey, Map<String, dynamic> body) {
  return NotificationPayload(titleKey: titleKey, body: body);
}
