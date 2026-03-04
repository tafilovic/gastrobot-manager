import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../domain/models/kitchen_order_item.dart';
import '../domain/models/kitchen_pending_order.dart';
import '../utils/order_time_ago.dart';
import '../widgets/order_item_tile.dart';

/// Detail view for a single kitchen order: header with order number, time and table, items list, Accept/Reject.
class OrderDetailsScreen extends StatefulWidget {
  const OrderDetailsScreen({super.key, required this.order});

  final KitchenPendingOrder order;

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final Set<String> _checkedItemIds = {};

  @override
  void initState() {
    super.initState();
    for (final item in widget.order.items) {
      _checkedItemIds.add(item.id);
    }
  }

  bool _isItemChecked(KitchenOrderItem item) =>
      _checkedItemIds.contains(item.id);

  void _toggleItem(KitchenOrderItem item) {
    setState(() {
      if (_checkedItemIds.contains(item.id)) {
        _checkedItemIds.remove(item.id);
      } else {
        _checkedItemIds.add(item.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;
    final order = widget.order;
    final tableNum = int.tryParse(order.tableNumber) ?? 0;
    final timeAgo = formatOrderTimeAgo(order.targetTime, l10n);

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text('# ${order.orderNumber}'),
        centerTitle: true,
        backgroundColor: AppColors.appBarBackground,
        foregroundColor: AppColors.appBarForeground,
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
            child: Row(
              children: [
                Icon(Icons.access_time, size: 18, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Text(
                  timeAgo,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
                const Spacer(),
                Icon(Icons.table_bar, size: 18, color: AppColors.textMuted),
                const SizedBox(width: 8),
                Text(
                  l10n.orderTableNumber(tableNum),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              itemCount: order.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = order.items[index];
                return OrderItemTile(
                  item: item,
                  isChecked: _isItemChecked(item),
                  accentColor: accentColor,
                  onTap: () => _toggleItem(item),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.destructive,
                      foregroundColor: AppColors.onDestructive,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(l10n.orderRejectAll),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _checkedItemIds.isEmpty
                        ? null
                        : () => Navigator.of(context).pop(),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: AppColors.onSuccess,
                      disabledBackgroundColor: AppColors.success.withValues(alpha: 0.5),
                      disabledForegroundColor: AppColors.onSuccess.withValues(alpha: 0.7),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(l10n.orderAccept),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
