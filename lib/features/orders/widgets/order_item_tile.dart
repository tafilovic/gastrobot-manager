import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order_item.dart';

/// Single order item row in order details: checkbox, icon, name, notes, quantity.
/// When [isDisabled] is true the row is not tappable (item already accepted/rejected).
class OrderItemTile extends StatelessWidget {
  const OrderItemTile({
    super.key,
    required this.item,
    required this.isChecked,
    required this.accentColor,
    required this.onTap,
    this.isDisabled = false,
    this.isLocked = false,
  });

  final PendingOrderItem item;
  final bool isChecked;
  final Color accentColor;
  final VoidCallback? onTap;
  final bool isDisabled;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnchecked = !isChecked;
    final contentOpacity = isLocked
        ? 0.72
        : (!isDisabled && !isUnchecked ? 1.0 : 0.5);
    final textDecoration = isUnchecked && !isLocked
        ? TextDecoration.lineThrough
        : TextDecoration.none;

    return Opacity(
      opacity: contentOpacity,
      child: Material(
        color: AppColors.surface,
        child: InkWell(
          onTap: isDisabled ? null : onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 48,
                  height: 48,
                  child: Center(
                    child: isLocked
                        ? Container(
                            width: 28,
                            height: 28,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF59E0B)
                                  .withValues(alpha: 0.15),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.help_outline,
                              size: 18,
                              color: Color(0xFFF59E0B),
                            ),
                          )
                        : Checkbox(
                            value: isChecked,
                            onChanged:
                                isDisabled ? null : (_) => onTap?.call(),
                            activeColor: accentColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Center(
                  child: Icon(
                    Icons.restaurant,
                    size: 22,
                    color: AppColors.textMuted,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.name,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                          decoration: textDecoration,
                        ),
                      ),
                      if (item.notes.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          item.notes,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                            fontStyle: FontStyle.italic,
                            decoration: textDecoration,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'x${item.quantity}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                    decoration: textDecoration,
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
