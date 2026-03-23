import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/app_breakpoints.dart';
import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/navigation/app_router.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/providers/orders_provider.dart';
import 'package:gastrobotmanager/features/orders/screens/active_order_details_screen.dart';
import 'package:gastrobotmanager/features/orders/widgets/active_order_details_content.dart';
import 'package:gastrobotmanager/features/orders/widgets/pending_order_items_expansion_card.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/reservations/screens/confirmed_reservation_details_screen.dart';
import 'package:gastrobotmanager/features/reservations/widgets/confirmed_reservation_details_content.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_orders_filters.dart';
import 'package:gastrobotmanager/features/tables/providers/tables_provider.dart';
import 'package:gastrobotmanager/features/tables/utils/apply_table_orders_content_filter.dart';
import 'package:gastrobotmanager/features/tables/utils/pending_orders_for_table.dart';
import 'package:gastrobotmanager/features/tables/widgets/table_overview_active_order_card.dart';
import 'package:gastrobotmanager/features/tables/widgets/table_overview_header.dart';
import 'package:gastrobotmanager/features/tables/widgets/table_overview_reservation_card.dart';
import 'package:gastrobotmanager/features/tables/widgets/table_overview_orders_header_row.dart';
import 'package:gastrobotmanager/features/tables/widgets/table_overview_reservation_count_row.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Detail view for one table: status, optional active order, reservations vs orders tabs.
class TableOverviewScreen extends StatefulWidget {
  const TableOverviewScreen({super.key, required this.table});

  final TableModel table;

  @override
  State<TableOverviewScreen> createState() => _TableOverviewScreenState();
}

