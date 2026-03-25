import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/currency/venue_currency_format.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/core/widgets/selectable_ink_card.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order_item.dart';
import 'package:gastrobotmanager/features/orders/utils/order_group_status.dart';
import 'package:gastrobotmanager/features/orders/utils/order_items_total_price_sum.dart';
import 'package:gastrobotmanager/features/orders/utils/order_seating_display_title.dart';
import 'package:gastrobotmanager/features/orders/utils/order_time_ago.dart';
import 'package:gastrobotmanager/features/tables/utils/table_type_display.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Layout for [PendingOrderItemsExpansionCard].
enum PendingOrderItemsCardLayout {
  /// Lavender-tint surface; header = time + order chip only (single-table context).
  tableOverviewHighlight,

  /// History-style list: expandable food/drink lines, optional “See details” button.
  list,

  /// Active orders / table overview list: compact status rows, divider, tappable card only.
  listCompact,
}

/// Order card: highlight strip, compact list rows, or expandable history layout.
class PendingOrderItemsExpansionCard extends StatelessWidget {
  const PendingOrderItemsExpansionCard({
    super.key,
    required this.order,
    required this.l10n,
    required this.accentColor,
    this.layout = PendingOrderItemsCardLayout.list,
    this.showSeeDetailsButton = true,
    this.showCategoryRows = true,
    this.onTap,
    this.isSelected = false,
  });

  final PendingOrder order;
  final AppLocalizations l10n;
  final Color accentColor;

  /// [tableOverviewHighlight] matches [TableOverviewActiveOrderCard].
  final PendingOrderItemsCardLayout layout;

  /// When true, shows "See details" and does not wrap the card in [InkWell].
  final bool showSeeDetailsButton;

  /// When false, food/drink sections are hidden (e.g. table overview).
  final bool showCategoryRows;

  /// Used for the details button when [showSeeDetailsButton] is true, or for the whole card
  /// when false. Unused for [tableOverviewHighlight].
  final VoidCallback? onTap;

  final bool isSelected;

  static const Color _highlightTint = Color(0xFFE8EAF6);
  static const double _cardRadius = 12;
  static const double _statusBadgeIconInsetRatio = 0.24;

  static String _orderChipRef(PendingOrder order) {
    if (order.orderNumber.isNotEmpty) return order.orderNumber;
    if (order.orderId.isNotEmpty) return order.orderId;
    return '—';
  }

  static List<PendingOrderItem> _foodItems(PendingOrder order) {
    return order.items
        .where((i) => i.type == null || i.type == 'food')
        .toList();
  }

  static List<PendingOrderItem> _drinkItems(PendingOrder order) {
    return order.items.where((i) => i.type == 'drink').toList();
  }

  static (String label, Color color, String statusSvgAsset) _statusStyle(
    OrderGroupStatus status,
    AppLocalizations l10n,
    Color accentColor,
  ) {
    switch (status) {
      case OrderGroupStatus.pending:
        return (
          l10n.orderStatusPending,
          const Color(0xFFF59E0B),
          'assets/icons/question.svg',
        );
      case OrderGroupStatus.inPreparation:
        return (
          l10n.orderStatusInPreparation,
          accentColor,
          'assets/icons/loading.svg',
        );
      case OrderGroupStatus.served:
        return (
          l10n.orderStatusServed,
          const Color(0xFF16A34A),
          'assets/icons/checkmark.svg',
        );
      case OrderGroupStatus.rejected:
        return (
          l10n.orderStatusRejected,
          const Color(0xFFEF4444),
          'assets/icons/rejected.svg',
        );
    }
  }

  /// White glyph on a solid circle filled with [stateColor].
  static Widget _statusSvgBadge(
    String assetPath,
    Color stateColor,
    double diameter,
  ) {
    const glyphColor = Colors.white;
    final inset = diameter * _statusBadgeIconInsetRatio;
    return Container(
      width: diameter,
      height: diameter,
      decoration: BoxDecoration(
        color: stateColor,
        shape: BoxShape.circle,
      ),
      padding: EdgeInsets.all(inset),
      child: SvgPicture.asset(
        assetPath,
        colorFilter: const ColorFilter.mode(glyphColor, BlendMode.srcIn),
        fit: BoxFit.contain,
      ),
    );
  }

