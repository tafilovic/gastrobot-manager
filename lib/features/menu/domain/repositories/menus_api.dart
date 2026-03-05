import 'package:gastrobotmanager/features/menu/domain/models/venue_menu.dart';

/// Contract for fetching venue menus (food or drinks) and toggling item availability.
abstract class MenusApi {
  /// Fetches menus for the venue. [menuType] is 'food' for chef or 'drinks' for bartender.
  Future<List<VenueMenu>> getMenus(String venueId, String menuType);

  /// Toggles menu item availability. Returns the new [isAvailable] from response.
  /// PATCH /venues/{venueId}/menus/{menuId}/menu-items/{menuItemId}/toggle-availability
  Future<bool> toggleMenuItemAvailability(
    String venueId,
    String menuId,
    String menuItemId,
  );
}
