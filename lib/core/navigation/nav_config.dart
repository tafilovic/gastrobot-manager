import 'package:flutter/material.dart';
import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/navigation/nav_item.dart';

/// Bottom navigation configuration per profile type (routes and icons only).
/// Localized labels are resolved in the presentation layer.
/// - Waiter: all 5 items (orders, preparing, reservations, menu, profile)
/// - Kitchen: 4 items (orders, preparing, menu, profile)
/// - Bar: 4 items (orders, preparing, drinks tab → menu route, profile).
class NavConfig {
  const NavConfig._();

  static const ready = NavItem(
    label: "SPREMNO",
    icon: Icons.done_all,
    route: "ready",
    svgAssetPath: 'assets/icons/ready.svg',
  );

  static const orders = NavItem(
    label: 'PORUDŽBINE',
    icon: Icons.receipt_long,
    route: 'orders',
    svgAssetPath: 'assets/icons/orders.svg',
  );

  static const preparing = NavItem(
    label: 'U PRIPREMI',
    icon: Icons.pending_actions,
    route: 'preparing',
    svgAssetPath: 'assets/icons/preparing.svg',
  );

  static const reservations = NavItem(
    label: 'REZERVACIJE',
    icon: Icons.calendar_today,
    route: 'reservations',
    svgAssetPath: 'assets/icons/reservations.svg',
  );

  static const menu = NavItem(
    label: 'JELOVNIK',
    icon: Icons.restaurant_menu,
    route: 'menu',
    svgAssetPath: 'assets/icons/menu.svg',
  );

  /// Same route as [menu]; shell uses drink-card label and bar icon for bartender.
  static const menuDrinks = NavItem(
    label: 'KARTA PIĆA',
    icon: Icons.local_bar,
    route: 'menu',
    svgAssetPath: 'assets/icons/wine_glasses.svg',
  );

  static const drinks = NavItem(
    label: 'PIĆA',
    icon: Icons.local_bar,
    route: 'drinks',
    svgAssetPath: 'assets/icons/wine_glasses.svg',
  );

  static const tables = NavItem(
    label: 'ZONE',
    icon: Icons.table_restaurant,
    route: 'tables',
    svgAssetPath: 'assets/icons/table.svg',
  );

  static const profile = NavItem(
    label: 'PROFIL',
    icon: Icons.person,
    route: 'profile',
    svgAssetPath: 'assets/icons/profile.svg',
  );

  static List<NavItem> itemsFor(ProfileType type) {
    switch (type) {
      case ProfileType.waiter:
        return [ready, orders, reservations, tables, profile];
      case ProfileType.kitchen:
        return [orders, preparing, reservations, menu, profile];
      case ProfileType.bar:
        return [orders, preparing, reservations, menuDrinks, profile];
    }
  }
}
