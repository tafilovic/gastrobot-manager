import 'package:flutter/material.dart';
import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/navigation/nav_item.dart';

/// Bottom navigation configuration per profile type (routes and icons only).
/// Localized labels are resolved in the presentation layer.
/// - Waiter: all 5 items (orders, preparing, reservations, menu, profile)
/// - Kitchen: 4 items (orders, preparing, menu, profile)
/// - Bar: 4 items (orders, preparing, menu, profile)
class NavConfig {
  const NavConfig._();

  static const ready = NavItem(
    label: "SPREMNO",
    icon: Icons.done_all,
    route: "ready",
  );

  static const orders = NavItem(
    label: 'PORUDŽBINE',
    icon: Icons.receipt_long,
    route: 'orders',
  );

  static const preparing = NavItem(
    label: 'U PRIPREMI',
    icon: Icons.pending_actions,
    route: 'preparing',
  );

  static const reservations = NavItem(
    label: 'REZERVACIJE',
    icon: Icons.calendar_today,
    route: 'reservations',
  );

  static const menu = NavItem(
    label: 'JELOVNIK',
    icon: Icons.restaurant_menu,
    route: 'menu',
  );

  static const drinks = NavItem(
    label: 'PIĆA',
    icon: Icons.local_bar,
    route: 'drinks',
  );

  static const profile = NavItem(
    label: 'PROFIL',
    icon: Icons.person,
    route: 'profile',
  );

  static List<NavItem> itemsFor(ProfileType type) {
    switch (type) {
      case ProfileType.waiter:
        return [ready, orders, reservations, drinks, profile];
      case ProfileType.kitchen:
      case ProfileType.bar:
        return [orders, preparing, reservations, menu, profile];
    }
  }
}
