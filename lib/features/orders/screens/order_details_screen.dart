import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/theme/app_colors.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../auth/providers/auth_provider.dart';
import '../domain/models/kitchen_pending_order.dart';
import '../domain/repositories/order_items_api.dart';
import '../widgets/order_item_tile.dart';

/// Order details: order number in title, items with checkboxes, Accept / Reject.
/// One request per checked item; when done item is disabled; when all done, pop and show message.
class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  final KitchenPendingOrder order;

  @override
  Widget build(BuildContext context) {
    return _OrderDetailsContent(order: order);
  }
}

class _OrderDetailsContent extends StatefulWidget {
  const _OrderDetailsContent({required this.order});

  final KitchenPendingOrder order;

  @override
  State<_OrderDetailsContent> createState() => _OrderDetailsContentState();
}

class _OrderDetailsContentState extends State<_OrderDetailsContent> {
  late Set<String> _checkedIds;
  final Set<String> _processedIds = {};

  @override
  void initState() {
    super.initState();
    _checkedIds = {
      for (final item in widget.order.items) item.id,
    };
  }

  bool get _allProcessed =>
      widget.order.items.every((i) => _processedIds.contains(i.id));

  Future<void> _runRejectAll(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final api = context.read<OrderItemsApi>();
    final venueId = auth.user?.venueUsers.isNotEmpty == true
        ? auth.user!.venueUsers.first.venueId
        : null;
    final accessToken = auth.accessToken;
    if (venueId == null || accessToken == null) return;

    final toProcess =
        _checkedIds.where((id) => !_processedIds.contains(id)).toList();
    if (toProcess.isEmpty) return;

    for (final itemId in toProcess) {
      try {
        await api.rejectOrderItem(
          venueId,
          widget.order.orderId,
          itemId,
          accessToken,
        );
        if (!mounted) return;
        setState(() => _processedIds.add(itemId));
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.authInvalidResponse),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }
    if (!mounted) return;
    if (_allProcessed) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!
                .orderProcessingComplete(widget.order.orderNumber),
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _runAccept(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final api = context.read<OrderItemsApi>();
    final venueId = auth.user?.venueUsers.isNotEmpty == true
        ? auth.user!.venueUsers.first.venueId
        : null;
    final accessToken = auth.accessToken;
    if (venueId == null || accessToken == null) return;

    final toProcess =
        _checkedIds.where((id) => !_processedIds.contains(id)).toList();
    if (toProcess.isEmpty) return;

    for (final itemId in toProcess) {
      try {
        await api.acceptOrderItem(
          venueId,
          widget.order.orderId,
          itemId,
          accessToken,
        );
        if (!mounted) return;
        setState(() => _processedIds.add(itemId));
      } catch (_) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.authInvalidResponse),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }
    }
    if (!mounted) return;
    if (_allProcessed) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!
                .orderProcessingComplete(widget.order.orderNumber),
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accentColor = Theme.of(context).colorScheme.primary;
    final toReject = _checkedIds.where((id) => !_processedIds.contains(id));
    final toAccept = toReject;
    final isRejectDisabled = toReject.isEmpty;
    final isAcceptDisabled = toAccept.isEmpty;

    return Scaffold(
      backgroundColor: AppColors.backgroundMuted,
      appBar: AppBar(
        title: Text(widget.order.orderNumber),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: widget.order.items.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = widget.order.items[index];
                final isChecked = _checkedIds.contains(item.id);
                final isDisabled = _processedIds.contains(item.id);
                return OrderItemTile(
                  item: item,
                  isChecked: isChecked,
                  accentColor: accentColor,
                  isDisabled: isDisabled,
                  onTap: isDisabled
                      ? null
                      : () {
                          setState(() {
                            if (isChecked) {
                              _checkedIds.remove(item.id);
                            } else {
                              _checkedIds.add(item.id);
                            }
                          });
                        },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            color: AppColors.surface,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: isRejectDisabled
                        ? null
                        : () => _runRejectAll(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.destructive,
                      foregroundColor: AppColors.onDestructive,
                    ),
                    child: Text(l10n.orderRejectAll),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed:
                        isAcceptDisabled ? null : () => _runAccept(context),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: AppColors.onSuccess,
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
