import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/pending_reservation.dart';
import 'package:gastrobotmanager/features/regions/providers/regions_provider.dart';
import 'package:gastrobotmanager/features/reservations/providers/reservations_provider.dart';
import 'package:gastrobotmanager/features/reservations/utils/format_reservation_date.dart';
import 'package:gastrobotmanager/features/reservations/widgets/accept_reservation_sheet.dart';
import 'package:gastrobotmanager/features/reservations/widgets/reservation_date_time_header.dart';
import 'package:gastrobotmanager/features/reservations/widgets/reservation_detail_row.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Reusable waiter reservation request details body.
/// Used in [WaiterReservationDetailsScreen] and in master-detail detail pane.
class WaiterReservationRequestDetailsContent extends StatelessWidget {
  const WaiterReservationRequestDetailsContent({
    super.key,
    required this.reservation,
    this.onCompleted,
  });

  final PendingReservation reservation;
  final VoidCallback? onCompleted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accentColor = Theme.of(context).colorScheme.primary;
    final locale = Localizations.localeOf(context).languageCode;

    final dateStr = formatReservationDate(
      reservation.reservationStart,
      l10n,
      locale: locale,
    );
    final timeStr = formatReservationTime(reservation.reservationStart);

    final userName = reservation.user?.fullName;
    final region = (reservation.regionTitle != null &&
            reservation.regionTitle!.trim().isNotEmpty)
        ? reservation.regionTitle!.trim()
        : 'N/A';
    final party = reservation.peopleCount;
    final occasion = reservation.type.trim();
    final note = reservation.additionalInfo?.trim();

    final hasFood = reservation.items.any((i) => i.type == 'food');
    final hasDrinks = reservation.items.any((i) => i.type == 'drink');
    final hasAnyItems = reservation.items.isNotEmpty;

    final foodItems =
        reservation.items.where((i) => i.type == 'food').toList();
    final drinkItems =
        reservation.items.where((i) => i.type == 'drink').toList();

    return Column(
      children: [
        ReservationDateTimeHeader(
          dateStr: dateStr,
          timeStr: timeStr,
          accentColor: accentColor,
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            children: [
              ReservationDetailRow(
                icon: Icons.person,
                label: l10n.confirmedResUser,
                value: (userName != null && userName.isNotEmpty)
                    ? userName
                    : 'N/A',
              ),
              ReservationDetailRow(
                icon: Icons.map,
                label: l10n.reservationLabelRegion,
                value: region,
              ),
              ReservationDetailRow(
                icon: Icons.groups,
                label: l10n.reservationLabelPartySize,
                value: '$party',
              ),
              ReservationDetailRow(
                icon: Icons.restaurant,
                label: l10n.labelFoodDrink,
                value: hasAnyItems
                    ? '${hasFood ? l10n.dialogYes : l10n.dialogNo} / ${hasDrinks ? l10n.dialogYes : l10n.dialogNo}'
                    : 'N/A',
              ),
              ReservationDetailRow(
                icon: Icons.celebration,
                label: l10n.confirmedResOccasion,
                value:
                    occasion.isNotEmpty ? occasion : 'N/A',
              ),
              ReservationDetailRow(
                icon: Icons.note,
                label: l10n.confirmedResNote,
                value: (note != null && note.isNotEmpty) ? note : 'N/A',
              ),
              if (foodItems.isNotEmpty) ...[
                _SectionHeader(title: l10n.readySectionFood),
                ...foodItems.map(
                  (i) => _ItemLine(
                    name: i.name,
                    qty: i.quantity,
                    notes: i.notes,
                  ),
                ),
              ],
              if (drinkItems.isNotEmpty) ...[
                _SectionHeader(title: l10n.readySectionDrinks),
                ...drinkItems.map(
                  (i) => _ItemLine(
                    name: i.name,
                    qty: i.quantity,
                    notes: i.notes,
                  ),
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
                  onPressed: () => _openRejectSheet(context, l10n),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.destructive,
                    foregroundColor: AppColors.onDestructive,
                  ),
                  child: Text(l10n.buttonReject),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _openAcceptSheet(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.success,
                    foregroundColor: AppColors.onSuccess,
                  ),
                  child: Text(l10n.buttonAccept),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onComplete(BuildContext context) {
    if (onCompleted != null) {
      onCompleted!();
    } else {
      Navigator.of(context).pop(true);
    }
  }

  Future<void> _openAcceptSheet(BuildContext context) async {
    final venueId = context.read<AuthProvider>().currentVenueId;
    if (venueId != null) {
      final rp = context.read<RegionsProvider>();
      if (rp.regions.isEmpty && !rp.isLoading) {
        rp.load(venueId);
      }
    }
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => AcceptReservationSheet(
        reservation: reservation,
        onCompleted: () {
          if (context.mounted) _onComplete(context);
        },
      ),
    );
  }

  Future<void> _openRejectSheet(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final controller = TextEditingController();
    bool submitting = false;
    String? fieldError;

    Future<void> submit(StateSetter setSheetState) async {
      final reason = controller.text.trim();
      if (reason.isEmpty) {
        setSheetState(() => fieldError = l10n.rejectReasonHint);
        return;
      }
      setSheetState(() {
        fieldError = null;
        submitting = true;
      });

      final venueId = context.read<AuthProvider>().currentVenueId;
      if (venueId == null) {
        setSheetState(() => submitting = false);
        return;
      }

      final provider = context.read<ReservationsProvider>();
      final ok = await provider.rejectWaiterReservation(
        venueId: venueId,
        reservation: reservation,
        reason: reason,
      );

      if (!context.mounted) return;
      if (ok) {
        Navigator.of(context).pop(); // close sheet
        _onComplete(context);
      } else {
        setSheetState(() {
          submitting = false;
          fieldError = provider.rejectError ?? l10n.rejectErrorFallback;
        });
      }
    }

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setSheetState) {
            final bottomInset = MediaQuery.viewInsetsOf(ctx).bottom;
            return Padding(
              padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottomInset),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          l10n.rejectDialogTitle,
                          style:
                              Theme.of(ctx).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.textPrimary,
                                  ),
                        ),
                      ),
                      IconButton(
                        onPressed:
                            submitting ? null : () => Navigator.of(ctx).pop(),
                        icon: const Icon(Icons.close),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: controller,
                    enabled: !submitting,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: l10n.rejectReasonHint,
                      errorText: fieldError,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed:
                        submitting ? null : () => submit(setSheetState),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.destructive,
                      foregroundColor: AppColors.onDestructive,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: submitting
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.buttonRejectReservation),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
    controller.dispose();
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
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
}

class _ItemLine extends StatelessWidget {
  const _ItemLine({
    required this.name,
    required this.qty,
    this.notes,
  });

  final String name;
  final int qty;
  final String? notes;

  @override
  Widget build(BuildContext context) {
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
                if (notes != null && notes!.trim().isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    notes!,
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
}
