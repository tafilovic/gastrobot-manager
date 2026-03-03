import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/navigation/nav_config.dart';
import '../../../core/navigation/nav_item.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../auth/providers/auth_provider.dart';
import '../../menu/screens/menu_screen.dart';
import '../../orders/screens/orders_screen.dart';
import '../../preparing/screens/preparing_screen.dart';
import '../../profile/screens/profile_screen.dart';
import '../../reservations/screens/reservations_screen.dart';

/// Main shell with bottom navigation. Items depend on [ProfileType].
class MainShell extends StatefulWidget {
  const MainShell({super.key});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _selectedIndex = 0;

  Widget _buildPage(String route) {
    switch (route) {
      case 'orders':
        return const OrdersScreen();
      case 'preparing':
        return const PreparingScreen();
      case 'reservations':
        return const ReservationsScreen();
      case 'menu':
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

    return Scaffold(
      body: IndexedStack(
        index: safeIndex,
        children: items.map((item) => _buildPage(item.route)).toList(),
      ),
      bottomNavigationBar: Container(
        color: Colors.white,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: NavigationBar(
              selectedIndex: safeIndex,
              onDestinationSelected: (i) => setState(() => _selectedIndex = i),
              backgroundColor: Colors.transparent,
              elevation: 0,
              height: 64,
              destinations: items
                  .map((item) => NavigationDestination(
                        icon: Icon(item.icon),
                        label: NavConfig.labelFor(l10n, item.route),
                      ))
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
