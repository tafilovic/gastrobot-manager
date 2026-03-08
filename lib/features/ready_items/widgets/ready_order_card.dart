import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/preparing/domain/models/queue_item.dart';
import 'package:gastrobotmanager/features/preparing/domain/models/queue_order.dart';
import 'package:gastrobotmanager/features/preparing/utils/format_queue_time_ago.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// One ready-to-serve order card: table + order # chip, time ago, flat list of
/// items (icon by type: food/drink, name, quantity right), single "Mark as served" button.
class ReadyOrderCard extends StatelessWidget {
  const ReadyOrderCard({
    super.key,
    required this.order,
    required this.l10n,
    required this.accentColor,
    required this.onMarkServed,
  });

  final QueueOrder order;
  final AppLocalizations l10n;
  final Color accentColor;
  final VoidCallback onMarkServed;

  static int _tableNumber(QueueOrder order) {
    return int.tryParse(order.tableNumber) ?? 0;
  }

  static IconData _iconForItem(QueueItem item) {
    return item.type == 'drink' ? Icons.local_bar : Icons.restaurant;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                Icon(
                  Icons.table_restaurant,
                  size: 18,
                  color: accentColor,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.orderTableNumber(_tableNumber(order)),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
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
            const SizedBox(height: 6),
            Text(
              formatQueueTimeAgo(order.targetTime, l10n),
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
            const SizedBox(height: 16),
            ...order.items.map(
              (item) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    Icon(
                      _iconForItem(item),
                      size: 20,
                      color: AppColors.textPrimary,
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        item.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Text(
                      'x${item.quantity}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onMarkServed,
                style: FilledButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: AppColors.onPrimary,
                ),
                child: Text(l10n.readyMarkAsServed),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
