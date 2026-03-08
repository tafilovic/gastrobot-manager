import 'package:gastrobotmanager/features/preparing/domain/models/queue_item.dart';

/// Queue order from GET .../kitchen/queue or .../bar/queue?prepStatus=ready.
class QueueOrder {
  const QueueOrder({
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
  final List<QueueItem> items;

  /// Total number of items in this order.
  int get itemCount => items.fold<int>(0, (sum, i) => sum + i.quantity);

  factory QueueOrder.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>?;
    return QueueOrder(
      orderId: json['orderId']?.toString() ?? '',
      orderNumber: json['orderNumber'] as String? ?? '',
      tableNumber: json['tableNumber']?.toString() ?? '0',
      note: json['note'] as String?,
      type: json['type'] as String? ?? 'immediate',
      targetTime: json['targetTime'] as String? ?? '',
      isFuture: json['isFuture'] as bool? ?? false,
      items: itemsList != null
          ? itemsList
              .map((e) => QueueItem.fromJson(e as Map<String, dynamic>))
              .toList()
          : const [],
    );
  }
}
