/// Product nested inside a menu item (name, image, etc.).
class MenuProduct {
  const MenuProduct({
    required this.id,
    required this.name,
    this.description,
    this.imageUrl,
  });

  final String id;
  final String name;
  final String? description;
  final String? imageUrl;

  factory MenuProduct.fromJson(Map<String, dynamic> json) {
    return MenuProduct(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ??
          json['title'] as String? ??
          json['label'] as String? ??
          '',
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String? ?? json['image_url'] as String?,
    );
  }
}
