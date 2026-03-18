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

/// Reservation details: "Rezervacije" + # in app bar, date/time row, items with checkboxes, ODBIJ SVE / PRIHVATI.
/// Bar/waiter = direct accept; kitchen = time estimation screen. Uses [OrderItemsApi].
class ReservationDetailsScreen extends StatefulWidget {
  const ReservationDetailsScreen({
    super.key,
    required this.order,
  });

  final PendingOrder order;

  @override
  State<ReservationDetailsScreen> createState() =>
      _ReservationDetailsScreenState();
}

class _ReservationDetailsScreenState extends State<ReservationDetailsScreen> {
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

    final toReject =
        unprocessed.where((id) => !_checkedIds.contains(id)).toList();
    final toAccept =
        unprocessed.where((id) => _checkedIds.contains(id)).toList();

    setState(() => _isSubmitting = true);

    try {
      for (final itemId in toReject) {
        await api.rejectOrderItem(venueId, widget.order.orderId, itemId);
      }
      for (final itemId in toAccept) {
        await api.acceptOrderItem(venueId, widget.order.orderId, itemId);
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
    if (profileType == ProfileType.waiter) {
      return _buildWaiterDetails(context, l10n, accentColor);
    }
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

    return Scaffold(
      backgroundColor: AppColors.backgroundMuted,
      appBar: AppBar(
        title: Text(l10n.reservationsTitle),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.backgroundMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '#${widget.order.orderNumber}',
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Stack(
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
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
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
      ),
    );
  }

  Widget _buildWaiterDetails(
    BuildContext context,
    AppLocalizations l10n,
    Color accentColor,
  ) {
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = formatReservationDate(
      widget.order.targetTime,
      l10n,
      locale: locale,
    );
    final timeStr = formatReservationTime(widget.order.targetTime);

    final d = widget.order.reservationDetails;
    final Map<String, dynamic> rd =
        d is Map ? Map<String, dynamic>.from(d as Map) : <String, dynamic>{};

    final userName = rd['userName']?.toString().trim();
    final regionRaw = rd['region']?.toString().trim();
    final region =
        (regionRaw != null && regionRaw.isNotEmpty) ? regionRaw : 'N/A';
    final partySize = rd['partySize'];
    final party = partySize is int ? partySize : int.tryParse('$partySize');
    final occasion = rd['occasion']?.toString().trim();
    final note = rd['note']?.toString().trim();

    final hasFood = widget.order.items.any((i) => i.type == 'food');
    final hasDrinks = widget.order.items.any((i) => i.type == 'drink');
    final hasAnyItems = widget.order.items.isNotEmpty;

    final foodItems =
        widget.order.items.where((i) => i.type == 'food').toList();
    final drinkItems =
        widget.order.items.where((i) => i.type == 'drink').toList();

    Widget detailsRow(IconData icon, String label, String value) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 18, color: AppColors.textMuted),
            const SizedBox(width: 10),
            Expanded(
              child: Text.rich(
                TextSpan(
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                  children: [
                    TextSpan(text: '$label '),
                    TextSpan(
                      text: value,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    Widget sectionHeader(String title) {
      return Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 8),
        child: Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
        ),
      );
    }

    Widget itemLine(String name, int qty, {String? notes}) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  if (notes != null && notes.trim().isNotEmpty) ...[
                    const SizedBox(height: 2),
                    Text(
                      notes,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMuted,
                            fontStyle: FontStyle.italic,
                          ),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'x$qty',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundMuted,
      appBar: AppBar(
        title: Text(l10n.reservationsTitle),
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.backgroundMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  widget.order.orderNumber.isNotEmpty
                      ? widget.order.orderNumber
                      : widget.order.orderId,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: Column(
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
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const Spacer(),
                Text(
                  timeStr,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.access_time, size: 20, color: accentColor),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              children: [
                detailsRow(
                  Icons.person,
                  'Korisnik:',
                  (userName != null && userName.isNotEmpty) ? userName : 'N/A',
                ),
                detailsRow(Icons.map, l10n.reservationLabelRegion, region),
                detailsRow(
                  Icons.groups,
                  l10n.reservationLabelPartySize,
                  party != null ? '$party' : 'N/A',
                ),
                detailsRow(
                  Icons.restaurant,
                  'Hrana/Piće:',
                  hasAnyItems
                      ? '${hasFood ? l10n.dialogYes : l10n.dialogNo} / ${hasDrinks ? l10n.dialogYes : l10n.dialogNo}'
                      : 'N/A',
                ),
                detailsRow(
                  Icons.celebration,
                  'Povod:',
                  (occasion != null && occasion.isNotEmpty) ? occasion : 'N/A',
                ),
                detailsRow(
                  Icons.note,
                  'Napomena:',
                  (note != null && note.isNotEmpty) ? note : 'N/A',
                ),
                if (foodItems.isNotEmpty) ...[
                  sectionHeader(l10n.readySectionFood),
                  ...foodItems.map(
                    (i) => itemLine(i.name, i.quantity, notes: i.notes),
                  ),
                ],
                if (drinkItems.isNotEmpty) ...[
                  sectionHeader(l10n.readySectionDrinks),
                  ...drinkItems.map(
                    (i) => itemLine(i.name, i.quantity, notes: i.notes),
                  ),
                ],
              ],
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
                    onPressed: () {
                      // TODO: hook up rejection endpoint for waiter reservations
                      Navigator.of(context).pop(false);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.destructive,
                      foregroundColor: AppColors.onDestructive,
                    ),
                    child: const Text('ODBIJ'),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () {
                      // TODO: hook up availability check/confirmation flow
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.success,
                      foregroundColor: AppColors.onSuccess,
                    ),
                    child: const Text('PROVERI DOSTUPNOST'),
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
