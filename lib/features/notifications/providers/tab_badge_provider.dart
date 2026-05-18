import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/features/notifications/domain/notification_refresh_target.dart';

/// Unread indicators on bottom nav / rail for orders and reservations.
class TabBadgeProvider extends ChangeNotifier {
  bool _hasUnreadOrders = false;
  bool _hasUnreadReservations = false;
  String? _activeRouteKey;

  bool get hasUnreadOrders => _hasUnreadOrders;
  bool get hasUnreadReservations => _hasUnreadReservations;
  String? get activeRouteKey => _activeRouteKey;

  bool showUnreadForRoute(String route) {
    switch (route) {
      case 'orders':
        return _hasUnreadOrders;
      case 'reservations':
        return _hasUnreadReservations;
      default:
        return false;
    }
  }

  void setActiveRoute(String routeKey) {
    if (_activeRouteKey == routeKey) return;
    _activeRouteKey = routeKey;
    _clearBadgeForRoute(routeKey);
    notifyListeners();
  }

  void markUnread(NotificationRefreshTarget target) {
    switch (target) {
      case NotificationRefreshTarget.orders:
        if (_activeRouteKey == 'orders') return;
        if (!_hasUnreadOrders) {
          _hasUnreadOrders = true;
          notifyListeners();
        }
      case NotificationRefreshTarget.reservations:
        if (_activeRouteKey == 'reservations') return;
        if (!_hasUnreadReservations) {
          _hasUnreadReservations = true;
          notifyListeners();
        }
      case NotificationRefreshTarget.none:
        break;
    }
  }

  void clearOrders() {
    if (!_hasUnreadOrders) return;
    _hasUnreadOrders = false;
    notifyListeners();
  }

  void clearReservations() {
    if (!_hasUnreadReservations) return;
    _hasUnreadReservations = false;
    notifyListeners();
  }

  void _clearBadgeForRoute(String routeKey) {
    switch (routeKey) {
      case 'orders':
        clearOrders();
      case 'reservations':
        clearReservations();
      default:
        break;
    }
  }
}
