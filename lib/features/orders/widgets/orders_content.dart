import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/app_breakpoints.dart';
import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/providers/orders_provider.dart';
import 'package:gastrobotmanager/features/orders/screens/order_details_screen.dart';
import 'package:gastrobotmanager/features/orders/widgets/kitchen_order_card.dart';
import 'package:gastrobotmanager/features/orders/widgets/order_details_content.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Single orders list for kitchen and bar: title, count, loading/error/ListView.
/// Item count label is derived from [AuthProvider.profileType] (e.g. "Broj pića" for bar).
class OrdersContent extends StatefulWidget {
  const OrdersContent({
    super.key,
    required this.accentColor,
    required this.l10n,
    required this.onStartRefresh,
  });

  final Color accentColor;
  final AppLocalizations l10n;
  final VoidCallback onStartRefresh;

  @override
  State<OrdersContent> createState() => _OrdersContentState();
}

class _OrdersContentState extends State<OrdersContent> {
  PendingOrder? _selectedOrder;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.onStartRefresh(),
    );
  }

  /// Bar uses "Broj pića"; kitchen uses card default (Broj jela). Null = use default.
  static String? _itemCountLabel(
    AppLocalizations l10n,
    ProfileType? profileType,
    PendingOrder order,
  ) {
    if (profileType == ProfileType.bar) {
      return l10n.orderDrinksCount(order.itemCount);
    }
    return null;
  }

  Future<void> _openDetails(
    PendingOrder order,
    OrdersProvider provider,
  ) async {
    final completed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => OrderDetailsScreen(order: order),
      ),
    );
    if (completed == true && context.mounted) {
      provider.pullRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final provider = context.watch<OrdersProvider>();
    final profileType = context.watch<AuthProvider>().profileType;
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
                child: _buildListPane(
                  theme,
                  provider,
                  orders,
                  profileType,
                  onSeeDetails,
                ),
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
              child: Text.rich(
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
            ),
            Expanded(
              child: ConstrainedContent(
                padding: EdgeInsets.zero,
                child: RefreshIndicator(
                  onRefresh: () => provider.pullRefresh(),
                  child: _buildList(
                    orders,
                    provider,
                    profileType,
                    onSeeDetails,
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
    ProfileType? profileType,
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
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
          child: Text.rich(
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
        ),
        Expanded(
          child: RefreshIndicator(
            onRefresh: () => provider.pullRefresh(),
            child: _buildList(
              orders,
              provider,
              profileType,
              onSeeDetails,
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
    ProfileType? profileType,
    void Function(PendingOrder) onSeeDetails,
  ) {
    if (orders.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.5,
            child: provider.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        provider.error ?? '',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: AppColors.error,
                        ),
                      ),
                    ),
                  ),
          ),
        ],
      );
    }
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 8,
      ),
      itemCount: orders.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final order = orders[index];
        return KitchenOrderCard(
          order: order,
          accentColor: widget.accentColor,
          l10n: widget.l10n,
          itemCountLabel: _itemCountLabel(
            widget.l10n,
            profileType,
            order,
          ),
          onSeeDetails: () => onSeeDetails(order),
        );
      },
    );
  }
}
