import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/providers/kitchen_orders_provider.dart';
import 'package:gastrobotmanager/features/orders/widgets/kitchen_orders_content.dart';
import 'package:gastrobotmanager/features/orders/widgets/standard_orders_placeholder.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Orders list. For kitchen/chef: fetches pending orders from API (refresh every 30s), oldest first.
/// For waiter/bar: shows empty state (standard placeholder).
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  KitchenOrdersProvider? _kitchenProvider;

  @override
  void dispose() {
    _kitchenProvider?.stopPeriodicRefresh();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;
    final auth = context.watch<AuthProvider>();
    final profileType = auth.profileType;

    if (profileType == ProfileType.kitchen) {
      final kitchenProvider = context.read<KitchenOrdersProvider>();
      _kitchenProvider = kitchenProvider;
      return KitchenOrdersContent(
        accentColor: accentColor,
        l10n: l10n,
        onStartRefresh: () {
          final user = auth.user;
          final venueId = user?.venueUsers.isNotEmpty == true
              ? user!.venueUsers.first.venueId
              : null;
          if (venueId != null) {
            kitchenProvider.startPeriodicRefresh(venueId);
          }
        },
      );
    }

    return StandardOrdersPlaceholder(
      l10n: l10n,
      theme: theme,
    );
  }
}
