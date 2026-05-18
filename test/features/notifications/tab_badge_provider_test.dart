import 'package:flutter_test/flutter_test.dart';
import 'package:gastrobotmanager/core/navigation/nav_route_keys.dart';
import 'package:gastrobotmanager/features/notifications/domain/notification_refresh_target.dart';
import 'package:gastrobotmanager/features/notifications/providers/tab_badge_provider.dart';

void main() {
  test('markUnread sets orders flag when not on orders tab', () {
    final provider = TabBadgeProvider();
    provider.setActiveRoute(NavRouteKeys.ready);
    provider.markUnread(NotificationRefreshTarget.orders);
    expect(provider.hasUnreadOrders, isTrue);
    expect(provider.showUnreadForRoute(NavRouteKeys.orders), isTrue);
  });

  test('setActiveRoute clears badge for that route', () {
    final provider = TabBadgeProvider();
    provider.markUnread(NotificationRefreshTarget.reservations);
    provider.setActiveRoute(NavRouteKeys.reservations);
    expect(provider.hasUnreadReservations, isFalse);
  });

  test('markUnread does not set flag when already on tab', () {
    final provider = TabBadgeProvider();
    provider.setActiveRoute(NavRouteKeys.orders);
    provider.markUnread(NotificationRefreshTarget.orders);
    expect(provider.hasUnreadOrders, isFalse);
  });

  test('setActiveRoute clears badge even when route is already active', () {
    final provider = TabBadgeProvider();
    provider.setActiveRoute(NavRouteKeys.orders);
    provider.markUnread(NotificationRefreshTarget.orders);
    provider.setActiveRoute(NavRouteKeys.orders);
    expect(provider.hasUnreadOrders, isFalse);
  });
}
