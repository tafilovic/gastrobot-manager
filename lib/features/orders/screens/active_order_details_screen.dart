import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/providers/orders_provider.dart';
import 'package:gastrobotmanager/features/orders/widgets/active_order_details_content.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Waiter active order details: table, order ID, time, food/drinks grouped with status icons, bill, Mark as paid.
/// Opened when waiter taps "See details" on an active order.
class ActiveOrderDetailsScreen extends StatelessWidget {
  const ActiveOrderDetailsScreen({
    super.key,
    required this.order,
    this.billAmount,
  });

  final PendingOrder order;
  /// Optional total bill (e.g. "7.130,50 RSD"). If null, computed from items or "—".
  final String? billAmount;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(l10n.ordersTitle),
        backgroundColor: AppColors.appBarBackground,
        foregroundColor: AppColors.appBarForeground,
        elevation: 0,
      ),
      body: ActiveOrderDetailsContent(
        order: order,
        billAmount: billAmount,
        markOrderAsPaid: () async {
          final venueId = context.read<AuthProvider>().currentVenueId;
          if (venueId == null) return false;
          return context.read<OrdersProvider>().markWaiterOrderAsPaid(
                venueId,
                order,
              );
        },
      ),
    );
  }
}
