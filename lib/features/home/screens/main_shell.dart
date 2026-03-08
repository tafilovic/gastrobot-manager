import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/app_breakpoints.dart';
import 'package:gastrobotmanager/core/navigation/nav_config.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/home/widgets/app_bottom_nav.dart';
import 'package:gastrobotmanager/features/home/widgets/app_navigation_rail.dart';
import 'package:gastrobotmanager/features/menu/screens/menu_screen.dart';
import 'package:gastrobotmanager/features/orders/screens/orders_screen.dart';
import 'package:gastrobotmanager/features/preparing/screens/preparing_screen.dart';
import 'package:gastrobotmanager/features/profile/screens/profile_screen.dart';
import 'package:gastrobotmanager/features/ready_items/screens/ready_items_screen.dart';
import 'package:gastrobotmanager/features/reservations/screens/reservations_screen.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Main shell with bottom navigation. Items depend on [ProfileType].
/// Presentation layer: resolves localized nav labels from [AppLocalizations].
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

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

  Widget _buildPage(String route) {
    switch (route) {
      case 'orders':
        return const OrdersScreen();
      case 'ready':
        return const ReadyItemsScreen();
      case 'preparing':
        return const PreparingScreen();
      case 'reservations':
        return const ReservationsScreen();
      case 'menu':
      case 'drinks':
        return const MenuScreen();
      case 'profile':
        return const ProfileScreen();
      default:
        return const OrdersScreen();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final auth = context.watch<AuthProvider>();
    final profileType = auth.profileType!;
    final items = NavConfig.itemsFor(profileType);

    // Clamp index if profile changed and current index is out of range
    final safeIndex = _selectedIndex >= items.length ? 0 : _selectedIndex;
    if (safeIndex != _selectedIndex) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        setState(() => _selectedIndex = safeIndex);
      });
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
              selectedIndex: safeIndex,
              onDestinationSelected: (i) => setState(() => _selectedIndex = i),
            ),
            Expanded(
              child: IndexedStack(
                index: safeIndex,
                children: items.map((item) => _buildPage(item.route)).toList(),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      body: IndexedStack(
        index: safeIndex,
        children: items.map((item) => _buildPage(item.route)).toList(),
      ),
      bottomNavigationBar: AppBottomNav(
        items: items,
        labels: labels,
        selectedIndex: safeIndex,
        onDestinationSelected: (i) => setState(() => _selectedIndex = i),
      ),
    );
  }
}
