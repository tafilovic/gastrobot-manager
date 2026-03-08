/// Single item in a pending order (kitchen, bar, waiter).
/// [type] is 'food' | 'drink' for waiter; null otherwise.
class PendingOrderItem {
  const PendingOrderItem({
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
  final String? type;

  factory PendingOrderItem.fromJson(Map<String, dynamic> json) {
    final addonsList = json['addons'] as List<dynamic>?;
    final id = json['id']?.toString() ?? json['orderItemId']?.toString() ?? '';
    final name = json['name'] as String? ?? json['productName'] as String? ?? '';
    final notes = json['notes'] as String? ?? json['additionalInfo'] as String? ?? '';
    return PendingOrderItem(
      id: id,
      name: name,
      quantity: json['quantity'] is int ? json['quantity'] as int : (int.tryParse(json['quantity']?.toString() ?? '1') ?? 1),
      notes: notes,
      status: json['status'] as String? ?? 'pending',
      addons: addonsList ?? const [],
      type: json['type'] as String?,
    );
  }
}
