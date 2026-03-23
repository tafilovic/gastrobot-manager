import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/menu/domain/models/menu_item.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';
import 'package:gastrobotmanager/features/tables/providers/table_order_menu_provider.dart';
import 'package:gastrobotmanager/features/tables/utils/table_type_display.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Bottom sheet showing the bill/cart for [orderForTable] (food/drinks, totals, submit).
void showTableOrderBillSheet({
  required BuildContext context,
  required ValueListenable<Map<String, int>> cartListenable,
  required TableOrderMenuProvider menuProvider,
  required String Function(int) formatPrice,
  required void Function(String itemId, int quantity) onUpdateQuantity,
  required void Function(String itemId) onRemove,
  required Future<void> Function(String tableId) onOrder,
  required TableModel orderForTable,
  Map<String, int>? initialCart,
}) {
  showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    useRootNavigator: true,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
    ),
    builder: (context) => _TableOrderBillSheet(
      cartListenable: cartListenable,
      initialCart: initialCart,
      menuProvider: menuProvider,
      formatPrice: formatPrice,
      onUpdateQuantity: onUpdateQuantity,
      onRemove: onRemove,
      onOrder: onOrder,
      orderForTable: orderForTable,
    ),
  );
}

class _TableOrderBillSheet extends StatelessWidget {
  const _TableOrderBillSheet({
    required this.cartListenable,
    this.initialCart,
    required this.menuProvider,
    required this.formatPrice,
    required this.onUpdateQuantity,
    required this.onRemove,
    required this.onOrder,
    required this.orderForTable,
  });

  final ValueListenable<Map<String, int>> cartListenable;
  final Map<String, int>? initialCart;
  final TableOrderMenuProvider menuProvider;
  final String Function(int) formatPrice;
  final void Function(String itemId, int quantity) onUpdateQuantity;
  final void Function(String itemId) onRemove;
  final Future<void> Function(String tableId) onOrder;
  final TableModel orderForTable;

  List<_CartEntry> _buildEntries(Map<String, int> cart) {
    final entries = <_CartEntry>[];
    for (final e in cart.entries) {
      if (e.value <= 0) continue;
      final item = menuProvider.getItemById(e.key);
      if (item == null) continue;
      final isDrink = menuProvider.getItemCategoryType(e.key) == 'drinks';
      entries.add(_CartEntry(item: item, quantity: e.value, isDrink: isDrink));
    }
    entries.sort((a, b) {
      if (a.isDrink != b.isDrink) return a.isDrink ? 1 : -1;
      return a.item.product.name.compareTo(b.item.product.name);
    });
    return entries;
  }

  int _totalPrice(List<_CartEntry> entries) {
    return entries.fold(
      0,
      (sum, e) => sum + (e.item.price * e.quantity),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String, int>>(
      valueListenable: cartListenable,
      builder: (context, cart, _) {
        final effectiveCart =
            cart.isNotEmpty ? cart : (initialCart ?? cart);
        return _buildContent(context, effectiveCart);
      },
    );
  }

  Widget _buildContent(BuildContext context, Map<String, int> cart) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;
    final entries = _buildEntries(cart);
    final tableId = orderForTable.id;
    final canOrder = entries.isNotEmpty && tableId.isNotEmpty;

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.viewInsetsOf(context).bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHeader(context, l10n, theme),
              Expanded(
                child: entries.isEmpty
                    ? Center(
                        child: Text(
                          l10n.billSheetEmpty,
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView(
                        controller: scrollController,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        children: _buildItemSections(l10n, entries, accentColor),
                      ),
              ),
              _buildFooter(
                context,
                l10n,
                entries,
                accentColor,
                tableId,
                canOrder,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.billSheetTitle,
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.close),
            color: AppColors.textSecondary,
          ),
        ],
      ),
    );
  }

  List<Widget> _buildItemSections(
    AppLocalizations l10n,
    List<_CartEntry> entries,
    Color accentColor,
  ) {
    final sections = <Widget>[];
    String? lastType;

    for (final e in entries) {
      final type = e.isDrink ? 'drinks' : 'food';
      if (type != lastType) {
        lastType = type;
        sections.add(_SectionHeader(
          icon: e.isDrink ? Icons.local_bar : Icons.restaurant,
          label: e.isDrink ? l10n.ordersDrinksLabel : l10n.ordersFoodLabel,
        ));
      }
      sections.add(_BillItemRow(
        entry: e,
        formatPrice: formatPrice,
        accentColor: accentColor,
        onUpdateQuantity: (qty) => onUpdateQuantity(e.item.id, qty),
        onRemove: () => onRemove(e.item.id),
      ));
    }

    return sections;
  }

  Widget _buildFooter(
    BuildContext context,
    AppLocalizations l10n,
    List<_CartEntry> entries,
    Color accentColor,
    String tableId,
    bool canOrder,
  ) {
    final total = _totalPrice(entries);

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.border),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.receipt_long, size: 20, color: accentColor),
                  const SizedBox(width: 8),
                  Text(
                    l10n.billSheetTotal,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
              Text(
                formatPrice(total),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.place_outlined,
                size: 20,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  seatingQualifiedTitle(l10n, orderForTable),
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: canOrder
                ? () async {
                    Navigator.of(context).pop();
                    await onOrder(tableId);
                  }
                : null,
            style: FilledButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 14),
            ),
            child: Text(l10n.billSheetOrderButton),
          ),
        ],
      ),
    );
  }
}

class _CartEntry {
  _CartEntry({
    required this.item,
    required this.quantity,
    required this.isDrink,
  });

  final MenuItem item;
  final int quantity;
  final bool isDrink;
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.textSecondary),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BillItemRow extends StatelessWidget {
  const _BillItemRow({
    required this.entry,
    required this.formatPrice,
    required this.accentColor,
    required this.onUpdateQuantity,
    required this.onRemove,
  });

  final _CartEntry entry;
  final String Function(int) formatPrice;
  final Color accentColor;
  final void Function(int) onUpdateQuantity;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final price = entry.item.price * entry.quantity;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  entry.item.product.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'x${entry.quantity}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: onRemove,
                    child: const Icon(
                      Icons.delete_outline,
                      size: 22,
                      color: AppColors.destructive,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            formatPrice(price),
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          _QuantitySelector(
            value: entry.quantity,
            onChanged: onUpdateQuantity,
          ),
        ],
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  const _QuantitySelector({
    required this.value,
    required this.onChanged,
  });

  final int value;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _CircleButton(
          icon: Icons.remove,
          onTap: value > 1 ? () => onChanged(value - 1) : null,
        ),
        const SizedBox(width: 12),
        Text(
          '$value',
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 12),
        _CircleButton(
          icon: Icons.add,
          onTap: () => onChanged(value + 1),
        ),
      ],
    );
  }
}

class _CircleButton extends StatelessWidget {
  const _CircleButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(
            icon,
            size: 18,
            color: onTap != null
                ? AppColors.textPrimary
                : AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
