import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/app_breakpoints.dart';
import 'package:gastrobotmanager/core/navigation/app_router.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/providers/orders_provider.dart';
import 'package:gastrobotmanager/features/orders/screens/active_order_details_screen.dart';
import 'package:gastrobotmanager/features/orders/widgets/waiter_order_card.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/reservations/screens/confirmed_reservation_details_screen.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';
import 'package:gastrobotmanager/features/tables/providers/tables_provider.dart';
import 'package:gastrobotmanager/features/tables/utils/pending_orders_for_table.dart';
import 'package:gastrobotmanager/features/tables/widgets/table_overview_active_order_card.dart';
import 'package:gastrobotmanager/features/tables/widgets/table_overview_header.dart';
import 'package:gastrobotmanager/features/tables/widgets/table_overview_reservation_card.dart';
import 'package:gastrobotmanager/features/tables/widgets/table_overview_reservation_count_row.dart';
import 'package:gastrobotmanager/features/tables/widgets/table_overview_segmented_tabs.dart';
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
    });
    await _reservationsFuture;
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
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundMuted,
      appBar: AppBar(
        title: Text(l10n.navTables),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      body: FutureBuilder<List<ConfirmedReservation>>(
        future: future,
        builder: (context, snapshot) {
          final reservations = snapshot.data ?? [];
          final reservationsError = snapshot.error;

          return RefreshIndicator(
            onRefresh: _onRefresh,
            color: AppColors.accent,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              slivers: [
                SliverToBoxAdapter(
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxWidth: AppBreakpoints.contentMaxWidth,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            TableOverviewHeader(
                              table: widget.table,
                              l10n: l10n,
                              typeLabel: _typeLabel(l10n),
                            ),
                            const SizedBox(height: 16),
                            if (!widget.table.isFree)
                              Consumer<OrdersProvider>(
                                builder: (context, orders, _) {
                                  final primary = _primaryOrder(orders.orders);
                                  if (primary == null) {
                                    return const SizedBox.shrink();
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
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
                                      const SizedBox(height: 16),
                                    ],
                                  );
                                },
                              ),
                            const SizedBox(height: 20),
                            TableOverviewSegmentedTabs(
                              accentColor: accentColor,
                              selectedIndex: _segmentIndex,
                              reservationsLabel: l10n.navReservations,
                              ordersLabel: l10n.navOrders,
                              onChanged: (i) =>
                                  setState(() => _segmentIndex = i),
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
                                      onSeeDetails: () {
                                        Navigator.of(context).push(
                                          MaterialPageRoute<void>(
                                            builder: (_) =>
                                                ConfirmedReservationDetailsScreen(
                                              reservation: r,
                                            ),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ] else ...[
                              Consumer<OrdersProvider>(
                                builder: (context, orders, _) {
                                  final list = pendingOrdersForTable(
                                    orders.orders,
                                    widget.table,
                                  );
                                  if (list.isEmpty) {
                                    return Text(
                                      l10n.tableOverviewNoOrders,
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                        color: AppColors.textSecondary,
                                      ),
                                    );
                                  }
                                  return Column(
                                    children: list
                                        .map(
                                          (o) => Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 12,
                                            ),
                                            child: WaiterOrderCard(
                                              order: o,
                                              accentColor: accentColor,
                                              l10n: l10n,
                                              onSeeDetails: () {
                                                context.pushNamed(
                                                  AppRouteNames
                                                      .activeOrderDetails,
                                                  extra:
                                                      ActiveOrderDetailsScreen(
                                                    order: o,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                        )
                                        .toList(),
                                  );
                                },
                              ),
                            ],
                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
