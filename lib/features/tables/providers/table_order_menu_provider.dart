import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/features/menu/domain/models/menu_category.dart';
import 'package:gastrobotmanager/features/menu/domain/models/menu_item.dart';
import 'package:gastrobotmanager/features/menu/domain/repositories/menus_api.dart';

/// Holds menu categories and items for the table order flow.
/// Loads both food and drinks menus and exposes categories as tabs.
class TableOrderMenuProvider extends ChangeNotifier {
  TableOrderMenuProvider(this._menusApi);

  final MenusApi _menusApi;

  List<MenuCategory> _categories = [];
  final Map<String, MenuItem> _itemsById = {};
  final Map<String, String> _itemCategoryType = {};
  bool _loading = false;
  String? _error;

  List<MenuCategory> get categories => List.unmodifiable(_categories);
  bool get loading => _loading;
  String? get error => _error;

  MenuItem? getItemById(String id) => _itemsById[id];
  String getItemCategoryType(String itemId) =>
      _itemCategoryType[itemId] ?? 'food';

  /// Loads food and drinks menus, exposes categories with items.
  Future<void> load(String venueId) async {
    _loading = true;
    _error = null;
    _categories = [];
    notifyListeners();

    try {
      final foodMenus = await _menusApi.getMenus(venueId, 'food');
      final drinksMenus = await _menusApi.getMenus(venueId, 'drinks');
      final allMenus = [...foodMenus, ...drinksMenus];

      _itemsById.clear();
      _itemCategoryType.clear();
      _categories = [];
      for (final m in allMenus) {
        final type = m.type == 'drinks' ? 'drinks' : 'food';
        for (final c in m.categories) {
          if (c.menuItems.isEmpty) continue;
          _categories.add(c);
          for (final item in c.menuItems) {
            _itemsById[item.id] = item;
            _itemCategoryType[item.id] = type;
          }
        }
      }
      _error = null;
    } catch (e) {
      _error = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      _categories = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Items for the given category index.
  List<MenuItem> itemsForCategory(int index) {
    if (index < 0 || index >= _categories.length) return [];
    return _categories[index].menuItems;
  }
}
