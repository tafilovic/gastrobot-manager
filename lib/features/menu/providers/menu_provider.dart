import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/menu/domain/models/menu_item.dart';
import 'package:gastrobotmanager/features/menu/domain/repositories/menus_api.dart';

/// Holds menu items (flattened from all categories), loading and error state.
/// Used by chef (type=food) and bartender (type=drinks).
class MenuProvider extends ChangeNotifier {
  MenuProvider(this._authProvider, this._menusApi);

  final AuthProvider _authProvider;
  final MenusApi _menusApi;

  List<MenuItem> _items = [];
  String? _menuId;
  bool _loading = false;
  String? _error;

  List<MenuItem> get items => List.unmodifiable(_items);
  bool get loading => _loading;
  String? get error => _error;

  int get availableCount => _items.where((i) => i.isAvailable).length;
  int get totalCount => _items.length;

  /// Loads menu. [menuType] should be 'food' for chef or 'drinks' for bartender.
  Future<void> load(String venueId, String menuType) async {
    _loading = true;
    _error = null;
    _menuId = null;
    notifyListeners();

    try {
      final menus = await _menusApi.getMenus(venueId, menuType);
      _items = menus.expand((m) => m.allItems).toList();
      _menuId = menus.isNotEmpty ? menus.first.id : null;
      _error = null;
    } catch (e) {
      _error = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      _items = [];
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  /// Toggles item availability via API and updates local state from response.
  /// On failure reverts local state, sets [error] and returns false.
  Future<bool> toggleAvailability(String menuItemId) async {
    final venueId = _authProvider.user?.venueUsers.isNotEmpty == true
        ? _authProvider.user!.venueUsers.first.venueId
        : null;
    final menuId = _menuId;

    if (venueId == null || menuId == null) return false;

    final index = _items.indexWhere((i) => i.id == menuItemId);
    if (index < 0) return false;

    final previous = _items[index].isAvailable;
    setItemAvailable(menuItemId, !previous);
    notifyListeners();

    try {
      final newAvailable = await _menusApi.toggleMenuItemAvailability(
        venueId,
        menuId,
        menuItemId,
      );
      setItemAvailable(menuItemId, newAvailable);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      setItemAvailable(menuItemId, previous);
      _error = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      notifyListeners();
      return false;
    }
  }

  void setItemAvailable(String itemId, bool available) {
    final index = _items.indexWhere((i) => i.id == itemId);
    if (index < 0) return;
    _items = List.from(_items);
    _items[index] = _items[index].copyWith(isAvailable: available);
  }
}
