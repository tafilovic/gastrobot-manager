import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/app_breakpoints.dart';
import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/providers/orders_provider.dart';
import 'package:gastrobotmanager/features/orders/screens/order_details_screen.dart';
import 'package:gastrobotmanager/features/orders/widgets/order_details_content.dart';
import 'package:gastrobotmanager/features/orders/widgets/waiter_order_card.dart';
import 'package:gastrobotmanager/features/orders/widgets/waiter_order_history_card.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Waiter orders: title, Order button (plus icon), segmented Active/History, count + FILTERI, list of cards.
/// Active tab uses [WaiterOrderCard] (food/drinks status); History uses [WaiterOrderHistoryCard].
class WaiterOrdersContent extends StatefulWidget {
  const WaiterOrdersContent({
    super.key,
    required this.accentColor,
    required this.l10n,
    required this.onStartRefresh,
  });

  final Color accentColor;
  final AppLocalizations l10n;
  final VoidCallback onStartRefresh;

  @override
  State<WaiterOrdersContent> createState() => _WaiterOrdersContentState();
}

class _WaiterOrdersContentState extends State<WaiterOrdersContent> {
  int _selectedTabIndex = 0; // 0 = Active, 1 = History
  PendingOrder? _selectedOrder;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onStartRefresh());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<OrdersProvider>();
    final orders = provider.orders;
    final width = MediaQuery.sizeOf(context).width;
    final useMasterDetail = width >= AppBreakpoints.expanded;

    void onSeeDetails(PendingOrder order) {
      if (useMasterDetail) {
        setState(() => _selectedOrder = order);
      } else {
        _openDetails(order, provider);
      }
    }

    if (useMasterDetail) {
      return Scaffold(
        backgroundColor: AppColors.backgroundMuted,
        body: SafeArea(
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: _buildListPane(theme, provider, orders, onSeeDetails),
              ),
              Expanded(
                flex: 1,
                child: _selectedOrder == null
                    ? _buildDetailPlaceholder(theme)
                    : OrderDetailsContent(
                        order: _selectedOrder!,
                        onCompleted: () {
                          setState(() => _selectedOrder = null);
                          widget.onStartRefresh();
                        },
                      ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundMuted,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      widget.l10n.ordersTitle,
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: () {
                      // TODO: navigate to new order or sheet
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: widget.accentColor,
                      foregroundColor: AppColors.onPrimary,
                    ),
                    icon: const Icon(Icons.add, size: 20),
                    label: Text(widget.l10n.ordersOrderButton),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Expanded(
                    child: SegmentedButton<int>(
                      segments: [
                        ButtonSegment<int>(
                          value: 0,
                          label: Text(widget.l10n.ordersTabActive),
                        ),
                        ButtonSegment<int>(
                          value: 1,
                          label: Text(widget.l10n.ordersTabHistory),
                        ),
                      ],
                      selected: {_selectedTabIndex},
                      onSelectionChanged: (Set<int> selected) {
                        setState(() => _selectedTabIndex = selected.first);
                      },
                      style: ButtonStyle(
                        backgroundColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return widget.accentColor;
                          }
                          return AppColors.surface;
                        }),
                        foregroundColor: WidgetStateProperty.resolveWith((states) {
                          if (states.contains(WidgetState.selected)) {
                            return AppColors.onPrimary;
                          }
                          return AppColors.textPrimary;
                        }),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Text.rich(
                    TextSpan(
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: '${orders.length}',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: widget.accentColor,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        TextSpan(text: widget.l10n.ordersCountSuffix),
                      ],
                    ),
                  ),
                  const Spacer(),
                  TextButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.filter_list, size: 18, color: widget.accentColor),
                    label: Text(
                      widget.l10n.ordersFilters,
                      style: TextStyle(
                        color: widget.accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ConstrainedContent(
                padding: EdgeInsets.zero,
                child: RefreshIndicator(
                  onRefresh: () => provider.pullRefresh(),
                  child: _buildList(orders, provider, onSeeDetails),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListPane(
    ThemeData theme,
    OrdersProvider provider,
    List<PendingOrder> orders,
    void Function(PendingOrder) onSeeDetails,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  widget.l10n.ordersTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              FilledButton.icon(
                onPressed: () {
                  // TODO: navigate to new order or sheet
                },
                style: FilledButton.styleFrom(
                  backgroundColor: widget.accentColor,
                  foregroundColor: AppColors.onPrimary,
                ),
                icon: const Icon(Icons.add, size: 20),
                label: Text(widget.l10n.ordersOrderButton),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: SegmentedButton<int>(
                  segments: [
                    ButtonSegment<int>(
                      value: 0,
                      label: Text(widget.l10n.ordersTabActive),
                    ),
                    ButtonSegment<int>(
                      value: 1,
                      label: Text(widget.l10n.ordersTabHistory),
                    ),
                  ],
                  selected: {_selectedTabIndex},
                  onSelectionChanged: (Set<int> selected) {
                    setState(() => _selectedTabIndex = selected.first);
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return widget.accentColor;
                      }
                      return AppColors.surface;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.onPrimary;
                      }
                      return AppColors.textPrimary;
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Text.rich(
                TextSpan(
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  children: [
                    TextSpan(
                      text: '${orders.length}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: widget.accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: widget.l10n.ordersCountSuffix),
                  ],
                ),
              ),
              const Spacer(),
              TextButton.icon(
                onPressed: () {},
                icon: Icon(Icons.filter_list, size: 18, color: widget.accentColor),
                label: Text(
                  widget.l10n.ordersFilters,
                  style: TextStyle(
                    color: widget.accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => provider.pullRefresh(),
            child: _buildList(orders, provider, onSeeDetails),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailPlaceholder(ThemeData theme) {
    return Center(
      child: Text(
        widget.l10n.orderSeeDetails,
        style: theme.textTheme.bodyLarge?.copyWith(
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildList(
    List<PendingOrder> orders,
    OrdersProvider provider,
    void Function(PendingOrder) onSeeDetails,
  ) {
    if (orders.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.4,
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        provider.error ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: AppColors.error),
                      ),
                    ),
                  ),
          ),
        ],
      );
    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = orders[index];
        if (_selectedTabIndex == 0) {
          return WaiterOrderCard(
            order: order,
            accentColor: widget.accentColor,
            l10n: widget.l10n,
            onSeeDetails: () => onSeeDetails(order),
          );
        }
        return WaiterOrderHistoryCard(
          order: order,
          accentColor: widget.accentColor,
          l10n: widget.l10n,
          onSeeDetails: () => onSeeDetails(order),
        );
      },
    );
  }

  Future<void> _openDetails(PendingOrder order, OrdersProvider provider) async {
    final completed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => OrderDetailsScreen(order: order),
      ),
    );
    if (completed == true && context.mounted) {
      provider.pullRefresh();
    }
  }
}
