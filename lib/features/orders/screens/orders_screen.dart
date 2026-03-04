import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/models/profile_type.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../auth/providers/auth_provider.dart';
import '../domain/models/kitchen_pending_order.dart';
import '../providers/kitchen_orders_provider.dart';
import '../utils/order_time_ago.dart';
import 'order_details_screen.dart';

/// Orders list. For kitchen/chef: fetches pending orders from API (refresh every 30s), oldest first.
/// For waiter/bar: shows empty state (standard placeholder).
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  KitchenOrdersProvider? _kitchenProvider;

  @override
  void dispose() {
    _kitchenProvider?.stopPeriodicRefresh();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;
    final auth = context.watch<AuthProvider>();
    final profileType = auth.profileType;

    if (profileType == ProfileType.kitchen) {
      final kitchenProvider = context.read<KitchenOrdersProvider>();
      _kitchenProvider = kitchenProvider;
      return _KitchenOrdersContent(
        accentColor: accentColor,
        l10n: l10n,
        onStartRefresh: () {
          final user = auth.user;
          final venueId = user?.venueUsers.isNotEmpty == true
              ? user!.venueUsers.first.venueId
              : null;
          if (venueId != null) {
            kitchenProvider.startPeriodicRefresh(venueId);
          }
        },
      );
    }

    return _StandardOrdersPlaceholder(
      l10n: l10n,
      theme: theme,
    );
  }
}

class _KitchenOrdersContent extends StatefulWidget {
  const _KitchenOrdersContent({
    required this.accentColor,
    required this.l10n,
    required this.onStartRefresh,
  });

  final Color accentColor;
  final AppLocalizations l10n;
  final VoidCallback onStartRefresh;

  @override
  State<_KitchenOrdersContent> createState() => _KitchenOrdersContentState();
}

class _KitchenOrdersContentState extends State<_KitchenOrdersContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onStartRefresh());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<KitchenOrdersProvider>();
    final orders = provider.orders;

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
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                widget.l10n.ordersCount(orders.length),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            Expanded(
              child: provider.isLoading && orders.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : provider.error != null && orders.isEmpty
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              provider.error!,
                              textAlign: TextAlign.center,
                              style: TextStyle(color: AppColors.error),
                            ),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          itemCount: orders.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final order = orders[index];
                            return _KitchenOrderCard(
                              order: order,
                              accentColor: widget.accentColor,
                              l10n: widget.l10n,
                              onSeeDetails: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) => OrderDetailsScreen(
                                      order: order,
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _KitchenOrderCard extends StatelessWidget {
  const _KitchenOrderCard({
    required this.order,
    required this.accentColor,
    required this.l10n,
    required this.onSeeDetails,
  });

  final KitchenPendingOrder order;
  final Color accentColor;
  final AppLocalizations l10n;
  final VoidCallback onSeeDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final tableNum = int.tryParse(order.tableNumber) ?? 0;
    final timeAgo = formatOrderTimeAgo(order.targetTime, l10n);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: accentColor),
                const SizedBox(width: 8),
                Text(
                  timeAgo,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const Spacer(),
                Text(
                  l10n.orderTableNumber(tableNum),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.table_bar, size: 18, color: AppColors.textMuted),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              l10n.orderDishCount(order.itemCount),
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '#${order.orderNumber}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onSeeDetails,
                style: FilledButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(l10n.orderSeeDetails),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StandardOrdersPlaceholder extends StatelessWidget {
  const _StandardOrdersPlaceholder({
    required this.l10n,
    required this.theme,
  });

  final AppLocalizations l10n;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundMuted,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Text(
                l10n.ordersTitle,
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                l10n.ordersCount(0),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const Expanded(
              child: Center(
                child: Text(''), // Standard placeholder; no orders from API
              ),
            ),
          ],
        ),
      ),
    );
  }
}
