import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/currency/currency_provider.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/utils/order_items_total_price_sum.dart';
import 'package:gastrobotmanager/features/orders/utils/order_time_ago.dart';
import 'package:gastrobotmanager/features/reservations/utils/format_reservation_date.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Card for a single pending order: date + order chip, time ago, bill total.
/// Optional full-card tap without the details button (e.g. table overview).
class WaiterOrderCard extends StatelessWidget {
  const WaiterOrderCard({
    super.key,
    required this.order,
    required this.accentColor,
    required this.l10n,
    required this.onTap,
    this.showSeeDetailsButton = true,
    this.isSelected = false,
  });

  final PendingOrder order;
  final Color accentColor;
  final AppLocalizations l10n;
  final VoidCallback onTap;
  final bool showSeeDetailsButton;
  final bool isSelected;

  static const double _headerIconSize = 22;
  static const double _billIconSize = 22;

  static String _orderChipRef(PendingOrder order) {
    if (order.orderNumber.isNotEmpty) return order.orderNumber;
    if (order.orderId.isNotEmpty) return order.orderId;
    return '—';
  }

  @override
  Widget build(BuildContext context) {
    final currency = context.watch<CurrencyProvider>();
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = formatReservationDate(
      order.targetTime,
      l10n,
      locale: locale,
    );
    final timeAgo = formatOrderTimeAgo(order.targetTime, l10n);
    final chipRef = _orderChipRef(order);
    final billSum = orderItemsTotalPriceSum(order.items);
    final bill =
        billSum != null ? currency.formatAmount(billSum) : null;

    final decoration = BoxDecoration(
      color: isSelected
          ? Color.alphaBlend(
              accentColor.withValues(alpha: 0.12),
              AppColors.surface,
            )
          : AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isSelected ? accentColor : AppColors.border,
        width: isSelected ? 2 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: isSelected
              ? accentColor.withValues(alpha: 0.28)
              : AppColors.shadow,
          blurRadius: isSelected ? 16 : 4,
          offset: Offset(0, isSelected ? 8 : 2),
        ),
        if (isSelected)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
      ],
    );

    final content = Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.calendar_today,
                size: _headerIconSize,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  dateStr,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  chipRef,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: _headerIconSize + 10, top: 6),
            child: Text(
              timeAgo,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          const Divider(height: 24),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.receipt_long,
                size: _billIconSize,
                color: AppColors.textMuted,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  l10n.orderBill,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              Text(
                bill ?? '—',
                textAlign: TextAlign.end,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          if (showSeeDetailsButton) ...[
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onTap,
                style: FilledButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                child: Text(l10n.orderSeeDetails),
              ),
            ),
          ],
        ],
      ),
    );

    if (showSeeDetailsButton) {
      return Container(decoration: decoration, child: content);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(decoration: decoration, child: content),
      ),
    );
  }
}
