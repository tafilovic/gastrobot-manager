/// Single item in a queue (preparing) order.
/// [type] is set for waiter ready-items ('food' | 'drink'); null for kitchen/bar.
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
    return QueueItem(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      notes: json['notes'] as String? ?? '',
      status: json['status'] as String? ?? 'accepted',
      addons: addonsList ?? const [],
      type: json['type'] as String?,
    );
  }
}
