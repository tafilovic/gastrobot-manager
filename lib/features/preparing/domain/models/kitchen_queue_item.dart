/// Single item in a kitchen queue (preparing) order.
class KitchenQueueItem {
  const KitchenQueueItem({
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

  factory KitchenQueueItem.fromJson(Map<String, dynamic> json) {
    final addonsList = json['addons'] as List<dynamic>?;
    return KitchenQueueItem(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      notes: json['notes'] as String? ?? '',
      status: json['status'] as String? ?? 'accepted',
      addons: addonsList ?? const [],
    );
  }
}
