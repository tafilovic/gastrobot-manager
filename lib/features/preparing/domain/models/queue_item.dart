/// Single item in a queue (preparing) order.
/// [type] is set for waiter ready-items ('food' | 'drink'); null for kitchen/bar.
Map<String, dynamic>? _stringKeyedMap(Object? value) {
  if (value is! Map) return null;
  return Map<String, dynamic>.from(value);
}

class QueueItem {
  const QueueItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.notes,
    required this.status,
    this.addons = const [],
    this.type,
  });

  final String id;
  final String name;
  final int quantity;
  final String notes;
  final String status;
  final List<dynamic> addons;
  /// 'food' | 'drink' for waiter ready-items; null otherwise.
  final String? type;

  factory QueueItem.fromJson(Map<String, dynamic> json) {
    final addonsList = json['addons'] as List<dynamic>?;
    final menuItem = _stringKeyedMap(json['menuItem']);
    final product = _stringKeyedMap(menuItem?['product']);
    return QueueItem(
      id: json['id']?.toString() ?? '',
      name: (json['productName'] as String? ??
              json['name'] as String? ??
              product?['name'] as String? ??
              '')
          .trim(),
      quantity: json['quantity'] as int? ?? 1,
      notes: json['notes'] as String? ?? '',
      status: json['status'] as String? ?? 'accepted',
      addons: addonsList ?? const [],
      type: json['type'] as String?,
    );
  }
}
