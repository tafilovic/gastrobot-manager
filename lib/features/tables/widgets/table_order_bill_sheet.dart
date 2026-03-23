import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/menu/domain/models/menu_item.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';
import 'package:gastrobotmanager/features/tables/providers/table_order_menu_provider.dart';
import 'package:gastrobotmanager/features/tables/providers/tables_provider.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Bottom sheet showing the bill/cart with items grouped by food/drinks.
/// Supports quantity changes, remove, table selection, and order action.
void showTableOrderBillSheet({
  required BuildContext context,
  required ValueListenable<Map<String, int>> cartListenable,
  required TableOrderMenuProvider menuProvider,
  required String Function(int) formatPrice,
  required void Function(String itemId, int quantity) onUpdateQuantity,
  required void Function(String itemId) onRemove,
  required Future<void> Function(String tableId) onOrder,
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
    ),
  );
}

class _TableOrderBillSheet extends StatefulWidget {
  const _TableOrderBillSheet({
    required this.cartListenable,
    this.initialCart,
    required this.menuProvider,
    required this.formatPrice,
    required this.onUpdateQuantity,
    required this.onRemove,
    required this.onOrder,
  });

  final ValueListenable<Map<String, int>> cartListenable;
  final Map<String, int>? initialCart;
  final TableOrderMenuProvider menuProvider;
  final String Function(int) formatPrice;
  final void Function(String itemId, int quantity) onUpdateQuantity;
  final void Function(String itemId) onRemove;
  final Future<void> Function(String tableId) onOrder;

  @override
  State<_TableOrderBillSheet> createState() => _TableOrderBillSheetState();
}

class _TableOrderBillSheetState extends State<_TableOrderBillSheet> {
  String? _selectedTableId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureTablesLoaded());
  }

  /// Same source as [TablesScreen]: `/venues/:venueId/tables` (not region-embedded tables).
  void _ensureTablesLoaded() {
    final venueId = context.read<AuthProvider>().currentVenueId;
    if (venueId == null) return;
    final tp = context.read<TablesProvider>();
    final wrongVenue =
        tp.loadedVenueId != null && tp.loadedVenueId != venueId;
    if (!tp.isLoading && (tp.tables.isEmpty || wrongVenue)) {
      tp.load(venueId);
    }
  }

  List<_CartEntry> _buildEntries(Map<String, int> cart) {
    final entries = <_CartEntry>[];
    for (final e in cart.entries) {
      if (e.value <= 0) continue;
      final item = widget.menuProvider.getItemById(e.key);
      if (item == null) continue;
      final isDrink = widget.menuProvider.getItemCategoryType(e.key) == 'drinks';
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
      valueListenable: widget.cartListenable,
      builder: (context, cart, _) {
        final effectiveCart =
            cart.isNotEmpty ? cart : (widget.initialCart ?? cart);
        return _buildContent(context, effectiveCart);
      },
    );
  }

  Widget _buildContent(BuildContext context, Map<String, int> cart) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;
    final entries = _buildEntries(cart);
    final tablesProvider = context.watch<TablesProvider>();
    final allTables = tablesProvider.tables;

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
              _buildHeader(l10n, theme),
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
                l10n,
                entries,
                accentColor,
                tablesProvider,
                allTables,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(AppLocalizations l10n, ThemeData theme) {
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
        formatPrice: widget.formatPrice,
        accentColor: accentColor,
        onUpdateQuantity: (qty) => widget.onUpdateQuantity(e.item.id, qty),
        onRemove: () => widget.onRemove(e.item.id),
      ));
    }

    return sections;
  }

  Widget _buildFooter(
    AppLocalizations l10n,
    List<_CartEntry> entries,
    Color accentColor,
    TablesProvider tablesProvider,
    List<TableModel> allTables,
  ) {
    final total = _totalPrice(entries);
    final canOrder = entries.isNotEmpty && _selectedTableId != null;

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
                widget.formatPrice(total),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (tablesProvider.isLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: LinearProgressIndicator(),
            )
          else if (allTables.isNotEmpty)
            _TableSelectorDropdown(
              hint: l10n.acceptSheetSelectTable,
              tables: allTables,
              selectedTableId: _selectedTableId,
              tableNumberLabel: (name) => l10n.tableNumber(name),
              onSelect: (id) => setState(() => _selectedTableId = id),
            ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: canOrder
                ? () async {
                    final tableId = _selectedTableId!;
                    Navigator.of(context).pop();
                    await widget.onOrder(tableId);
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

class _TableSelectorDropdown extends StatelessWidget {
  const _TableSelectorDropdown({
    required this.hint,
    required this.tables,
    required this.selectedTableId,
    required this.tableNumberLabel,
    required this.onSelect,
  });

  final String hint;
  final List<TableModel> tables;
  final String? selectedTableId;
  final String Function(String) tableNumberLabel;
  final void Function(String) onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
        color: AppColors.surface,
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          isExpanded: true,
          hint: Text(
            hint,
            style: const TextStyle(color: AppColors.textSecondary),
          ),
          value: selectedTableId,
          items: tables
              .map(
                (t) => DropdownMenuItem<String>(
                  value: t.id,
                  child: Text(tableNumberLabel(t.name)),
                ),
              )
              .toList(),
          onChanged: (id) => id != null ? onSelect(id) : null,
        ),
      ),
    );
  }
}
