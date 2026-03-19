import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order_item.dart';
import 'package:gastrobotmanager/features/orders/utils/order_group_status.dart';
import 'package:gastrobotmanager/features/orders/utils/order_time_ago.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Card for a single pending order in waiter's list (Active tab).
/// Shows table #, order # chip, time ago, Food: status, Drinks: status, VIDI DETALJE.
class WaiterOrderCard extends StatelessWidget {
  const WaiterOrderCard({
    super.key,
    required this.order,
    required this.accentColor,
    required this.l10n,
    required this.onSeeDetails,
  });

  final PendingOrder order;
  final Color accentColor;
  final AppLocalizations l10n;
  final VoidCallback onSeeDetails;

  static int _tableNumber(PendingOrder order) {
    return int.tryParse(order.tableNumber) ?? 0;
  }

  static List<PendingOrderItem> _foodItems(PendingOrder order) {
    return order.items
        .where((i) => i.type == null || i.type == 'food')
        .toList();
  }

  static List<PendingOrderItem> _drinkItems(PendingOrder order) {
    return order.items.where((i) => i.type == 'drink').toList();
  }

  static (String label, Color color, IconData icon) _statusStyle(
    OrderGroupStatus status,
    AppLocalizations l10n,
    Color accentColor,
  ) {
    switch (status) {
      case OrderGroupStatus.pending:
        return (l10n.orderStatusPending, const Color(0xFFF59E0B), Icons.help_outline);
      case OrderGroupStatus.inPreparation:
        return (l10n.orderStatusInPreparation, accentColor, Icons.settings);
      case OrderGroupStatus.served:
        return (l10n.orderStatusServed, const Color(0xFF16A34A), Icons.check_circle);
      case OrderGroupStatus.rejected:
        return (l10n.orderStatusRejected, const Color(0xFFEF4444), Icons.cancel);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tableNum = _tableNumber(order);
    final timeAgo = formatOrderTimeAgo(order.targetTime, l10n);
    final foodItems = _foodItems(order);
    final drinkItems = _drinkItems(order);
    final foodStatus = orderGroupStatusFromItems(foodItems);
    final drinkStatus = orderGroupStatusFromItems(drinkItems);
    final foodStyle = _statusStyle(foodStatus, l10n, accentColor);
    final drinkStyle = _statusStyle(drinkStatus, l10n, accentColor);

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
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.restaurant, size: 18, color: AppColors.textPrimary),
                const SizedBox(width: 6),
                Text(
                  l10n.ordersFoodLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(foodStyle.$3, size: 16, color: foodStyle.$2),
                const SizedBox(width: 4),
                Text(
                  foodStyle.$1,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: foodStyle.$2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.local_bar, size: 18, color: AppColors.textPrimary),
                const SizedBox(width: 6),
                Text(
                  l10n.ordersDrinksLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(drinkStyle.$3, size: 16, color: drinkStyle.$2),
                const SizedBox(width: 4),
                Text(
                  drinkStyle.$1,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: drinkStyle.$2,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
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
