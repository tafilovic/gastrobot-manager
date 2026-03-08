import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/utils/order_time_ago.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Card for a single order in waiter's History tab: table #, order #, time, Račun, VIDI DETALJE.
class WaiterOrderHistoryCard extends StatelessWidget {
  const WaiterOrderHistoryCard({
    super.key,
    required this.order,
    required this.accentColor,
    required this.l10n,
    required this.onSeeDetails,
    this.billAmount,
  });

  final PendingOrder order;
  final Color accentColor;
  final AppLocalizations l10n;
  final VoidCallback onSeeDetails;
  /// Optional bill total (e.g. "3.490,00 RSD"). If null, shows "—".
  final String? billAmount;

  static int _tableNumber(PendingOrder order) {
    return int.tryParse(order.tableNumber) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tableNum = _tableNumber(order);
    final timeAgo = formatOrderTimeAgo(order.targetTime, l10n);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.table_restaurant, size: 18, color: accentColor),
                const SizedBox(width: 6),
                Text(
                  l10n.orderTableNumber(tableNum),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundMuted,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.orderNumber,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              timeAgo,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const Divider(height: 16, color: AppColors.border),
            Text(
              '${l10n.orderBill} ${billAmount ?? '—'}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onSeeDetails,
                style: FilledButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(l10n.orderSeeDetails),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
