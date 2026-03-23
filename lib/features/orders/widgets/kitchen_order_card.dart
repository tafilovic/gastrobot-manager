import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/utils/order_seating_display_title.dart';
import 'package:gastrobotmanager/features/orders/utils/order_time_ago.dart';
import 'package:gastrobotmanager/features/tables/utils/table_type_display.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Card for a single pending order in the list.
class KitchenOrderCard extends StatelessWidget {
  const KitchenOrderCard({
    super.key,
    required this.order,
    required this.accentColor,
    required this.l10n,
    required this.onSeeDetails,
    this.itemCountLabel,
  });

  final PendingOrder order;
  final Color accentColor;
  final AppLocalizations l10n;
  final VoidCallback onSeeDetails;
  /// If set (e.g. for bar "Broj pića"), used instead of [AppLocalizations.orderDishCount].
  final String? itemCountLabel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeAgo = formatOrderTimeAgo(order.targetTime, l10n);

    final decoration = BoxDecoration(
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
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onSeeDetails,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: decoration,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.access_time, size: 18, color: accentColor),
                    const SizedBox(width: 8),
                    Text(
                      timeAgo,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      orderSeatingDisplayTitle(l10n, order),
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      tableDisplayCategoryIcon(
                        tableDisplayCategoryFromApiType(order.tableType),
                      ),
                      size: 18,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  itemCountLabel ?? l10n.orderDishCount(order.itemCount),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '#${order.orderNumber}',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
