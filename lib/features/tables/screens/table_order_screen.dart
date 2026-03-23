import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/core/currency/currency_provider.dart';
import 'package:gastrobotmanager/core/layout/app_breakpoints.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/core/widgets/image_loader.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/menu/domain/models/menu_category.dart';
import 'package:gastrobotmanager/features/menu/domain/models/menu_item.dart';
import 'package:gastrobotmanager/features/tables/domain/errors/tables_exception.dart';
import 'package:gastrobotmanager/features/tables/domain/models/create_venue_order_request.dart';
import 'package:gastrobotmanager/features/tables/domain/repositories/tables_api.dart';
import 'package:gastrobotmanager/features/tables/providers/table_order_menu_provider.dart';
import 'package:gastrobotmanager/features/tables/widgets/table_order_bill_sheet.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// New order screen for table ordering. Shows categories and menu items with add-to-cart.
class TableOrderScreen extends StatefulWidget {
  const TableOrderScreen({super.key});

  @override
  State<TableOrderScreen> createState() => _TableOrderScreenState();
}

class _TableOrderScreenState extends State<TableOrderScreen> {
  int _selectedCategoryIndex = 0;
  final ValueNotifier<Map<String, int>> _cartNotifier =
      ValueNotifier<Map<String, int>>({});

  Map<String, int> get _cart => _cartNotifier.value;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  @override
  void dispose() {
    _cartNotifier.dispose();
    super.dispose();
  }

  void _load() {
    final venueId = context.read<AuthProvider>().currentVenueId;
    if (venueId != null) {
      context.read<TableOrderMenuProvider>().load(venueId);
    }
  }

  void _addToCart(MenuItem item) {
    _cartNotifier.value = {
      ..._cart,
      item.id: (_cart[item.id] ?? 0) + 1,
    };
  }

  void _updateCartQuantity(String itemId, int quantity) {
    if (quantity <= 0) {
      final next = Map<String, int>.from(_cart)..remove(itemId);
      _cartNotifier.value = next;
    } else {
      _cartNotifier.value = {..._cart, itemId: quantity};
    }
  }

  void _removeFromCart(String itemId) {
    final next = Map<String, int>.from(_cart)..remove(itemId);
    _cartNotifier.value = next;
  }

  void _onCartPressed() {
    if (_cart.isEmpty) return;
    showTableOrderBillSheet(
      context: context,
      cartListenable: _cartNotifier,
      initialCart: Map.from(_cart),
      menuProvider: context.read<TableOrderMenuProvider>(),
      formatPrice: (price) =>
          context.read<CurrencyProvider>().formatInt(price),
      onUpdateQuantity: _updateCartQuantity,
      onRemove: _removeFromCart,
      onOrder: _submitOrder,
    );
  }

