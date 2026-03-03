import 'package:flutter/material.dart';

import '../../l10n/generated/app_localizations.dart';
import '../models/profile_type.dart';
import 'nav_item.dart';

/// Bottom navigation configuration per profile type.
/// - Waiter: all 5 items (orders, preparing, reservations, menu, profile)
/// - Kitchen: 4 items (orders, preparing, menu, profile)
/// - Bar: 4 items (orders, preparing, menu, profile)
class NavConfig {
  const NavConfig._();

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

  static const profile = NavItem(
    label: 'PROFIL',
    icon: Icons.person,
    route: 'profile',
  );

  static List<NavItem> itemsFor(ProfileType type) {
    switch (type) {
      case ProfileType.waiter:
        return [orders, preparing, reservations, menu, profile];
      case ProfileType.kitchen:
      case ProfileType.bar:
        return [orders, preparing, menu, profile];
    }
  }

  /// Returns localized label for the given route.
  static String labelFor(AppLocalizations l10n, String route) {
    switch (route) {
      case 'orders':
        return l10n.navOrders;
      case 'preparing':
        return l10n.navPreparing;
      case 'reservations':
        return l10n.navReservations;
      case 'menu':
        return l10n.navMenu;
      case 'profile':
        return l10n.navProfile;
      default:
        return l10n.navOrders;
    }
  }
}
