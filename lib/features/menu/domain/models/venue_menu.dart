import 'package:gastrobotmanager/features/menu/domain/models/menu_category.dart';
import 'package:gastrobotmanager/features/menu/domain/models/menu_item.dart';

/// Venue menu (food or drinks) with categories.
class VenueMenu {
  const VenueMenu({
    required this.id,
    required this.name,
    required this.type,
    this.categories = const [],
  });

  final String id;
  final String name;
  final String type;
  final List<MenuCategory> categories;

  factory VenueMenu.fromJson(Map<String, dynamic> json) {
    final categoriesList = json['categories'] as List<dynamic>? ??
        json['menuCategories'] as List<dynamic>? ??
        json['sections'] as List<dynamic>?;
    return VenueMenu(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      type: json['type'] as String? ??
          json['menuType'] as String? ??
          'food',
      categories: categoriesList
              ?.whereType<Map>()
              .map((e) => MenuCategory.fromJson(Map<String, dynamic>.from(e)))
              .toList() ??
          const [],
    );
  }

  /// All menu items flattened from all categories.
  List<MenuItem> get allItems {
    return [
      for (final c in categories) ...c.menuItems,
    ];
  }
}
