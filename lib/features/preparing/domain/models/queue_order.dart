import 'package:gastrobotmanager/features/preparing/domain/models/queue_item.dart';

/// Queue order from GET .../kitchen/queue or .../bar/queue?prepStatus=ready.
class QueueOrder {
  const QueueOrder({
    required this.orderId,
    required this.orderNumber,
    required this.tableNumber,
    this.tableType,
    this.note,
    required this.type,
    required this.targetTime,
    this.isFuture = false,
    this.items = const [],
  });

  final String orderId;
  final String orderNumber;
  final String tableNumber;

  /// `table` | `room` | `sunbed` when the queue API includes it.
  final String? tableType;
  final String? note;
  final String type;
  final String targetTime;
  final bool isFuture;
  final List<QueueItem> items;

  /// Total number of items in this order.
  int get itemCount => items.fold<int>(0, (sum, i) => sum + i.quantity);

  /// Reads nested `table.type` or top-level `tableType` / `table_type`.
  static String? parseTableTypeFromOrderJson(Map<String, dynamic> json) {
    String? tableType;
    final tableObj = json['table'];
    if (tableObj is Map) {
      final m = Map<String, dynamic>.from(tableObj);
      final rawType = m['type']?.toString().trim();
      if (rawType != null && rawType.isNotEmpty) {
        tableType = rawType;
      }
    }
    tableType ??= () {
      final t = json['tableType'] ?? json['table_type'];
      if (t == null) return null;
      final s = t.toString().trim();
      return s.isEmpty ? null : s;
    }();
    return tableType;
  }

  factory QueueOrder.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>?;

    return QueueOrder(
      orderId: json['orderId']?.toString() ?? '',
      orderNumber: json['orderNumber'] as String? ?? '',
      tableNumber: json['tableNumber']?.toString() ?? '0',
      tableType: parseTableTypeFromOrderJson(json),
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
