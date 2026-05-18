import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/core/navigation/nav_route_keys.dart';
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
      case NavRouteKeys.orders:
        return _hasUnreadOrders;
      case NavRouteKeys.reservations:
        return _hasUnreadReservations;
      default:
        return false;
    }
  }

  void setActiveRoute(String routeKey) {
    final wasActiveRoute = _activeRouteKey == routeKey;
    _activeRouteKey = routeKey;
    final clearedBadge = _clearBadgeForRoute(routeKey);
    if (!wasActiveRoute || clearedBadge) {
      notifyListeners();
    }
  }

  void markUnread(NotificationRefreshTarget target) {
    switch (target) {
      case NotificationRefreshTarget.orders:
        if (_activeRouteKey == NavRouteKeys.orders) return;
        if (!_hasUnreadOrders) {
          _hasUnreadOrders = true;
          notifyListeners();
        }
      case NotificationRefreshTarget.reservations:
        if (_activeRouteKey == NavRouteKeys.reservations) return;
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

  bool _clearBadgeForRoute(String routeKey) {
    switch (routeKey) {
      case NavRouteKeys.orders:
        if (!_hasUnreadOrders) return false;
        _hasUnreadOrders = false;
        return true;
      case NavRouteKeys.reservations:
        if (!_hasUnreadReservations) return false;
        _hasUnreadReservations = false;
        return true;
      default:
        return false;
    }
  }
}
