import 'package:gastrobotmanager/core/log/app_logger.dart';

class NavigationLogger {
  const NavigationLogger._();

  static String? _lastLoggedLocation;

  static void logOpened(String location) {
    if (location == _lastLoggedLocation) return;
    _lastLoggedLocation = location;
    debugLog('Opened component: ${_componentName(location)} ($location)');
  }

  static String _componentName(String location) {
    if (location == '/login') return 'LoginScreen';
    if (location == '/register') return 'RegisterScreen';
    if (location.startsWith('/ready')) return 'ReadyItemsScreen';
    if (location == '/orders') return 'OrdersScreen';
    if (location.startsWith('/orders/active')) {
      return 'ActiveOrderDetailsScreen';
    }
    if (location.startsWith('/orders/history')) {
      return 'HistoryOrderDetailsScreen';
    }
    if (location.startsWith('/orders/time-estimation')) {
      return 'TimeEstimationScreen';
    }
    if (location.startsWith('/orders/details')) return 'OrderDetailsScreen';
    if (location.startsWith('/orders/filter/active')) {
      return 'FilterActiveOrdersScreen';
    }
    if (location.startsWith('/orders/filter/history')) {
      return 'FilterHistoryOrdersScreen';
    }
    if (location.startsWith('/preparing')) return 'PreparingScreen';
    if (location.startsWith('/reservations/filter/active')) {
      return 'ActiveReservationsFilterScreen';
    }
    if (location.startsWith('/reservations')) return 'ReservationsScreen';
    if (location.startsWith('/zones/overview/filter-orders')) {
      return 'FilterZoneOrdersScreen';
    }
    if (location.startsWith('/zones/overview')) return 'ZoneOverviewScreen';
    if (location.startsWith('/zones/order')) return 'ZoneOrderScreen';
    if (location.startsWith('/zones')) return 'ZonesScreen';
    if (location.startsWith('/menu')) return 'MenuScreen';
    if (location.startsWith('/drinks')) return 'MenuScreen';
    if (location.startsWith('/profile')) return 'ProfileScreen';
    if (location == '/') return 'RootRedirect';
    return 'UnknownScreen';
  }
}
