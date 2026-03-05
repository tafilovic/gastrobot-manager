import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/providers/orders_provider.dart';
import 'package:gastrobotmanager/features/orders/widgets/orders_content.dart';
import 'package:gastrobotmanager/features/orders/widgets/standard_orders_placeholder.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Orders list. For kitchen/bar: one [OrdersContent] + [OrdersProvider] (source by role).
/// For waiter: placeholder.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  OrdersProvider? _ordersProvider;

  @override
  void dispose() {
    _ordersProvider?.stopPeriodicRefresh();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;
    final auth = context.watch<AuthProvider>();
    final profileType = auth.profileType;

    if (profileType == ProfileType.waiter) {
      _ordersProvider = null;
      return StandardOrdersPlaceholder(
        l10n: l10n,
        theme: theme,
      );
    }

    final ordersProvider = context.read<OrdersProvider>();
    _ordersProvider = ordersProvider;
    return OrdersContent(
      accentColor: accentColor,
      l10n: l10n,
      onStartRefresh: () {
        final venueId = auth.user?.venueUsers.isNotEmpty == true
            ? auth.user!.venueUsers.first.venueId
            : null;
        if (venueId != null) {
          ordersProvider.startPeriodicRefresh(venueId);
        }
      },
    );
  }
}
