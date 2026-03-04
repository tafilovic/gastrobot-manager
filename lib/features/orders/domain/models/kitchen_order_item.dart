/// Single item in a kitchen pending order.
class KitchenOrderItem {
  const KitchenOrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.notes,
    required this.status,
    this.addons = const [],
  });

  final String id;
  final String name;
  final int quantity;
  final String notes;
  final String status;
  final List<dynamic> addons;

  factory KitchenOrderItem.fromJson(Map<String, dynamic> json) {
    final addonsList = json['addons'] as List<dynamic>?;
    return KitchenOrderItem(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      notes: json['notes'] as String? ?? '',
      status: json['status'] as String? ?? 'pending',
      addons: addonsList ?? const [],
    );
  }
}
