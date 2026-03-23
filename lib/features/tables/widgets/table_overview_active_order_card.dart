import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order_item.dart';
import 'package:gastrobotmanager/features/orders/utils/order_group_status.dart';
import 'package:gastrobotmanager/features/orders/utils/order_time_ago.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Highlighted active order summary on table overview (occupied table).
class TableOverviewActiveOrderCard extends StatelessWidget {
  const TableOverviewActiveOrderCard({
    super.key,
    required this.order,
    required this.l10n,
    required this.accentColor,
  });

  final PendingOrder order;
  final AppLocalizations l10n;
  final Color accentColor;

  static const Color _cardTint = Color(0xFFE8EAF6);

  static List<PendingOrderItem> _foodItems(PendingOrder order) {
    return order.items
        .where((i) => i.type == null || i.type == 'food')
        .toList();
  }

  static List<PendingOrderItem> _drinkItems(PendingOrder order) {
    return order.items.where((i) => i.type == 'drink').toList();
  }

  static String? _billTotal(PendingOrder order) {
    var sum = 0.0;
    for (final item in order.items) {
      if (item.totalPrice != null) sum += item.totalPrice!;
    }
    if (sum == 0) return null;
    final intPart = sum.floor();
    final frac = ((sum - intPart) * 100).round().clamp(0, 99);
    final intStr = intPart.toString();
    final buf = StringBuffer();
    for (var i = 0; i < intStr.length; i++) {
      if (i > 0 && (intStr.length - i) % 3 == 0) buf.write('.');
      buf.write(intStr[i]);
    }
    return '${buf.toString()},${frac.toString().padLeft(2, '0')} RSD';
  }

  static (String label, Color color, IconData icon) _statusStyle(
    OrderGroupStatus status,
    AppLocalizations l10n,
    Color accentColor,
  ) {
    switch (status) {
      case OrderGroupStatus.pending:
        return (
          l10n.orderStatusPending,
          const Color(0xFFF59E0B),
          Icons.help_outline,
        );
      case OrderGroupStatus.inPreparation:
        return (
          l10n.orderStatusInPreparation,
          accentColor,
          Icons.settings,
        );
      case OrderGroupStatus.served:
        return (
          l10n.orderStatusServed,
          const Color(0xFF16A34A),
          Icons.check_circle,
        );
      case OrderGroupStatus.rejected:
        return (
          l10n.orderStatusRejected,
          const Color(0xFFEF4444),
          Icons.cancel,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeAgo = formatOrderTimeAgo(order.targetTime, l10n);
    final foodItems = _foodItems(order);
    final drinkItems = _drinkItems(order);
    final foodStatus = orderGroupStatusFromItems(foodItems);
    final drinkStatus = orderGroupStatusFromItems(drinkItems);
    final foodStyle = _statusStyle(foodStatus, l10n, accentColor);
    final drinkStyle = _statusStyle(drinkStatus, l10n, accentColor);
    final bill = _billTotal(order);

    return Container(
      decoration: BoxDecoration(
        color: _cardTint,
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
                Expanded(
                  child: Text(
                    timeAgo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    order.orderNumber,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            _expandableGroup(
              context,
              theme,
              icon: Icons.restaurant,
              title: l10n.ordersFoodLabel,
              items: foodItems,
              statusLabel: foodStyle.$1,
              statusColor: foodStyle.$2,
              statusIcon: foodStyle.$3,
            ),
            const SizedBox(height: 4),
            _expandableGroup(
              context,
              theme,
              icon: Icons.local_bar,
              title: l10n.ordersDrinksLabel,
              items: drinkItems,
              statusLabel: drinkStyle.$1,
              statusColor: drinkStyle.$2,
              statusIcon: drinkStyle.$3,
            ),
            if (bill != null) ...[
              const SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.receipt_long, size: 18, color: AppColors.textPrimary),
                  const SizedBox(width: 6),
                  Text(
                    l10n.orderBill,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    bill,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _expandableGroup(
    BuildContext context,
    ThemeData theme, {
    required IconData icon,
    required String title,
    required List<PendingOrderItem> items,
    required String statusLabel,
    required Color statusColor,
    required IconData statusIcon,
  }) {
    return Theme(
      data: theme.copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        tilePadding: EdgeInsets.zero,
        childrenPadding: const EdgeInsets.only(left: 8, bottom: 8),
        title: Row(
          children: [
            Icon(icon, size: 18, color: AppColors.textPrimary),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(statusIcon, size: 16, color: statusColor),
            const SizedBox(width: 4),
            Text(
              statusLabel,
              style: theme.textTheme.bodySmall?.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        children: items.isEmpty
            ? [
                Text(
                  '—',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textMuted,
                  ),
                ),
              ]
            : items
                .map(
                  (i) => Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 4),
                      child: Text(
                        '${i.name} × ${i.quantity}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ),
                  ),
                )
                .toList(),
      ),
    );
  }
}