  Future<void> _submitOrder(String tableId) async {
    final l10n = AppLocalizations.of(context)!;
    final cart = Map<String, int>.from(_cartNotifier.value);
    if (cart.isEmpty) return;

    final auth = context.read<AuthProvider>();
    final venueId = auth.currentVenueId;
    final userId = auth.user?.id;
    if (venueId == null || userId == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.tableOrderSubmitError)),
      );
      return;
    }

    final menuProvider = context.read<TableOrderMenuProvider>();
    final lines = <CreateVenueOrderLine>[];
    for (final entry in cart.entries) {
      if (entry.value <= 0) continue;
      if (menuProvider.getItemById(entry.key) == null) continue;
      lines.add(
        CreateVenueOrderLine(
          menuItemId: entry.key,
          quantity: entry.value,
        ),
      );
    }
    if (lines.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.tableOrderSubmitError)),
      );
      return;
    }

    try {
      await context.read<TablesApi>().createVenueOrder(
        venueId,
        CreateVenueOrderRequest(
          tableId: tableId,
          userId: userId,
          orderItems: lines,
        ),
      );
      if (!mounted) return;
      _cartNotifier.value = {};
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.tableOrderSubmitSuccess)),
      );
    } on TablesException catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.tableOrderSubmitError)),
      );
    }
  }

  String _formatMenuPrice(int price) =>
      context.read<CurrencyProvider>().formatInt(price);

  static String? _resolveImageUrl(String? url) {
    if (url == null || url.isEmpty) return null;
    if (url.startsWith('http://') || url.startsWith('https://')) return url;
    return '${ApiConfig.baseUrl}$url';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    context.watch<CurrencyProvider>();
    final provider = context.watch<TableOrderMenuProvider>();
    final accentColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          l10n.tableOrderScreenTitle,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: ValueListenableBuilder<Map<String, int>>(
              valueListenable: _cartNotifier,
              builder: (context, cart, _) {
                return Material(
                  color: AppColors.backgroundMuted,
                  borderRadius: BorderRadius.circular(20),
                  child: InkWell(
                    onTap: cart.isEmpty ? null : _onCartPressed,
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.receipt_long, size: 20, color: accentColor),
                          const SizedBox(width: 6),
                          Text(
                            '${cart.values.fold<int>(0, (s, c) => s + c)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: provider.loading && provider.categories.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : provider.error != null && provider.categories.isEmpty
          ? Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  provider.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            )
          : LayoutBuilder(
              builder: (context, constraints) {
                final width = MediaQuery.sizeOf(context).width;
                final useTwoColumns = width >= AppBreakpoints.expanded;
                final maxWidth = useTwoColumns
                    ? AppBreakpoints.contentMaxWidthWide
                    : AppBreakpoints.contentMaxWidth;

                return Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: maxWidth),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (provider.categories.isNotEmpty) ...[
                          _CategoryChips(
                            categories: provider.categories,
                            selectedIndex: _selectedCategoryIndex,
                            onSelect: (index) =>
                                setState(() => _selectedCategoryIndex = index),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 20,
                                vertical: 8,
                              ),
                              child: useTwoColumns
                                  ? GridView.builder(
                                      gridDelegate:
                                          const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2,
                                        mainAxisSpacing: 12,
                                        crossAxisSpacing: 12,
                                        mainAxisExtent: 150,
                                      ),
                                      itemCount: provider
                                          .itemsForCategory(
                                            _selectedCategoryIndex,
                                          )
                                          .length,
                                      itemBuilder: (context, index) {
                                        final items = provider.itemsForCategory(
                                          _selectedCategoryIndex,
                                        );
                                        final item = items[index];
                                        return _OrderMenuItemCard(
                                          item: item,
                                          accentColor: accentColor,
                                          formatPrice: _formatMenuPrice,
                                          resolveImageUrl: _resolveImageUrl,
                                          onAdd: () => _addToCart(item),
                                        );
                                      },
                                    )
                                  : ListView.builder(
                                      itemCount: provider
                                          .itemsForCategory(
                                            _selectedCategoryIndex,
                                          )
                                          .length,
                                      itemBuilder: (context, index) {
                                        final items = provider.itemsForCategory(
                                          _selectedCategoryIndex,
                                        );
                                        final item = items[index];
                                        return Padding(
                                          padding: const EdgeInsets.only(
                                            bottom: 12,
                                          ),
                                          child: _OrderMenuItemCard(
                                            item: item,
                                            accentColor: accentColor,
                                            formatPrice: _formatMenuPrice,
                                            resolveImageUrl: _resolveImageUrl,
                                            onAdd: () => _addToCart(item),
                                          ),
                                        );
                                      },
                                    ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class _OrderMenuItemCard extends StatelessWidget {
  const _OrderMenuItemCard({
    required this.item,
    required this.accentColor,
    required this.formatPrice,
    required this.resolveImageUrl,
    required this.onAdd,
  });

  final MenuItem item;
  final Color accentColor;
  final String Function(int) formatPrice;
  final String? Function(String?) resolveImageUrl;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final imageUrl = resolveImageUrl(item.product.imageUrl);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: imageUrl != null
                  ? ImageLoader(
                      imageUrl: imageUrl,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      placeholder: _placeholder(theme),
                      errorWidget: _placeholder(theme),
                    )
                  : _placeholder(theme),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (item.product.description != null &&
                      item.product.description!.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      item.product.description!,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontStyle: FontStyle.italic,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        formatPrice(item.price),
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Material(
                        color: accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                        child: InkWell(
                          onTap: item.isAvailable ? onAdd : null,
                          borderRadius: BorderRadius.circular(20),
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.add,
                              size: 20,
                              color: item.isAvailable
                                  ? accentColor
                                  : AppColors.textMuted,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _placeholder(ThemeData theme) {
    return Container(
      width: 80,
      height: 80,
      color: AppColors.backgroundMuted,
      child: Icon(Icons.restaurant, color: AppColors.textMuted, size: 32),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.categories,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<MenuCategory> categories;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < categories.length; i++) ...[
            if (i > 0) const SizedBox(width: 10),
            _CategoryChip(
              label: categories[i].name.isNotEmpty
                  ? categories[i].name
                  : '${i + 1}',
              selected: i == selectedIndex,
              onTap: () => onSelect(i),
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: selected ? AppColors.textPrimary : AppColors.backgroundMuted,
          borderRadius: BorderRadius.circular(22),
          border: selected
              ? null
              : Border.all(color: AppColors.textMuted, width: 1),
        ),
        child: Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w400,
            color: selected ? Colors.white : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
