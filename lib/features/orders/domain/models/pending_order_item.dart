/// Single item in a pending order (kitchen, bar, waiter).
/// [type] is 'food' | 'drink' for waiter; null otherwise.
/// [totalPrice] when present (from API) is used to compute order bill total.
class PendingOrderItem {
  const PendingOrderItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.notes,
    required this.status,
    this.addons = const [],
    this.type,
    this.totalPrice,
  });

  final String id;
  final String name;
  final int quantity;
  final String notes;
  final String status;
  final List<dynamic> addons;
  final String? type;
  /// Item line total (e.g. unitPrice * quantity). Used to compute order total.
  final double? totalPrice;

  factory PendingOrderItem.fromJson(Map<String, dynamic> json) {
    final addonsList = json['addons'] as List<dynamic>?;
    final id = json['id']?.toString() ?? json['orderItemId']?.toString() ?? '';
    final name = (json['name'] as String? ?? json['productName'] as String? ?? '').trim();
    final notes = (json['notes'] as String? ?? json['additionalInfo'] as String? ?? '').trim();
    double? totalPrice;
    if (json['totalPrice'] != null) {
      if (json['totalPrice'] is num) {
        totalPrice = (json['totalPrice'] as num).toDouble();
      } else {
        totalPrice = double.tryParse(json['totalPrice'].toString());
      }
    } else if (json['unitPrice'] != null) {
      final qty = json['quantity'] is int
          ? json['quantity'] as int
          : (int.tryParse(json['quantity']?.toString() ?? '1') ?? 1);
      final unit = double.tryParse(json['unitPrice'].toString());
      if (unit != null) totalPrice = unit * qty;
    }
    return PendingOrderItem(
      id: id,
      name: name,
      quantity: json['quantity'] is int ? json['quantity'] as int : (int.tryParse(json['quantity']?.toString() ?? '1') ?? 1),
      notes: notes,
      status: json['status'] as String? ?? 'pending',
      addons: addonsList ?? const [],
      type: json['type'] as String?,
      totalPrice: totalPrice,
    );
  }
}
