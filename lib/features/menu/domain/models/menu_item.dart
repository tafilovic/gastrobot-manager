import 'package:decimal/decimal.dart';

import 'package:gastrobotmanager/core/currency/parse_money_amount.dart';
import 'package:gastrobotmanager/features/menu/domain/models/menu_product.dart';

/// Single menu item (price, availability, product) from API.
class MenuItem {
  const MenuItem({
    required this.id,
    required this.price,
    required this.isAvailable,
    required this.product,
  });

  final String id;
  /// Major currency units from the API (e.g. `199.99`); exact [Decimal], not float.
  final Decimal price;
  final bool isAvailable;
  final MenuProduct product;

  static Decimal _linePriceFromJson(Map<String, dynamic> json) {
    if (json['price'] != null) {
      return parseMoneyAmount(json['price']);
    }
    final comboRaw = json['combo'];
    if (comboRaw is Map) {
      final c = Map<String, dynamic>.from(comboRaw);
      if (c['price'] != null) {
        return parseMoneyAmount(c['price']);
      }
    }
    return Decimal.zero;
  }

  static bool _parseAvailable(Map<String, dynamic> json) {
    final v = json['isAvailable'] ?? json['is_available'] ?? json['available'];
    if (v is bool) return v;
    if (v is String) {
      final s = v.toLowerCase();
      if (s == 'true' || s == '1') return true;
      if (s == 'false' || s == '0') return false;
    }
    if (v is int) return v != 0;
    return true;
  }

  static String? _firstComboProductImageUrl(Map<String, dynamic> combo) {
    final products = combo['products'];
    if (products is! List<dynamic>) return null;
    for (final e in products) {
      if (e is! Map) continue;
      final m = Map<String, dynamic>.from(e);
      final url = m['imageUrl'] as String? ?? m['image_url'] as String?;
      if (url != null && url.isNotEmpty) return url;
    }
    return null;
  }

  static MenuProduct _productFromCombo(
    Map<String, dynamic> combo,
    String menuItemIdFallback,
  ) {
    final name = combo['name'] as String? ?? '';
    final id = combo['id']?.toString() ?? menuItemIdFallback;
    final imageUrl = combo['imageUrl'] as String? ??
        combo['image_url'] as String? ??
        _firstComboProductImageUrl(combo);
    String? description;
    final products = combo['products'];
    if (products is List<dynamic> && products.isNotEmpty) {
      final first = products.first;
      if (first is Map) {
        description = first['description'] as String?;
      }
    }
    return MenuProduct(
      id: id,
      name: name,
      description: description,
      imageUrl: imageUrl,
    );
  }

  static MenuProduct _productFromMenuItemJson(Map<String, dynamic> json) {
    final nested = json['product'];
    if (nested is Map) {
      return MenuProduct.fromJson(Map<String, dynamic>.from(nested));
    }
    final comboRaw = json['combo'];
    if (comboRaw is Map) {
      return _productFromCombo(
        Map<String, dynamic>.from(comboRaw),
        json['id']?.toString() ?? '',
      );
    }
    final name = json['productName'] as String? ??
        json['product_name'] as String? ??
        json['name'] as String? ??
        json['title'] as String? ??
        '';
    final productId = json['productId']?.toString() ??
        json['product_id']?.toString() ??
        json['id']?.toString() ??
        '';
    return MenuProduct(
      id: productId,
      name: name,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
    );
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id']?.toString() ?? '',
      price: _linePriceFromJson(json),
      isAvailable: _parseAvailable(json),
      product: _productFromMenuItemJson(json),
    );
  }

  MenuItem copyWith({bool? isAvailable}) {
    return MenuItem(
      id: id,
      price: price,
      isAvailable: isAvailable ?? this.isAvailable,
      product: product,
    );
  }
}
