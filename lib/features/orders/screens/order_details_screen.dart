import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/domain/repositories/order_items_api.dart';
import 'package:gastrobotmanager/features/orders/screens/time_estimation_screen.dart';
import 'package:gastrobotmanager/features/orders/widgets/order_item_tile.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Order details: order number in title, items with checkboxes, Reject All / Accept.
/// Reject All = reject all items (regardless of checked).
/// Accept: for kitchen → time estimation screen; for bar → accept/reject immediately (no time).
class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({
    super.key,
    required this.order,
  });

  final PendingOrder order;

  @override
  Widget build(BuildContext context) {
    return _OrderDetailsContent(order: order);
  }
}

class _OrderDetailsContent extends StatefulWidget {
  const _OrderDetailsContent({required this.order});

  final PendingOrder order;

  @override
  State<_OrderDetailsContent> createState() => _OrderDetailsContentState();
}

class _OrderDetailsContentState extends State<_OrderDetailsContent> {
  late Set<String> _checkedIds;
  final Set<String> _processedIds = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _checkedIds = {
      for (final item in widget.order.items) item.id,
    };
  }

  bool get _allProcessed =>
      widget.order.items.every((i) => _processedIds.contains(i.id));

  /// Reject all items that are not yet processed (regardless of checked state).
  Future<void> _runRejectAll(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final api = context.read<OrderItemsApi>();
    final venueId = auth.user?.venueUsers.isNotEmpty == true
        ? auth.user!.venueUsers.first.venueId
        : null;
    if (venueId == null) return;

    final toProcess = [
      for (final item in widget.order.items)
        if (!_processedIds.contains(item.id)) item.id,
    ];
    if (toProcess.isEmpty) return;

    for (final itemId in toProcess) {
      try {
        await api.rejectOrderItem(
          venueId,
          widget.order.orderId,
          itemId,
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
      Navigator.of(context).pop(true);
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

  /// For bar: accept checked items (no time), reject unchecked; then pop and show success.
  Future<void> _runBarAccept(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final api = context.read<OrderItemsApi>();
    final venueId = auth.user?.venueUsers.isNotEmpty == true
        ? auth.user!.venueUsers.first.venueId
        : null;
    if (venueId == null) return;

    final unprocessed = [
      for (final item in widget.order.items)
        if (!_processedIds.contains(item.id)) item.id,
    ];
    if (unprocessed.isEmpty) return;

    final toReject =
        unprocessed.where((id) => !_checkedIds.contains(id)).toList();
    final toAccept =
        unprocessed.where((id) => _checkedIds.contains(id)).toList();

    setState(() => _isSubmitting = true);

    try {
      for (final itemId in toReject) {
        await api.rejectOrderItem(
          venueId,
          widget.order.orderId,
          itemId,
        );
      }
      for (final itemId in toAccept) {
        await api.acceptOrderItem(
          venueId,
          widget.order.orderId,
          itemId,
        );
      }
      if (!mounted) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!
                .orderProcessingComplete(widget.order.orderNumber),
          ),
          backgroundColor: AppColors.success,
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.authInvalidResponse),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  /// Navigate to time estimation screen. Checked = accept (with/without time),
  /// unchecked = reject (handled on that screen).
  void _openTimeEstimation(BuildContext context) {
    final toAccept = _checkedIds.where((id) => !_processedIds.contains(id));
    if (toAccept.isEmpty) return;

    Navigator.of(context)
        .push<bool>(
          MaterialPageRoute<bool>(
            builder: (_) => TimeEstimationScreen(
              order: widget.order,
              checkedItemIds: Set.from(_checkedIds),
            ),
          ),
        )
        .then((result) {
      if (!context.mounted || result != true) return;
      Navigator.of(context).pop(true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(context)!
                .orderProcessingComplete(widget.order.orderNumber),
          ),
          backgroundColor: AppColors.success,
        ),
      );
    });
  }

  void _onAcceptPressed(BuildContext context) {
    final profileType = context.read<AuthProvider>().profileType;
    if (profileType == ProfileType.bar) {
      _runBarAccept(context);
    } else {
      _openTimeEstimation(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accentColor = Theme.of(context).colorScheme.primary;
    final unprocessed = _checkedIds.where((id) => !_processedIds.contains(id));
    final isRejectDisabled = unprocessed.isEmpty || _isSubmitting;
    final isAcceptDisabled = unprocessed.isEmpty || _isSubmitting;

    return Scaffold(
      backgroundColor: AppColors.backgroundMuted,
      appBar: AppBar(
        title: Text(widget.order.orderNumber),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
      ),
      body: Stack(
        children: [
          Column(
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
                    onPressed:
                        isRejectDisabled ? null : () => _runRejectAll(context),
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
                    onPressed: isAcceptDisabled
                        ? null
                        : () => _onAcceptPressed(context),
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
          if (_isSubmitting)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            ),
        ],
      ),
    );
  }
}
