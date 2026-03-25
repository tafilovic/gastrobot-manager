import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/currency/venue_currency_format.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/core/layout/app_breakpoints.dart';
import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order_item.dart';
import 'package:gastrobotmanager/features/orders/utils/order_items_total_price_sum.dart';
import 'package:gastrobotmanager/features/orders/utils/order_seating_display_title.dart';
import 'package:gastrobotmanager/features/tables/utils/table_type_display.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Reusable history order details body: order date, food/drinks (name + quantity), bill, paid status.
/// Used in [HistoryOrderDetailsScreen] and in master-detail detail pane.
class HistoryOrderDetailsContent extends StatelessWidget {
  const HistoryOrderDetailsContent({
    super.key,
    required this.order,
    this.paidAt,
  });

  final PendingOrder order;
  /// Payment date/time (ISO or parseable). When null, only "PAID" is shown without date.
  final String? paidAt;

  static final DateFormat _orderDateFormat =
      DateFormat('dd.MM.yyyy | HH:mm');

  static String _formatOrderDateTime(String targetTime) {
    final dt = DateTime.tryParse(targetTime);
    if (dt == null) return targetTime;
    return _orderDateFormat.format(dt);
  }

  @override
  Widget build(BuildContext context) {
    context.watch<AuthProvider>();
    final l10n = AppLocalizations.of(context)!;
    final venueCurrency = context.read<AuthProvider>().currentVenueCurrency;
    final accentColor = Theme.of(context).colorScheme.primary;
    final orderDateTime = _formatOrderDateTime(order.targetTime);
    final foodItems = order.items
        .where((i) => i.type == null || i.type == 'food')
        .toList();
    final drinkItems = order.items.where((i) => i.type == 'drink').toList();
    final billSum = orderItemsTotalPriceSum(order.items);
    final billTotal = billSum != null
        ? formatVenueAmountForDisplay(context, billSum, venueCurrency)
        : null;
    String? paidAtFormatted;
    if (paidAt != null && paidAt!.isNotEmpty) {
      final dt = DateTime.tryParse(paidAt!);
      paidAtFormatted = dt != null ? _orderDateFormat.format(dt) : paidAt;
    }

    final width = MediaQuery.sizeOf(context).width;
    final maxWidth = width >= AppBreakpoints.expanded
        ? AppBreakpoints.contentMaxWidthWide
        : AppBreakpoints.contentMaxWidth;

    return ConstrainedContent(
      maxWidth: maxWidth,
      padding: EdgeInsets.zero,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  tableDisplayCategoryIcon(
                    tableDisplayCategoryFromApiType(order.tableType),
                  ),
                  size: 20,
                  color: accentColor,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        orderSeatingDisplayTitle(l10n, order),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        orderDateTime,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundMuted,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order.orderNumber,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(height: 1),
            LayoutBuilder(
              builder: (context, constraints) {
                final width = MediaQuery.sizeOf(context).width;
                final useTwoColumns = width >= AppBreakpoints.expanded;
                final foodSection = [
                  if (foodItems.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _SectionHeader(
                        icon: Icons.restaurant,
                        label: l10n.ordersFoodLabel),
                    const SizedBox(height: 12),
                    ...foodItems.map((item) => _HistoryItemRow(item: item)),
                  ],
                ];
                final drinkSection = [
                  if (drinkItems.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    _SectionHeader(
                        icon: Icons.local_bar,
                        label: l10n.ordersDrinksLabel),
                    const SizedBox(height: 12),
                    ...drinkItems.map((item) => _HistoryItemRow(item: item)),
                  ],
                ];
                if (useTwoColumns &&
                    foodItems.isNotEmpty &&
                    drinkItems.isNotEmpty) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: foodSection,
                            ),
                          ),
                          const SizedBox(width: 24),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: drinkSection,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                    ],
                  );
                }
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...foodSection,
                    if (foodItems.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                    ],
                    ...drinkSection,
                    if (drinkItems.isNotEmpty) ...[
                      const SizedBox(height: 16),
                      const Divider(height: 1),
                    ],
                  ],
                );
              },
            ),
            if (billTotal != null) ...[
              const SizedBox(height: 16),
              _SectionHeader(
                  icon: Icons.receipt_long, label: l10n.orderBill),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  billTotal,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              decoration: BoxDecoration(
                color: accentColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        l10n.orderPaidLabel,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: accentColor,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Icon(Icons.check_circle, color: accentColor, size: 24),
                    ],
                  ),
                  if (paidAtFormatted != null) ...[
                    const SizedBox(height: 8),
                    Text(
                      paidAtFormatted,
                      style: const TextStyle(
                        fontSize: 14,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textPrimary),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _HistoryItemRow extends StatelessWidget {
  const _HistoryItemRow({required this.item});

  final PendingOrderItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (item.notes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.notes,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            'x${item.quantity}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
