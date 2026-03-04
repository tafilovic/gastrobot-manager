import 'menu_product.dart';

/// Single menu item (price, availability, product) from API.
class MenuItem {
  const MenuItem({
    required this.id,
    required this.price,
    required this.isAvailable,
    required this.product,
  });

  final String id;
  final int price;
  final bool isAvailable;
  final MenuProduct product;

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    final productJson = json['product'] as Map<String, dynamic>?;
    return MenuItem(
      id: json['id'] as String,
      price: json['price'] as int? ?? 0,
      isAvailable: json['isAvailable'] as bool? ?? true,
      product: productJson != null
          ? MenuProduct.fromJson(productJson)
          : const MenuProduct(id: '', name: ''),
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