class _TableOverviewScreenState extends State<TableOverviewScreen> {
  Future<List<ConfirmedReservation>>? _reservationsFuture;
  int _segmentIndex = 0;
  TableOrdersFilters _tableOrderFilters = TableOrdersFilters.defaults();
  Future<List<PendingOrder>>? _tableOrdersFuture;
  ConfirmedReservation? _selectedReservation;
  PendingOrder? _selectedOrder;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final venueId = context.read<AuthProvider>().currentVenueId;
      if (venueId != null) {
        context.read<OrdersProvider>().loadOnce(venueId);
      }
      setState(() {
        _reservationsFuture = context
            .read<TablesProvider>()
            .fetchActiveReservationsForTable(widget.table.id);
      });
    });
  }

  Future<void> _onRefresh() async {
    final venueId = context.read<AuthProvider>().currentVenueId;
    if (venueId != null) {
      await context.read<OrdersProvider>().loadOnce(venueId);
    }
    if (!mounted) return;
    setState(() {
      _reservationsFuture = context
          .read<TablesProvider>()
          .fetchActiveReservationsForTable(widget.table.id);
      if (_segmentIndex == 1) {
        _tableOrdersFuture = context.read<TablesProvider>().fetchOrdersForTable(
              widget.table.id,
              _tableOrderFilters,
            );
      }
    });
    await _reservationsFuture;
    if (_segmentIndex == 1 && _tableOrdersFuture != null) {
      await _tableOrdersFuture;
    }
  }

  void _loadTableOrders() {
    setState(() {
      _tableOrdersFuture = context.read<TablesProvider>().fetchOrdersForTable(
            widget.table.id,
            _tableOrderFilters,
          );
    });
  }

  Future<void> _openTableOrderFilters() async {
    final result = await context.push<TableOrdersFilters>(
      AppRouteNames.pathTablesFilterTableOrders,
      extra: _tableOrderFilters,
    );
    if (result != null && mounted) {
      setState(() => _tableOrderFilters = result);
      if (_segmentIndex == 1) {
        _loadTableOrders();
      }
    }
  }

  String _typeLabel(AppLocalizations l10n) {
    switch (widget.table.type) {
      case 'room':
        return l10n.tableTypeRoom;
      case 'sunbed':
        return l10n.tableTypeSunbed;
      default:
        return l10n.tableTypeTable;
    }
  }

  PendingOrder? _primaryOrder(List<PendingOrder> orders) {
    final list = pendingOrdersForTable(orders, widget.table);
    if (list.isEmpty) return null;
    list.sort((a, b) => b.targetTime.compareTo(a.targetTime));
    return list.first;
  }

  bool _isSameTableOrder(PendingOrder? selected, PendingOrder o) {
    if (selected == null) return false;
    if (selected.orderId.isNotEmpty && o.orderId.isNotEmpty) {
      return selected.orderId == o.orderId;
    }
    return selected.orderNumber == o.orderNumber &&
        selected.targetTime == o.targetTime;
  }

  Widget _makeOrderBottomBar(
    BuildContext context,
    AppLocalizations l10n,
    Color accentColor,
  ) {
    return Material(
      color: AppColors.surface,
      elevation: 6,
      shadowColor: Colors.black26,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 10),
          child: FilledButton(
            onPressed: () {
              context.pushNamed(
                AppRouteNames.tableOrder,
                extra: widget.table,
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: accentColor,
              foregroundColor: AppColors.onPrimary,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(l10n.tableOverviewMakeOrder),
          ),
        ),
      ),
    );
  }

  Future<void> _confirmMarkPaid(
    BuildContext context,
    AppLocalizations l10n,
    PendingOrder order,
  ) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.orderMarkAsPaidConfirmTitle),
        content: Text(l10n.orderMarkAsPaidConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.dialogNo),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.dialogYes),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    final venueId = context.read<AuthProvider>().currentVenueId;
    if (venueId == null) return;
    final success = await context.read<OrdersProvider>().markWaiterOrderAsPaid(
          venueId,
          order,
        );
    if (!context.mounted) return;
    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.orderMarkAsPaidSuccess)),
      );
    } else {
      final msg = context.read<OrdersProvider>().markPaidError;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(msg ?? l10n.orderMarkAsPaidError)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;
    final future = _reservationsFuture;

    if (future == null) {
      return Scaffold(
        backgroundColor: AppColors.backgroundMuted,
        appBar: AppBar(
          title: Text(l10n.navTables),
          backgroundColor: AppColors.surface,
          foregroundColor: AppColors.textPrimary,
        ),
        body: const Center(child: CircularProgressIndicator()),
        bottomNavigationBar: _makeOrderBottomBar(context, l10n, accentColor),
      );
    }

    final width = MediaQuery.sizeOf(context).width;
    final useMasterDetail = width >= AppBreakpoints.expanded;

    return Scaffold(
      backgroundColor: AppColors.backgroundMuted,
      appBar: AppBar(
        title: Text(l10n.navTables),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      bottomNavigationBar: _makeOrderBottomBar(context, l10n, accentColor),
      body: SafeArea(
        child: FutureBuilder<List<ConfirmedReservation>>(
          future: future,
          builder: (context, snapshot) {
            final reservations = snapshot.data ?? [];
            final reservationsError = snapshot.error;

            final mainColumn = Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                16,
                useMasterDetail ? 12 : 20,
                8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TableOverviewHeader(
                    table: widget.table,
                    l10n: l10n,
                    typeLabel: _typeLabel(l10n),
                  ),
                  const SizedBox(height: 12),
                  if (!widget.table.isFree)
                    Consumer<OrdersProvider>(
                      builder: (context, orders, _) {
                        final primary = _primaryOrder(orders.orders);
                        if (primary == null) {
                          return const SizedBox.shrink();
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TableOverviewActiveOrderCard(
                              order: primary,
                              l10n: l10n,
                              accentColor: accentColor,
                            ),
                            const SizedBox(height: 12),
                            FilledButton(
                              onPressed: () => _confirmMarkPaid(
                                context,
                                l10n,
                                primary,
                              ),
                              style: FilledButton.styleFrom(
                                backgroundColor: accentColor,
                                foregroundColor: AppColors.onPrimary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child: Text(l10n.orderMarkAsPaid),
                            ),
                            const SizedBox(height: 12),
                          ],
                        );
                      },
                    ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<int>(
                          segments: [
                            ButtonSegment<int>(
                              value: 0,
                              label: Text(l10n.navReservations),
                            ),
                            ButtonSegment<int>(
                              value: 1,
                              label: Text(l10n.navOrders),
                            ),
                          ],
                          selected: {_segmentIndex},
                          onSelectionChanged: (s) {
                            final i = s.first;
                            setState(() {
                              _segmentIndex = i;
                              _selectedReservation = null;
                              _selectedOrder = null;
                              if (i == 1) {
                                _loadTableOrders();
                              }
                            });
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                WidgetStateProperty.resolveWith((states) {
                              if (states.contains(WidgetState.selected)) {
                                return accentColor;
                              }
                              return AppColors.surface;
                            }),
                            foregroundColor:
                                WidgetStateProperty.resolveWith((states) {
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
                  const SizedBox(height: 16),
                  if (_segmentIndex == 0) ...[
                    if (reservationsError != null)
                      Text(
                        reservationsError.toString(),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.error,
                        ),
                      )
                    else if (snapshot.connectionState ==
                        ConnectionState.waiting)
                      const Padding(
                        padding: EdgeInsets.all(24),
                        child: Center(
                          child: CircularProgressIndicator(),
                        ),
                      )
                    else if (reservations.isEmpty)
                      Text(
                        l10n.tableOverviewNoReservations,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      )
                    else ...[
                      TableOverviewReservationCountRow(
                        count: reservations.length,
                        l10n: l10n,
                        accentColor: accentColor,
                        theme: theme,
                      ),
                      const SizedBox(height: 12),
                      ...reservations.map(
                        (r) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: TableOverviewReservationCard(
                            reservation: r,
                            l10n: l10n,
                            accentColor: accentColor,
                            isSelected: useMasterDetail &&
                                _selectedReservation?.id == r.id,
                            onTap: () => _onReservationSeeDetails(
                              context,
                              r,
                              useMasterDetail,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ] else ...[
                    FutureBuilder<List<PendingOrder>>(
                      future: _tableOrdersFuture,
                      builder: (context, ordersSnap) {
                        final raw = ordersSnap.data ?? [];
                        final list = applyTableOrdersContentFilter(
                          raw,
                          _tableOrderFilters,
                        )..sort(
                            (a, b) =>
                                b.targetTime.compareTo(a.targetTime),
                          );
                        final countForHeader =
                            ordersSnap.hasData ? list.length : 0;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TableOverviewOrdersHeaderRow(
                              count: countForHeader,
                              l10n: l10n,
                              accentColor: accentColor,
                              theme: theme,
                              onFilterTap: _openTableOrderFilters,
                            ),
                            const SizedBox(height: 12),
                            if (_tableOrdersFuture == null ||
                                ordersSnap.connectionState ==
                                    ConnectionState.waiting)
                              const Padding(
                                padding: EdgeInsets.all(24),
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            else if (ordersSnap.hasError)
                              Text(
                                ordersSnap.error.toString(),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.error,
                                ),
                              )
                            else if (list.isEmpty)
                              Text(
                                l10n.tableOverviewNoOrders,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              )
                            else
                              ...list.map(
                                (o) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: PendingOrderItemsExpansionCard(
                                    order: o,
                                    accentColor: accentColor,
                                    l10n: l10n,
                                    layout: PendingOrderItemsCardLayout.listCompact,
                                    showSeeDetailsButton: false,
                                    showCategoryRows: false,
                                    isSelected: useMasterDetail &&
                                        _isSameTableOrder(_selectedOrder, o),
                                    onTap: () => _onOrderSeeDetails(
                                      context,
                                      o,
                                      useMasterDetail,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                  ],
                  const SizedBox(height: 32),
                ],
              ),
            );

            if (useMasterDetail) {
              return RefreshIndicator(
                onRefresh: _onRefresh,
                color: AppColors.accent,
                child: ConstrainedContent(
                  maxWidth: AppBreakpoints.contentMaxWidthMasterDetail,
                  padding: EdgeInsets.zero,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Expanded(
                        flex: 1,
                        child: CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(child: mainColumn),
                          ],
                        ),
                      ),
                      const VerticalDivider(
                        width: 1,
                        thickness: 1,
                        color: AppColors.border,
                      ),
                      Expanded(
                        flex: 1,
                        child: ColoredBox(
                          color: AppColors.backgroundMuted,
                          child: _buildDetailPane(context, l10n, theme),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: _onRefresh,
              color: AppColors.accent,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: ConstrainedContent(
                      maxWidth: AppBreakpoints.contentMaxWidthWide,
                      padding: EdgeInsets.zero,
                      child: mainColumn,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  void _onReservationSeeDetails(
    BuildContext context,
    ConfirmedReservation r,
    bool useMasterDetail,
  ) {
    if (useMasterDetail) {
      setState(() {
        _selectedReservation = r;
        _selectedOrder = null;
      });
    } else {
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (_) => ConfirmedReservationDetailsScreen(reservation: r),
        ),
      );
    }
  }

  void _onOrderSeeDetails(
    BuildContext context,
    PendingOrder o,
    bool useMasterDetail,
  ) {
    if (useMasterDetail) {
      setState(() {
        _selectedOrder = o;
        _selectedReservation = null;
      });
    } else {
      context.pushNamed(
        AppRouteNames.activeOrderDetails,
        extra: ActiveOrderDetailsScreen(order: o),
      );
    }
  }

  Widget _buildDetailPane(
    BuildContext context,
    AppLocalizations l10n,
    ThemeData theme,
  ) {
    if (_segmentIndex == 0) {
      if (_selectedReservation == null) {
        return _detailPanePlaceholder(theme, l10n);
      }
      return ConfirmedReservationDetailsContent(
        reservation: _selectedReservation!,
        onCompleted: () {
          setState(() => _selectedReservation = null);
          _onRefresh();
        },
      );
    }
    if (_selectedOrder == null) {
      return _detailPanePlaceholder(theme, l10n);
    }
    return ActiveOrderDetailsContent(
      order: _selectedOrder!,
      markOrderAsPaid: () async {
        final venueId = context.read<AuthProvider>().currentVenueId;
        if (venueId == null) return false;
        return context.read<OrdersProvider>().markWaiterOrderAsPaid(
              venueId,
              _selectedOrder!,
            );
      },
      onCompleted: () {
        setState(() => _selectedOrder = null);
        _onRefresh();
      },
    );
  }

  Widget _detailPanePlaceholder(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          l10n.orderSeeDetails,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.textMuted,
          ),
        ),
      ),
    );
  }
}
