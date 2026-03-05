import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../providers/kitchen_queue_provider.dart';
import 'preparing_order_card.dart';

/// Preparing list for chef: title, dish count, loading/error/list of [PreparingOrderCard].
class PreparingContent extends StatefulWidget {
  const PreparingContent({
    super.key,
    required this.accentColor,
    required this.onStartRefresh,
  });

  final Color accentColor;
  final VoidCallback onStartRefresh;

  @override
  State<PreparingContent> createState() => _PreparingContentState();
}

class _PreparingContentState extends State<PreparingContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onStartRefresh());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final provider = context.watch<KitchenQueueProvider>();
    final orders = provider.orders;
    final totalDishes = orders.fold<int>(0, (sum, o) => sum + o.itemCount);

    return Scaffold(
      backgroundColor: AppColors.backgroundMuted,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Text(
                l10n.preparingTitle,
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
                      text: '$totalDishes',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: widget.accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    TextSpan(text: l10n.preparingDishCountSuffix),
                  ],
                ),
              ),
            ),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () => provider.pullRefresh(),
                child: provider.isLoading && orders.isEmpty
                    ? ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ),
                        ],
                      )
                    : provider.error != null && orders.isEmpty
                        ? ListView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            children: [
                              SizedBox(
                                height: MediaQuery.of(context).size.height * 0.5,
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Text(
                                      provider.error!,
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
                            separatorBuilder: (_, __) =>
                                const SizedBox(height: 12),
                            itemBuilder: (context, index) {
                              final order = orders[index];
                              return PreparingOrderCard(
                                order: order,
                                l10n: l10n,
                                accentColor: widget.accentColor,
                                onMarkReady: () async {
                                  final ok = await provider.markOrderAsReady(order);
                                  if (!context.mounted) return;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        ok
                                            ? l10n.preparingMarkAsReadySuccess
                                            : (provider.error ?? l10n.preparingMarkAsReadyError),
                                      ),
                                      backgroundColor:
                                          ok ? AppColors.success : AppColors.error,
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
