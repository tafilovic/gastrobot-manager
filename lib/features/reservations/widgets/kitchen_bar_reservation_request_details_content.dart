import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/navigation/fade_slide_page_route.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/domain/repositories/order_items_api.dart';
import 'package:gastrobotmanager/features/orders/screens/time_estimation_screen.dart';
import 'package:gastrobotmanager/features/reservations/utils/format_reservation_date.dart';
import 'package:gastrobotmanager/features/reservations/widgets/reservation_item_tile.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Reusable kitchen/bar reservation request details body.
/// Used in [ReservationDetailsScreen] and in master-detail detail pane.
class KitchenBarReservationRequestDetailsContent extends StatefulWidget {
  const KitchenBarReservationRequestDetailsContent({
    super.key,
    required this.order,
    this.onCompleted,
  });

  final PendingOrder order;
  final VoidCallback? onCompleted;

  @override
  State<KitchenBarReservationRequestDetailsContent> createState() =>
      _KitchenBarReservationRequestDetailsContentState();
}

class _KitchenBarReservationRequestDetailsContentState
    extends State<KitchenBarReservationRequestDetailsContent> {
  late Set<String> _checkedIds;
  final Set<String> _processedIds = {};
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    _checkedIds = {for (final item in widget.order.items) item.id};
  }

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
          content: Text(l10n.orderProcessingComplete(widget.order.orderNumber)),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }

  Future<void> _runRejectAll(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final api = context.read<OrderItemsApi>();
    final venueId = auth.currentVenueId;
    if (venueId == null) return;

    final toProcess = [
      for (final item in widget.order.items)
        if (!_processedIds.contains(item.id)) item.id,
    ];
    if (toProcess.isEmpty) return;

    for (final itemId in toProcess) {
      try {
        await api.rejectOrderItem(venueId, widget.order.orderId, itemId);
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
      _onComplete();
    }
  }

  Future<void> _runBarAccept(BuildContext context) async {
    final auth = context.read<AuthProvider>();
    final api = context.read<OrderItemsApi>();
    final venueId = auth.currentVenueId;
    if (venueId == null) return;

    final unprocessed = [
      for (final item in widget.order.items)
        if (!_processedIds.contains(item.id)) item.id,
    ];
    if (unprocessed.isEmpty) return;

    final toReject = unprocessed
        .where((id) => !_checkedIds.contains(id))
        .toList();
    final toAccept = unprocessed
        .where((id) => _checkedIds.contains(id))
        .toList();

    setState(() => _isSubmitting = true);

    try {
      for (final itemId in toReject) {
        await api.rejectOrderItem(venueId, widget.order.orderId, itemId);
      }
      for (final itemId in toAccept) {
        await api.acceptOrderItem(venueId, widget.order.orderId, itemId);
      }
      if (!mounted) return;
      _onComplete();
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
    if (profileType == ProfileType.bar || profileType == ProfileType.waiter) {
      _runBarAccept(context);
    } else {
      _openTimeEstimation(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accentColor = Theme.of(context).colorScheme.primary;
    final profileType = context.watch<AuthProvider>().profileType;
    final itemIcon = profileType == ProfileType.kitchen
        ? Icons.restaurant
        : Icons.local_bar;
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = formatReservationDate(
      widget.order.targetTime,
      l10n,
      locale: locale,
    );
    final timeStr = formatReservationTime(widget.order.targetTime);
    final unprocessed = _checkedIds.where((id) => !_processedIds.contains(id));
    final isRejectDisabled = unprocessed.isEmpty || _isSubmitting;
    final isAcceptDisabled = unprocessed.isEmpty || _isSubmitting;

    return Stack(
      children: [
        Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
              child: Row(
                children: [
                  Icon(Icons.calendar_today, size: 20, color: accentColor),
                  const SizedBox(width: 8),
                  Text(
                    dateStr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    timeStr,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.access_time, size: 20, color: accentColor),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: widget.order.items.length,
                separatorBuilder: (_, _) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = widget.order.items[index];
                  final isChecked = _checkedIds.contains(item.id);
                  final isDisabled = _processedIds.contains(item.id);
                  return ReservationItemTile(
                    item: item,
                    isChecked: isChecked,
                    accentColor: accentColor,
                    isDisabled: isDisabled,
                    itemIcon: itemIcon,
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
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}
