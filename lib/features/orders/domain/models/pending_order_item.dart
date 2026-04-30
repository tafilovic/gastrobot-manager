Map<String, dynamic>? _stringKeyedMap(Object? value) {
  if (value is! Map) return null;
  return Map<String, dynamic>.from(value);
}

String? _normalizeItemType(String? raw) {
  final t = raw?.trim().toLowerCase();
  if (t == null || t.isEmpty) return null;
  if (t == 'drink' || t == 'beverage') return 'drink';
  if (t == 'food' || t == 'meal') return 'food';
  return null;
}

bool _isLikelyDrinkName(String name) {
  final n = name.toLowerCase();
  const drinkKeywords = <String>[
    'kafa',
    'coffee',
    'espresso',
    'cappuccino',
    'latte',
    'čaj',
    'caj',
    'tea',
    'matcha',
    'sok',
    'juice',
    'ceđena',
    'cedena',
    'narandža',
    'narandza',
    'cola',
    'coca',
    'fanta',
    'sprite',
    'water',
    'voda',
    'wine',
    'vino',
    'beer',
    'pivo',
    'rakija',
    'whiskey',
    'viski',
    'vodka',
    'gin',
    'tonic',
    'liker',
    'liqueur',
    'prosecco',
    'champagne',
    'šampanj',
    'sampanj',
  ];
  return drinkKeywords.any(n.contains);
}

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

    final menuItem = _stringKeyedMap(json['menuItem']);
    final product = _stringKeyedMap(menuItem?['product']);
    final category = _stringKeyedMap(product?['category']);

    final name = (json['name'] as String? ??
            json['productName'] as String? ??
            product?['name'] as String? ??
            '')
        .trim();

    var notes =
        (json['notes'] as String? ?? json['additionalInfo'] as String? ?? '')
            .trim();
    final rejectionReason = json['rejectionReason'] as String?;
    if (rejectionReason != null && rejectionReason.trim().isNotEmpty) {
      final rr = rejectionReason.trim();
      notes = notes.isEmpty ? rr : '$notes · $rr';
    }

    final quantity = json['quantity'] is int
        ? json['quantity'] as int
        : (int.tryParse(json['quantity']?.toString() ?? '1') ?? 1);

    final menuItemType = menuItem?['type']?.toString();
    final productType = product?['type']?.toString();
    final productCategory = _stringKeyedMap(product?['category']);
    final productCategoryType = productCategory?['type']?.toString();
    var type = _normalizeItemType(
      json['type']?.toString() ??
          category?['type']?.toString() ??
          menuItemType ??
          productType ??
          productCategoryType,
    );
    if (type == null && name.isNotEmpty) {
      type = _isLikelyDrinkName(name) ? 'drink' : 'food';
    }

    double? totalPrice;
    if (json['totalPrice'] != null) {
      if (json['totalPrice'] is num) {
        totalPrice = (json['totalPrice'] as num).toDouble();
      } else {
        totalPrice = double.tryParse(json['totalPrice'].toString());
      }
    } else if (json['priceAtOrder'] != null) {
      final unit = double.tryParse(json['priceAtOrder'].toString());
      if (unit != null) {
        totalPrice = unit * quantity;
      }
    } else if (json['unitPrice'] != null) {
      final unit = double.tryParse(json['unitPrice'].toString());
      if (unit != null) {
        totalPrice = unit * quantity;
      }
    } else if (menuItem != null && menuItem['price'] != null) {
      final mp = menuItem['price'];
      final unit = mp is num ? mp.toDouble() : double.tryParse(mp.toString());
      if (unit != null) {
        totalPrice = unit * quantity;
      }
    }

    return PendingOrderItem(
      id: id,
      name: name,
      quantity: quantity,
      notes: notes,
      status: json['status'] as String? ?? 'pending',
      addons: addonsList ?? const [],
      type: type,
      totalPrice: totalPrice,
    );
  }
}
