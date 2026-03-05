import 'package:gastrobotmanager/features/preparing/domain/models/kitchen_queue_item.dart';

/// Kitchen queue order from GET .../kitchen/queue?prepStatus=ready.
class KitchenQueueOrder {
  const KitchenQueueOrder({
    required this.orderId,
    required this.orderNumber,
    required this.tableNumber,
    this.note,
    required this.type,
    required this.targetTime,
    this.isFuture = false,
    this.items = const [],
  });

  final String orderId;
  final String orderNumber;
  final String tableNumber;
  final String? note;
  final String type;
  final String targetTime;
  final bool isFuture;
  final List<KitchenQueueItem> items;

  /// Total number of dish items in this order.
  int get itemCount => items.fold<int>(0, (sum, i) => sum + i.quantity);

  factory KitchenQueueOrder.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>?;
    return KitchenQueueOrder(
      orderId: json['orderId'] as String,
      orderNumber: json['orderNumber'] as String? ?? '',
      tableNumber: json['tableNumber']?.toString() ?? '0',
      note: json['note'] as String?,
      type: json['type'] as String? ?? 'immediate',
      targetTime: json['targetTime'] as String? ?? '',
      isFuture: json['isFuture'] as bool? ?? false,
      items: itemsList != null
          ? itemsList
              .map((e) => KitchenQueueItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }
}
