import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/currency/venue_currency_format.dart';
import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/navigation/fade_slide_page_route.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order_item.dart';
import 'package:gastrobotmanager/features/orders/domain/repositories/order_items_api.dart';
import 'package:gastrobotmanager/features/orders/screens/time_estimation_screen.dart';
import 'package:gastrobotmanager/features/orders/utils/order_items_total_price_sum.dart';
import 'package:gastrobotmanager/features/orders/widgets/order_item_tile.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Reusable order details body: items list, Reject All / Accept.
/// When used in a pane, pass [onCompleted] to refresh list and clear selection.
/// When used full-screen, [onCompleted] is null and completion pops the route.
class OrderDetailsContent extends StatefulWidget {
  const OrderDetailsContent({
    super.key,
    required this.order,
    this.onCompleted,
    this.useBarAcceptFlow = false,
    this.barActionsDrinksOnly = false,
  });

  final PendingOrder order;
  final VoidCallback? onCompleted;
  final bool useBarAcceptFlow;

  /// When true with [useBarAcceptFlow], only pending drinks are accept/reject
  /// targets; food stays for kitchen.
  final bool barActionsDrinksOnly;

  @override
  State<OrderDetailsContent> createState() => _OrderDetailsContentState();
}

class _OrderDetailsContentState extends State<OrderDetailsContent> {
  late Set<String> _checkedIds;
  late Set<String> _processedIds;
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _processedIds = {
      for (final item in widget.order.items)
        if (!_isActionableStatus(item.status)) item.id,
    };
    if (_effectiveBarDrinksOnly) {
      _checkedIds = {
        for (final item in widget.order.items)
          if (!_processedIds.contains(item.id) && _isDrinkPending(item))
            item.id,
      };
    } else {
      _checkedIds = {
        for (final item in widget.order.items)
          if (!_processedIds.contains(item.id)) item.id,
      };
    }
  }

  bool get _effectiveBarDrinksOnly =>
      widget.useBarAcceptFlow && widget.barActionsDrinksOnly;

  bool _isDrinkPending(PendingOrderItem item) =>
      _isActionableStatus(item.status) && item.type == 'drink';

  /// Pending food or unknown type: waiter must not act; kitchen handles food.
  bool _isRowLockedForWaiterBar(PendingOrderItem item) =>
      _effectiveBarDrinksOnly &&
      _isActionableStatus(item.status) &&
      item.type != 'drink';

  bool _isActionableStatus(String status) =>
      status.trim().toLowerCase() == 'pending';

  bool get _allProcessed =>
      widget.order.items.every((i) => _processedIds.contains(i.id));

  void _onComplete() {
    if (widget.onCompleted != null) {
      widget.onCompleted!();
    } else {
      Navigator.of(context).pop(true);
    }
    if (!mounted) return;
    final l10n = AppLocalizations.of(context);
    final messenger = ScaffoldMessenger.maybeOf(context);
    if (messenger != null && l10n != null) {
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            l10n.orderProcessingComplete(widget.order.orderNumber),
          ),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  /// Reject all items that are not yet processed (regardless of checked state).
  Future<void> _runRejectAll(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final api = context.read<OrderItemsApi>();
    final venueId = auth.currentVenueId;
    if (venueId == null) return;

    final List<String> toProcess;
    if (_effectiveBarDrinksOnly) {
      toProcess = [
        for (final item in widget.order.items)
          if (!_processedIds.contains(item.id) && _isDrinkPending(item))
            item.id,
      ];
    } else {
      toProcess = [
        for (final item in widget.order.items)
          if (!_processedIds.contains(item.id)) item.id,
      ];
    }
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
      } catch (e) {
        if (!mounted) return;
        final l10n = AppLocalizations.of(context);
        final messenger = ScaffoldMessenger.maybeOf(context);
        if (messenger != null && l10n != null) {
          messenger.showSnackBar(
            SnackBar(
              content: Text(l10n.authInvalidResponse),
              backgroundColor: AppColors.error,
            ),
          );
        }
        return;
      }
    }
    if (!mounted) return;
    if (_allProcessed) {
      _onComplete();
    }
  }

  /// For bar: accept checked items (no time), reject unchecked; then complete.
  Future<void> _runBarAccept(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final api = context.read<OrderItemsApi>();
    final venueId = auth.currentVenueId;
    if (venueId == null) return;

    final List<String> unprocessed;
    if (_effectiveBarDrinksOnly) {
      unprocessed = [
        for (final item in widget.order.items)
          if (!_processedIds.contains(item.id) && _isDrinkPending(item))
            item.id,
      ];
    } else {
      unprocessed = [
        for (final item in widget.order.items)
          if (!_processedIds.contains(item.id)) item.id,
      ];
    }
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
      _onComplete();
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      final l10n = AppLocalizations.of(context);
      final messenger = ScaffoldMessenger.maybeOf(context);
      if (messenger != null && l10n != null) {
        messenger.showSnackBar(
          SnackBar(
            content: Text(l10n.authInvalidResponse),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  /// Navigate to time estimation screen. Checked = accept, unchecked = reject.
  void _openTimeEstimation(BuildContext context) {
    final toAccept = _checkedIds.where((id) => !_processedIds.contains(id));
    if (toAccept.isEmpty) return;

    Navigator.of(context)
        .push<bool>(
          FadeSlidePageRoute<bool>(
            builder: (_) => TimeEstimationScreen(
              order: widget.order,
              checkedItemIds: Set.from(_checkedIds),
            ),
          ),
        )
        .then((result) {
      if (!context.mounted || result != true) return;
      _onComplete();
    });
  }

  void _onAcceptPressed(BuildContext context) {
    final profileType = context.read<AuthProvider>().profileType;
    if (widget.useBarAcceptFlow || profileType == ProfileType.bar) {
      _runBarAccept(context);
    } else {
      _openTimeEstimation(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accentColor = Theme.of(context).colorScheme.primary;
    final Iterable<String> unprocessedIds = _effectiveBarDrinksOnly
        ? widget.order.items
            .where(
              (item) =>
                  !_processedIds.contains(item.id) && _isDrinkPending(item),
            )
            .map((item) => item.id)
        : widget.order.items
            .map((item) => item.id)
            .where((id) => !_processedIds.contains(id));
    final checkedUnprocessedIds = _checkedIds.where((id) {
      if (_processedIds.contains(id)) return false;
      if (!_effectiveBarDrinksOnly) return true;
      final item = widget.order.items.firstWhere((i) => i.id == id);
      return _isDrinkPending(item);
    });
    final isRejectDisabled = unprocessedIds.isEmpty || _isSubmitting;
    final isAcceptDisabled = checkedUnprocessedIds.isEmpty || _isSubmitting;
    final foodItems = widget.order.items
        .where((item) => item.type == null || item.type == 'food')
        .toList();
    final drinkItems =
        widget.order.items.where((item) => item.type == 'drink').toList();
    final venueCurrency = context.read<AuthProvider>().currentVenueCurrency;
    final effectiveVenueCurrency =
        venueCurrency == null || venueCurrency.trim().isEmpty
            ? 'RSD'
            : venueCurrency;
    final billTotal = formatVenueAmountForDisplay(
      context,
      orderItemsTotalPriceSum(widget.order.items) ?? 0,
      effectiveVenueCurrency,
    );

    return Stack(
      children: [
        Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  if (foodItems.isNotEmpty)
                    _OrderItemsSection(
                      icon: Icons.restaurant,
                      label: l10n.ordersFoodLabel,
                      children: [
                        for (var index = 0;
                            index < foodItems.length;
                            index++) ...[
                          _buildItemTile(foodItems[index], accentColor),
                          if (index < foodItems.length - 1)
                            const SizedBox(height: 12),
                        ],
                      ],
                    ),
                  if (foodItems.isNotEmpty && drinkItems.isNotEmpty)
                    const SizedBox(height: 20),
                  if (drinkItems.isNotEmpty)
                    _OrderItemsSection(
                      icon: Icons.local_bar,
                      label: l10n.ordersDrinksLabel,
                      children: [
                        for (var index = 0;
                            index < drinkItems.length;
                            index++) ...[
                          _buildItemTile(drinkItems[index], accentColor),
                          if (index < drinkItems.length - 1)
                            const SizedBox(height: 12),
                        ],
                      ],
                    ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(20),
              color: AppColors.surface,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Text(
                        l10n.orderBill,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        billTotal,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 16),
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
    );
  }

  Widget _buildItemTile(PendingOrderItem item, Color accentColor) {
    final isChecked = _checkedIds.contains(item.id);
    final isLocked = _isRowLockedForWaiterBar(item);
    final isDisabled = _processedIds.contains(item.id) || isLocked;
    return OrderItemTile(
      key: ValueKey(item.id),
      item: item,
      isChecked: isChecked,
      accentColor: accentColor,
      isDisabled: isDisabled,
      isLocked: isLocked,
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
  }
}

class _OrderItemsSection extends StatelessWidget {
  const _OrderItemsSection({
    required this.icon,
    required this.label,
    required this.children,
  });

  final IconData icon;
  final String label;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _SectionHeader(icon: icon, label: label),
        const SizedBox(height: 12),
        ...children,
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textPrimary),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
