import 'package:flutter/material.dart';
import 'package:gastrobotmanager/features/orders/screens/order_details_screen.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/models/kitchen_pending_order.dart';
import '../providers/kitchen_orders_provider.dart';
import 'kitchen_order_card.dart';

/// Kitchen orders list: title, count, loading/error/ListView of [KitchenOrderCard].
class KitchenOrdersContent extends StatefulWidget {
  const KitchenOrdersContent({
    super.key,
    required this.accentColor,
    required this.l10n,
    required this.onStartRefresh,
  });

  final Color accentColor;
  final AppLocalizations l10n;
  final VoidCallback onStartRefresh;

  @override
  State<KitchenOrdersContent> createState() => _KitchenOrdersContentState();
}

class _KitchenOrdersContentState extends State<KitchenOrdersContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.onStartRefresh(),
    );
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
                child: orders.isEmpty
                    ? ListView(
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
                      )
                    : ListView.separated(
                        physics: const AlwaysScrollableScrollPhysics(),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 8,
                        ),
                        itemCount: orders.length,
                        separatorBuilder: (_, _) => const SizedBox(height: 12),
                        itemBuilder: (context, index) {
                          final order = orders[index];
                          return KitchenOrderCard(
                            order: order,
                            accentColor: widget.accentColor,
                            l10n: widget.l10n,
                            onSeeDetails: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      OrderDetailsScreen(order: order),
                                ),
                              );
                            },
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
