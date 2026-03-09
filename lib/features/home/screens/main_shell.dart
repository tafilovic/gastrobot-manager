import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/app_breakpoints.dart';
import 'package:gastrobotmanager/core/navigation/app_router.dart';
import 'package:gastrobotmanager/core/navigation/nav_config.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/home/widgets/app_bottom_nav.dart';
import 'package:gastrobotmanager/features/home/widgets/app_navigation_rail.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Main shell with bottom navigation. Items depend on [ProfileType].
/// Presentation layer: resolves localized nav labels from [AppLocalizations].
class MainShell extends StatelessWidget {
  const MainShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  static String _navLabel(AppLocalizations l10n, String route) {
    switch (route) {
      case 'orders':
        return l10n.navOrders;
      case 'ready':
        return l10n.navReady;
      case 'preparing':
        return l10n.navPreparing;
      case 'reservations':
        return l10n.navReservations;
      case 'menu':
        return l10n.navMenu;
      case 'drinks':
        return l10n.navDrinks;
      case 'profile':
        return l10n.navProfile;
      default:
        return l10n.navOrders;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final profileType = auth.profileType!;
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final items = NavConfig.itemsFor(profileType);

    int selectedIndex = 0;
    for (var i = 0; i < items.length; i++) {
      final route = items[i].route;
      switch (route) {
        case 'ready':
          if (currentLocation.startsWith('/ready')) selectedIndex = i;
          break;
        case 'orders':
          if (currentLocation.startsWith('/orders')) selectedIndex = i;
          break;
        case 'preparing':
          if (currentLocation.startsWith('/preparing')) selectedIndex = i;
          break;
        case 'reservations':
          if (currentLocation.startsWith('/reservations')) selectedIndex = i;
          break;
        case 'menu':
          if (currentLocation.startsWith('/menu')) selectedIndex = i;
          break;
        case 'drinks':
          if (currentLocation.startsWith('/drinks')) selectedIndex = i;
          break;
        case 'profile':
          if (currentLocation.startsWith('/profile')) selectedIndex = i;
          break;
      }
    }

    final width = MediaQuery.sizeOf(context).width;
    final useRail = width >= AppBreakpoints.compact;
    final labels = items.map((i) => _navLabel(l10n, i.route)).toList();

    if (useRail) {
      return Scaffold(
        body: Row(
          children: [
            AppNavigationRail(
              items: items,
              labels: labels,
              selectedIndex: selectedIndex,
              onDestinationSelected: (i) {
                final target = items[i].route;
                _goToBranch(context, target);
              },
            ),
            Expanded(child: navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: AppBottomNav(
        items: items,
        labels: labels,
        selectedIndex: selectedIndex,
        onDestinationSelected: (i) {
          final target = items[i].route;
          _goToBranch(context, target);
        },
      ),
    );
  }

  void _goToBranch(BuildContext context, String route) {
    switch (route) {
      case 'ready':
        context.goNamed(AppRouteNames.ready);
        break;
      case 'orders':
        context.goNamed(AppRouteNames.orders);
        break;
      case 'preparing':
        context.goNamed(AppRouteNames.preparing);
        break;
      case 'reservations':
        context.goNamed(AppRouteNames.reservations);
        break;
      case 'menu':
        context.goNamed(AppRouteNames.menu);
        break;
      case 'drinks':
        context.goNamed(AppRouteNames.drinks);
        break;
      case 'profile':
        context.goNamed(AppRouteNames.profile);
        break;
      default:
        context.goNamed(AppRouteNames.orders);
        break;
    }
  }
}
