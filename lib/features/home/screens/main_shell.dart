import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/app_breakpoints.dart';
import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/navigation/app_router.dart';
import 'package:gastrobotmanager/core/navigation/nav_config.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/home/widgets/app_bottom_nav.dart';
import 'package:gastrobotmanager/features/home/widgets/app_navigation_rail.dart';
import 'package:gastrobotmanager/features/orders/providers/orders_provider.dart';
import 'package:gastrobotmanager/features/preparing/providers/queue_provider.dart';
import 'package:gastrobotmanager/features/ready_items/providers/ready_items_provider.dart';
import 'package:gastrobotmanager/features/reservations/providers/reservations_provider.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Main shell with bottom navigation. Items depend on [ProfileType].
/// Presentation layer: resolves localized nav labels from [AppLocalizations].
class MainShell extends StatefulWidget {
  const MainShell({super.key, required this.navigationShell});

  final StatefulNavigationShell navigationShell;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> with WidgetsBindingObserver {
  static const Duration _refreshInterval = Duration(seconds: 60);

  Timer? _refreshTimer;
  String? _activeRouteKey;

  static String _navLabel(
    AppLocalizations l10n,
    String route,
    ProfileType profileType,
  ) {
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
        return profileType == ProfileType.bar
            ? l10n.navDrinks
            : l10n.navMenu;
      case 'drinks':
        return l10n.navDrinks;
      case 'tables':
        return l10n.navZones;
      case 'profile':
        return l10n.navProfile;
      default:
        return l10n.navOrders;
    }
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      if (_activeRouteKey != null && mounted) {
        final auth = context.read<AuthProvider>();
        final venueId = auth.currentVenueId;
        if (venueId != null) {
          _startRefreshTimer(context, _activeRouteKey!);
        }
      }
    } else if (state == AppLifecycleState.inactive ||
        state == AppLifecycleState.paused ||
        state == AppLifecycleState.detached) {
      _refreshTimer?.cancel();
      _refreshTimer = null;
    }
  }

  void _startRefreshTimer(BuildContext context, String routeKey) {
    _refreshTimer?.cancel();
    _activeRouteKey = routeKey;

    // Only these tabs have periodic refresh.
    final refreshableKeys = {'orders', 'ready', 'preparing', 'reservations'};
    if (!refreshableKeys.contains(routeKey)) {
      return;
    }

    final auth = context.read<AuthProvider>();
    final venueId = auth.currentVenueId;
    if (venueId == null) return;

    _triggerLoad(context, routeKey, venueId);

    _refreshTimer = Timer.periodic(_refreshInterval, (_) {
      final currentVenueId = auth.currentVenueId;
      if (currentVenueId == null) return;
      _triggerLoad(context, routeKey, currentVenueId);
    });
  }

  void _triggerLoad(BuildContext context, String routeKey, String venueId) {
    switch (routeKey) {
      case 'orders':
        context.read<OrdersProvider>().loadOnce(venueId);
        break;
      case 'ready':
        context.read<ReadyItemsProvider>().loadOnce(venueId);
        break;
      case 'preparing':
        context.read<QueueProvider>().loadOnce(venueId);
        break;
      case 'reservations':
        context.read<ReservationsProvider>().loadOnce(venueId);
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final profileType = auth.profileType;

    if (auth.isRestoring || profileType == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    final currentLocation = GoRouterState.of(context).matchedLocation;
    final items = NavConfig.itemsFor(profileType);

    int selectedIndex = 0;
    for (var i = 0; i < items.length; i++) {
      final route = items[i].route;
      switch (route) {
        case 'ready':
          if (currentLocation.startsWith(AppRouteNames.pathReady)) selectedIndex = i;
          break;
        case 'orders':
          if (currentLocation.startsWith(AppRouteNames.pathOrders)) selectedIndex = i;
          break;
        case 'preparing':
          if (currentLocation.startsWith(AppRouteNames.pathPreparing)) selectedIndex = i;
          break;
        case 'reservations':
          if (currentLocation.startsWith(AppRouteNames.pathReservations)) selectedIndex = i;
          break;
        case 'menu':
          if (currentLocation.startsWith(AppRouteNames.pathMenu)) selectedIndex = i;
          break;
        case 'drinks':
          if (currentLocation.startsWith(AppRouteNames.pathDrinks)) selectedIndex = i;
          break;
        case 'tables':
          if (currentLocation.startsWith(AppRouteNames.pathTables)) selectedIndex = i;
          break;
        case 'profile':
          if (currentLocation.startsWith(AppRouteNames.pathProfile)) selectedIndex = i;
          break;
      }
    }

    final selectedRouteKey = items[selectedIndex].route;

    if (selectedRouteKey != _activeRouteKey) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _startRefreshTimer(context, selectedRouteKey);
      });
    }

    final width = MediaQuery.sizeOf(context).width;
    final useRail = width >= AppBreakpoints.compact;
    final labels =
        items.map((i) => _navLabel(l10n, i.route, profileType)).toList();

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
            Expanded(child: widget.navigationShell),
          ],
        ),
      );
    }

    return Scaffold(
      body: widget.navigationShell,
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
      case 'tables':
        context.goNamed(AppRouteNames.tables);
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
