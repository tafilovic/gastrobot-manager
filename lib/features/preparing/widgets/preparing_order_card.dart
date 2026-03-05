import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/preparing/domain/models/kitchen_queue_order.dart';
import 'package:gastrobotmanager/features/preparing/utils/format_queue_time_ago.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// One order card on Preparing screen: time (accent), table, items list, Mark as ready button.
class PreparingOrderCard extends StatelessWidget {
  const PreparingOrderCard({
    super.key,
    required this.order,
    required this.l10n,
    required this.accentColor,
    required this.onMarkReady,
  });

  final KitchenQueueOrder order;
  final AppLocalizations l10n;
  final Color accentColor;
  final VoidCallback onMarkReady;

  static int _tableNumber(KitchenQueueOrder order) {
    return int.tryParse(order.tableNumber) ?? 0;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.schedule, size: 18, color: accentColor),
                const SizedBox(width: 6),
                Text(
                  formatQueueTimeAgo(order.targetTime, l10n),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Icon(Icons.table_restaurant, size: 18, color: AppColors.textPrimary),
                const SizedBox(width: 6),
                Text(
                  l10n.orderTableNumber(_tableNumber(order)),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ...order.items.asMap().entries.expand((entry) {
              final index = entry.key;
              final item = entry.value;
              return [
                if (index > 0)
                  const Divider(height: 24, color: AppColors.border),
                Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.restaurant, size: 20, color: AppColors.textMuted),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.name,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: AppColors.textPrimary,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            if (item.notes.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                item.notes,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: AppColors.textMuted,
                                  fontStyle: FontStyle.italic,
                                ),
                              ),
                            ],
                          ],
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
              ];
            }),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onMarkReady,
                style: FilledButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: AppColors.onPrimary,
                ),
                child: Text(l10n.preparingMarkAsReady),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
