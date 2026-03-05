import 'package:gastrobotmanager/features/menu/domain/models/menu_item.dart';

/// Menu category (e.g. "GLAVNA JELA") with its items.
class MenuCategory {
  const MenuCategory({
    required this.id,
    required this.name,
    this.menuItems = const [],
  });

  final String id;
  final String name;
  final List<MenuItem> menuItems;

  factory MenuCategory.fromJson(Map<String, dynamic> json) {
    final itemsList = json['menuItems'] as List<dynamic>?;
    return MenuCategory(
      id: json['id'] as String,
      name: json['name'] as String? ?? '',
      menuItems: itemsList
              ?.map((e) => MenuItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
    );
  }
}