  BoxDecoration _decoration() {
    if (layout == PendingOrderItemsCardLayout.tableOverviewHighlight) {
      return BoxDecoration(
        color: _highlightTint,
        borderRadius: BorderRadius.circular(_cardRadius),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      );
    }
    if (isSelected) {
      return BoxDecoration(
        color: Color.alphaBlend(
          accentColor.withValues(alpha: 0.12),
          AppColors.surface,
        ),
        borderRadius: BorderRadius.circular(_cardRadius),
        border: Border.all(color: accentColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.28),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      );
    }
    return BoxDecoration(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(_cardRadius),
      border: Border.all(color: AppColors.border),
      boxShadow: [
        BoxShadow(
          color: AppColors.shadow,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    );
  }

  Widget _buildHeader(ThemeData theme) {
    final timeAgo = formatOrderTimeAgo(order.targetTime, l10n);
    final chipRef = _orderChipRef(order);
    final chip = Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: layout == PendingOrderItemsCardLayout.tableOverviewHighlight
            ? AppColors.surface
            : AppColors.backgroundMuted,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        chipRef,
        style: theme.textTheme.bodySmall?.copyWith(
          color: AppColors.textSecondary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );

    if (layout == PendingOrderItemsCardLayout.tableOverviewHighlight) {
      return Row(
        children: [
          Expanded(
            child: Text(
              timeAgo,
              style: theme.textTheme.bodySmall?.copyWith(
                color: AppColors.textMuted,
              ),
            ),
          ),
          chip,
        ],
      );
    }

    // list + listCompact: seating title (Room 1 / Sunbed 2 / Table …)
    final category = tableDisplayCategoryFromApiType(order.tableType);
    final seatingTitle = orderSeatingDisplayTitle(l10n, order);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              tableDisplayCategoryIcon(category),
              size: 18,
              color: accentColor,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                seatingTitle,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: accentColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            chip,
          ],
        ),
        const SizedBox(height: 4),
        Text(
          timeAgo,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _compactStatusRow(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required String statusLabel,
    required Color statusColor,
    required String statusSvgAsset,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
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
          Text(
            statusLabel.toUpperCase(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: statusColor,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
            ),
          ),
          const SizedBox(width: 4),
          _statusSvgBadge(statusSvgAsset, statusColor, 18),
        ],
      ),
    );
  }

  Widget _expandableGroup(
    ThemeData theme, {
    required IconData icon,
    required String title,
    required List<PendingOrderItem> items,
    required String statusLabel,
    required Color statusColor,
    required String statusSvgAsset,
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
            _statusSvgBadge(statusSvgAsset, statusColor, 16),
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

  @override
  Widget build(BuildContext context) {
    context.watch<AuthProvider>();
    final theme = Theme.of(context);
    final venueCurrency = context.read<AuthProvider>().currentVenueCurrency;
    final foodItems = _foodItems(order);
    final drinkItems = _drinkItems(order);
    final foodStatus = orderGroupStatusFromItems(foodItems);
    final drinkStatus = orderGroupStatusFromItems(drinkItems);
    final foodStyle = _statusStyle(foodStatus, l10n, accentColor);
    final drinkStyle = _statusStyle(drinkStatus, l10n, accentColor);
    final billSum = orderItemsTotalPriceSum(order.items);
    final bill = billSum != null
        ? formatVenueAmountForDisplay(context, billSum, venueCurrency)
        : null;

    final headerSpacing =
        layout == PendingOrderItemsCardLayout.tableOverviewHighlight
        ? 8.0
        : 12.0;

    final innerColumn = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(theme),
        SizedBox(height: headerSpacing),
        if (showCategoryRows) ...[
          if (foodItems.isNotEmpty) ...[
            _expandableGroup(
              theme,
              icon: Icons.restaurant,
              title: l10n.ordersFoodLabel,
              items: foodItems,
              statusLabel: foodStyle.$1,
              statusColor: foodStyle.$2,
              statusSvgAsset: foodStyle.$3,
            ),
            if (drinkItems.isNotEmpty) const SizedBox(height: 4),
          ],
          if (drinkItems.isNotEmpty)
            _expandableGroup(
              theme,
              icon: Icons.local_bar,
              title: l10n.ordersDrinksLabel,
              items: drinkItems,
              statusLabel: drinkStyle.$1,
              statusColor: drinkStyle.$2,
              statusSvgAsset: drinkStyle.$3,
            ),
        ],
        if (bill != null ||
            (layout == PendingOrderItemsCardLayout.list &&
                !showCategoryRows)) ...[
          const SizedBox(height: 8),
          const Divider(height: 1, thickness: 1, color: AppColors.border),
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
                bill ?? '—',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ],
        if (layout == PendingOrderItemsCardLayout.list &&
            showSeeDetailsButton &&
            onTap != null) ...[
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
    );

    final showFoodCategory = showCategoryRows && foodItems.isNotEmpty;
    final showDrinkCategory = showCategoryRows && drinkItems.isNotEmpty;
    final showAnyCategory = showFoodCategory || showDrinkCategory;

    final body = layout == PendingOrderItemsCardLayout.listCompact
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                child: _buildHeader(theme),
              ),
              if (showAnyCategory) ...[
                const SizedBox(height: 12),
                const Divider(height: 1, thickness: 1, color: AppColors.border),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (showFoodCategory)
                        _compactStatusRow(
                          theme,
                          icon: Icons.restaurant,
                          title: l10n.ordersFoodLabel,
                          statusLabel: foodStyle.$1,
                          statusColor: foodStyle.$2,
                          statusSvgAsset: foodStyle.$3,
                        ),
                      if (showDrinkCategory)
                        _compactStatusRow(
                          theme,
                          icon: Icons.local_bar,
                          title: l10n.ordersDrinksLabel,
                          statusLabel: drinkStyle.$1,
                          statusColor: drinkStyle.$2,
                          statusSvgAsset: drinkStyle.$3,
                        ),
                      if (bill != null) ...[
                        const SizedBox(height: 8),
                        const Divider(
                          height: 1,
                          thickness: 1,
                          color: AppColors.border,
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: 18,
                              color: AppColors.textPrimary,
                            ),
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
              ],
              if (!showAnyCategory && bill != null) ...[
                const SizedBox(height: 12),
                const Divider(height: 1, thickness: 1, color: AppColors.border),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                  child: Row(
                    children: [
                      Icon(
                        Icons.receipt_long,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
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
                ),
              ],
            ],
          )
        : Padding(padding: const EdgeInsets.all(12), child: innerColumn);

    if (layout == PendingOrderItemsCardLayout.tableOverviewHighlight) {
      return Container(decoration: _decoration(), child: body);
    }

    if (showSeeDetailsButton) {
      return Container(decoration: _decoration(), child: body);
    }

    final wholeCardTappable =
        onTap != null &&
        (layout == PendingOrderItemsCardLayout.listCompact ||
            layout == PendingOrderItemsCardLayout.list);

    if (wholeCardTappable) {
      return SelectableInkCard(
        accentColor: accentColor,
        isSelected: isSelected,
        onTap: onTap!,
        borderRadius: _cardRadius,
        child: body,
      );
    }

    return Container(decoration: _decoration(), child: body);
  }
}
