import 'pending_order_item.dart';

/// Pending order from kitchen/pending or bar/pending.
class PendingOrder {
  const PendingOrder({
    required this.orderId,
    required this.orderNumber,
    required this.tableNumber,
    this.tableId,
    this.tableType,
    this.note,
    required this.orderType,
    required this.targetTime,
    this.reservationDetails,
    this.items = const [],
  });

  final String orderId;
  final String orderNumber;
  final String tableNumber;

  /// Venue table id when the API sends it; used for filters (distinct from [tableNumber]).
  final String? tableId;

  /// Venue table kind: `table` | `room` | `sunbed` (from nested `table` or order fields).
  final String? tableType;
  final String? note;
  final String orderType;
  final String targetTime;
  final dynamic reservationDetails;
  final List<PendingOrderItem> items;

  /// Total number of items in this order.
  int get itemCount => items.fold<int>(0, (sum, i) => sum + i.quantity);

  factory PendingOrder.fromJson(Map<String, dynamic> json) {
    final itemsList = json['items'] as List<dynamic>?;
    final orderItemsList = json['orderItems'] as List<dynamic>?;
    final rawItems = (orderItemsList != null && orderItemsList.isNotEmpty)
        ? orderItemsList
        : (itemsList ?? const <dynamic>[]);
    final orderType =
        (json['orderType'] ?? json['type']) as String? ?? 'walk_in';
    final tableNum = json['tableNumber']?.toString() ??
        json['tableName']?.toString() ??
        json['tableNum']?.toString();
    final tableNumber =
        (tableNum == null || tableNum.isEmpty || tableNum == 'N/A')
            ? '0'
            : tableNum;

    String? tableId;
    final rawTableId = json['tableId'] ??
        json['table_id'] ??
        json['venueTableId'] ??
        json['venue_table_id'];
    if (rawTableId != null && rawTableId.toString().trim().isNotEmpty) {
      tableId = rawTableId.toString().trim();
    }
    String? tableType;
    final tableObj = json['table'];
    if (tableObj is Map) {
      final m = Map<String, dynamic>.from(tableObj);
      if (tableId == null) {
        final nested = m['id'] ?? m['_id'];
        if (nested != null && nested.toString().trim().isNotEmpty) {
          tableId = nested.toString().trim();
        }
      }
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

    final orderId =
        json['orderId']?.toString() ?? json['id']?.toString() ?? '';

    var orderNumber =
        json['orderNumber'] as String? ?? json['number']?.toString() ?? '';
    if (orderNumber.isEmpty && orderId.isNotEmpty) {
      orderNumber = _compactOrderNumberChip(orderId);
    }

    var targetTime = json['targetTime'] as String? ?? '';
    if (targetTime.isEmpty) {
      targetTime = json['createdAt']?.toString() ??
          json['updatedAt']?.toString() ??
          '';
    }

    return PendingOrder(
      orderId: orderId,
      orderNumber: orderNumber,
      tableNumber: tableNumber,
      tableId: tableId,
      tableType: tableType,
      note: json['note'] as String?,
      orderType: orderType,
      targetTime: targetTime,
      reservationDetails: json['reservationDetails'],
      items: rawItems
          .map((e) => PendingOrderItem.fromJson(
                e is Map ? Map<String, dynamic>.from(e) : <String, dynamic>{},
              ))
          .toList(),
    );
  }

  /// Short label when the API omits [orderNumber] (e.g. table orders use `id` only).
  static String _compactOrderNumberChip(String orderId) {
    final compact = orderId.replaceAll('-', '');
    if (compact.isEmpty) {
      return '';
    }
    final take = compact.length >= 7 ? 7 : compact.length;
    return compact.substring(0, take).toUpperCase();
  }
}
