import 'package:gastrobotmanager/features/orders/domain/models/kitchen_order_item.dart';

/// Kitchen pending order from GET /venues/{venueId}/kitchen/pending.
class KitchenPendingOrder {
  const KitchenPendingOrder({
    required this.orderId,
    required this.orderNumber,
    required this.tableNumber,
    this.note,
    required this.orderType,
    required this.targetTime,
    this.reservationDetails,
    this.items = const [],
  });

  final String orderId;
  final String orderNumber;
  final String tableNumber;
  final String? note;
  final String orderType;
  final String targetTime;
  final dynamic reservationDetails;
  final List<KitchenOrderItem> items;

  /// Total number of dish items in this order.
  int get itemCount => items.fold<int>(0, (sum, i) => sum + i.quantity);

  factory KitchenPendingOrder.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>?;
    return KitchenPendingOrder(
      orderId: json['orderId'] as String,
      orderNumber: json['orderNumber'] as String? ?? '',
      tableNumber: json['tableNumber']?.toString() ?? '0',
      note: json['note'] as String?,
      orderType: json['orderType'] as String? ?? 'walk_in',
      targetTime: json['targetTime'] as String? ?? '',
      reservationDetails: json['reservationDetails'],
      items: itemsList != null
          ? itemsList
              .map((e) => KitchenOrderItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }
}
