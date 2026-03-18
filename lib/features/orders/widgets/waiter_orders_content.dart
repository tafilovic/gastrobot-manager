import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/app_breakpoints.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/core/navigation/app_router.dart';
import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/core/widgets/list_item_entrance.dart';
import 'package:gastrobotmanager/features/orders/domain/models/active_order_filters.dart';
import 'package:gastrobotmanager/features/orders/domain/models/history_order_filters.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/providers/orders_provider.dart';
import 'package:gastrobotmanager/features/orders/screens/active_order_details_screen.dart';
import 'package:gastrobotmanager/features/orders/screens/history_order_details_screen.dart';
import 'package:gastrobotmanager/features/orders/widgets/active_order_details_content.dart';
import 'package:gastrobotmanager/features/orders/widgets/history_order_details_content.dart';
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
  ActiveOrderFilters? _activeFilters;
  HistoryOrderFilters? _historyFilters;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onStartRefresh());
  }

  List<PendingOrder> _applyFilters(List<PendingOrder> orders) {
    if (_activeFilters == null || _activeFilters!.isEmpty) return orders;
    final f = _activeFilters!;
    return orders.where((order) {
      if (f.tableNumbers.isNotEmpty &&
          !f.tableNumbers.contains(order.tableNumber)) {
        return false;
      }
      if (f.foodStatuses.isNotEmpty) {
        final hasMatchingFood = order.items.any((item) {
          if (item.type != 'food') return false;
          final s = item.status == 'ready' ? 'served' : item.status;
          return f.foodStatuses.contains(s);
        });
        if (!hasMatchingFood) return false;
      }
      if (f.drinkStatuses.isNotEmpty) {
        final hasMatchingDrink = order.items.any((item) {
          if (item.type != 'drink') return false;
          final s = item.status == 'ready' ? 'served' : item.status;
          return f.drinkStatuses.contains(s);
        });
        if (!hasMatchingDrink) return false;
      }
      return true;
    }).toList();
  }

  List<PendingOrder> _applyHistoryFilters(List<PendingOrder> orders) {
    if (_historyFilters == null || _historyFilters!.isEmpty) return orders;
    final f = _historyFilters!;
    return orders.where((order) {
      if (f.dateFrom != null || f.dateTo != null) {
        DateTime? orderDate;
        try {
          orderDate = DateTime.tryParse(order.targetTime);
        } catch (_) {}
        if (orderDate != null) {
          final orderDay = DateTime(orderDate.year, orderDate.month, orderDate.day);
          if (f.dateFrom != null) {
            final from = DateTime(f.dateFrom!.year, f.dateFrom!.month, f.dateFrom!.day);
            if (orderDay.isBefore(from)) return false;
          }
          if (f.dateTo != null) {
            final to = DateTime(f.dateTo!.year, f.dateTo!.month, f.dateTo!.day);
            if (orderDay.isAfter(to)) return false;
          }
        }
      }
      if (f.tableNumbers.isNotEmpty &&
          !f.tableNumbers.contains(order.tableNumber)) {
        return false;
      }
      if (f.orderContentTypes.isNotEmpty) {
        if (f.orderContentTypes.contains(HistoryOrderFilters.orderContentFood) &&
            !order.items.any((i) => i.type == 'food')) return false;
        if (f.orderContentTypes.contains(HistoryOrderFilters.orderContentDrink) &&
            !order.items.any((i) => i.type == 'drink')) return false;
      }
      return true;
    }).toList();
  }

  void _onOrdersTabChanged(Set<int> selected) {
    final idx = selected.first;
    final wide =
        MediaQuery.sizeOf(context).width >= AppBreakpoints.expanded;
    setState(() {
      _selectedTabIndex = idx;
      if (wide) _selectedOrder = null;
    });
    if (idx == 1) {
      final venueId = context.read<AuthProvider>().currentVenueId;
      if (venueId != null) {
        context.read<OrdersProvider>().loadWaiterPaidOrders(venueId);
      }
    }
  }

  Future<void> _onPullRefresh() async {
    final venueId = context.read<AuthProvider>().currentVenueId;
    if (venueId == null) return;
    final provider = context.read<OrdersProvider>();
    if (_selectedTabIndex == 0) {
      await provider.pullRefresh();
    } else {
      await provider.loadWaiterPaidOrders(venueId);
    }
  }

  Future<void> _openFilters() async {
    if (_selectedTabIndex == 0) {
      final result = await context.push<ActiveOrderFilters>(
        AppRouteNames.pathOrdersFilterActive,
        extra: _activeFilters,
      );
      if (result != null && mounted) {
        setState(() => _activeFilters = result);
      }
    } else {
      final result = await context.push<HistoryOrderFilters>(
        AppRouteNames.pathOrdersFilterHistory,
        extra: _historyFilters,
      );
      if (result != null && mounted) {
        setState(() => _historyFilters = result);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<OrdersProvider>();
    final activeOrders = _applyFilters(provider.orders);
    final historyOrders =
        _applyHistoryFilters(provider.waiterHistoryOrders);
    final orders =
        _selectedTabIndex == 0 ? activeOrders : historyOrders;
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
                    : _selectedTabIndex == 0
                        ? ActiveOrderDetailsContent(
                            order: _selectedOrder!,
                            markOrderAsPaid: () async {
                              final venueId =
                                  context.read<AuthProvider>().currentVenueId;
                              if (venueId == null) return false;
                              return context
                                  .read<OrdersProvider>()
                                  .markWaiterOrderAsPaid(
                                    venueId,
                                    _selectedOrder!,
                                  );
                            },
                            onCompleted: () {
                              setState(() => _selectedOrder = null);
                              widget.onStartRefresh();
                            },
                          )
                        : HistoryOrderDetailsContent(
                            order: _selectedOrder!,
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
              child: Text(
                widget.l10n.ordersTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
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
                      onSelectionChanged: _onOrdersTabChanged,
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
                    onPressed: _openFilters,
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
                  onRefresh: _onPullRefresh,
                  child: _buildList(
                    orders,
                    provider,
                    onSeeDetails,
                    isHistoryTab: _selectedTabIndex == 1,
                  ),
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
          child: Text(
            widget.l10n.ordersTitle,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
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
                  onSelectionChanged: _onOrdersTabChanged,
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
                onPressed: _openFilters,
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
            onRefresh: _onPullRefresh,
            child: _buildList(
              orders,
              provider,
              onSeeDetails,
              isHistoryTab: _selectedTabIndex == 1,
            ),
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
    void Function(PendingOrder) onSeeDetails, {
    required bool isHistoryTab,
  }) {
    if (orders.isEmpty) {
      if (isHistoryTab) {
        if (provider.isLoadingPaidOrders) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: const Center(child: CircularProgressIndicator()),
              ),
            ],
          );
        }
        final paidErr = provider.paidOrdersError;
        if (paidErr != null && paidErr.isNotEmpty) {
          return ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.4,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      paidErr,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                ),
              ),
            ],
          );
        }
        return ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.4,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    widget.l10n.ordersHistoryEmpty,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
              ),
            ),
          ],
        );
      }
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
        final card = _selectedTabIndex == 0
            ? WaiterOrderCard(
                order: order,
                accentColor: widget.accentColor,
                l10n: widget.l10n,
                onSeeDetails: () => onSeeDetails(order),
              )
            : WaiterOrderHistoryCard(
                order: order,
                accentColor: widget.accentColor,
                l10n: widget.l10n,
                onSeeDetails: () => onSeeDetails(order),
              );
        return ListItemEntrance(index: index, child: card);
      },
    );
  }

  Future<void> _openDetails(PendingOrder order, OrdersProvider provider) async {
    if (_selectedTabIndex == 1) {
      await context.push(
        AppRouteNames.pathOrdersHistory,
        extra: HistoryOrderDetailsScreen(order: order),
      );
      return;
    }
    final completed = await context.push<bool>(
      AppRouteNames.pathOrdersActive,
      extra: ActiveOrderDetailsScreen(order: order),
    );
    if (completed == true && context.mounted) {
      provider.pullRefresh();
    }
  }
}
