import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/providers/orders_provider.dart';
import 'package:gastrobotmanager/features/orders/widgets/orders_content.dart';
import 'package:gastrobotmanager/features/orders/widgets/waiter_orders_content.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Orders list. Kitchen/bar: [OrdersContent]. Waiter: [WaiterOrdersContent] (Active/History tabs).
/// All use [OrdersProvider]; waiter fetches from venues/:venueId/waiter/confirmed-orders.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accentColor = Theme.of(context).colorScheme.primary;
    final auth = context.watch<AuthProvider>();
    final profileType = auth.profileType;
    final ordersProvider = context.read<OrdersProvider>();

    void onStartRefresh() {
      final venueId = auth.currentVenueId;
      if (venueId != null) {
        ordersProvider.loadOnce(venueId);
      }
    }

    if (profileType == ProfileType.waiter) {
      return WaiterOrdersContent(
        accentColor: accentColor,
        l10n: l10n,
        onStartRefresh: onStartRefresh,
      );
    }

    return OrdersContent(
      accentColor: accentColor,
      l10n: l10n,
      onStartRefresh: onStartRefresh,
    );
  }
}
