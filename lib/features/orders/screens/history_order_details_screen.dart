import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/widgets/history_order_details_content.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// History order details: order date/time, food/drinks, bill, paid status.
/// Opened when waiter taps "See details" on a history order card.
class HistoryOrderDetailsScreen extends StatelessWidget {
  const HistoryOrderDetailsScreen({
    super.key,
    required this.order,
    this.paidAt,
  });

  final PendingOrder order;
  final String? paidAt;

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
      body: HistoryOrderDetailsContent(
        order: order,
        paidAt: paidAt,
      ),
    );
  }
}
