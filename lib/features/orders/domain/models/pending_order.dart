import 'pending_order_item.dart';

/// Pending order from kitchen/pending or bar/pending.
class PendingOrder {
  const PendingOrder({
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
  final List<PendingOrderItem> items;

  /// Total number of items in this order.
  int get itemCount => items.fold<int>(0, (sum, i) => sum + i.quantity);

  factory PendingOrder.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>?;
    final orderType =
        (json['orderType'] ?? json['type']) as String? ?? 'walk_in';
    return PendingOrder(
      orderId: json['orderId'] as String,
      orderNumber: json['orderNumber'] as String? ?? '',
      tableNumber: json['tableNumber']?.toString() ?? '0',
      note: json['note'] as String?,
      orderType: orderType,
      targetTime: json['targetTime'] as String? ?? '',
      reservationDetails: json['reservationDetails'],
      items: itemsList != null
          ? itemsList
              .map((e) => PendingOrderItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }
}
