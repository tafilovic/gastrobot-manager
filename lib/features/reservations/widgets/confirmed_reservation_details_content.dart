import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order_item.dart';
import 'package:gastrobotmanager/features/regions/providers/regions_provider.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/reservations/utils/format_reservation_date.dart';
import 'package:gastrobotmanager/features/reservations/widgets/edit_reservation_dialog.dart';
import 'package:gastrobotmanager/features/reservations/widgets/reservation_date_time_header.dart';
import 'package:gastrobotmanager/features/reservations/widgets/reservation_detail_row.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Reusable confirmed reservation details body.
/// Used in [ConfirmedReservationDetailsScreen] and in master-detail detail pane.
class ConfirmedReservationDetailsContent extends StatelessWidget {
  const ConfirmedReservationDetailsContent({
    super.key,
    required this.reservation,
    this.onCompleted,
  });

  final ConfirmedReservation reservation;
  final VoidCallback? onCompleted;

  Future<void> _showCancelDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    bool submitting = false;
    String? fieldError;

    await showDialog<void>(
      context: context,
      barrierDismissible: !submitting,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            return Dialog(
              backgroundColor: AppColors.surface,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            l10n.cancelDialogTitle,
                            style:
                                Theme.of(ctx).textTheme.titleMedium?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.textPrimary,
                                    ),
                          ),
                        ),
                        IconButton(
                          onPressed: submitting
                              ? null
                              : () => Navigator.of(ctx).pop(),
                          icon: const Icon(Icons.close),
                          color: AppColors.textSecondary,
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: controller,
                      enabled: !submitting,
                      maxLines: 5,
                      decoration: InputDecoration(
                        hintText: l10n.cancelReasonHint,
                        errorText: fieldError,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: AppColors.border),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: submitting
                          ? null
                          : () async {
                              final reason = controller.text.trim();
                              if (reason.isEmpty) {
                                setDialogState(
                                  () => fieldError = l10n.cancelReasonHint,
                                );
                                return;
                              }
                              setDialogState(() {
                                fieldError = null;
                                submitting = true;
                              });

                              // TODO: call cancel reservation API
                              if (ctx.mounted) Navigator.of(ctx).pop();
                              if (context.mounted) {
                                if (onCompleted != null) {
                                  onCompleted!();
                                } else {
                                  Navigator.of(context).pop();
                                }
                              }
                            },
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.destructive,
                        foregroundColor: AppColors.onDestructive,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: submitting
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : Text(l10n.confirmedResCancelButton),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
    controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accentColor = Theme.of(context).colorScheme.primary;
    final locale = Localizations.localeOf(context).languageCode;

    final dateStr = formatReservationDate(
      reservation.reservationStart.toIso8601String(),
      l10n,
      locale: locale,
    );
    final timeStr =
        formatReservationTime(reservation.reservationStart.toIso8601String());

    final occasionLabel = reservation.type == 'birthday'
        ? l10n.confirmedResOccasionBirthday
        : l10n.confirmedResOccasionClassic;

    final food = reservation.foodItems;
    final drinks = reservation.drinkItems;
    final info = reservation.additionalInfo?.trim() ?? '';
    final confirmationMessage =
        reservation.confirmedMessage == 'reservation.confirmed_with_note' &&
            info.isNotEmpty
        ? l10n.confirmedResMessageConfirmedWithNote(info)
        : l10n.confirmedResMessageConfirmed;

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
                value: reservation.user?.fullName.isNotEmpty == true
                    ? reservation.user!.fullName
                    : '—',
              ),
              ReservationDetailRow(
                icon: Icons.table_restaurant,
                label: l10n.confirmedResTableNumber,
                value: reservation.tableNamesLabel,
              ),
              if (reservation.regionTitle != null &&
                  reservation.regionTitle!.isNotEmpty)
                ReservationDetailRow(
                  icon: Icons.map,
                  label: l10n.reservationLabelRegion,
                  value: reservation.regionTitle!,
                ),
              ReservationDetailRow(
                icon: Icons.groups,
                label: l10n.reservationLabelPartySize,
                value: '${reservation.peopleCount}',
              ),
              ReservationDetailRow(
                icon: Icons.celebration,
                label: l10n.confirmedResOccasion,
                value: occasionLabel,
              ),
              ReservationDetailRow(
                icon: Icons.message_outlined,
                label: l10n.confirmedResMessageLabel,
                value: confirmationMessage,
              ),
              if (food.isNotEmpty) ...[
                _SectionHeader(title: l10n.readySectionFood, icon: Icons.restaurant),
                ...food.map((i) => _ItemLine(item: i)),
              ],
              if (drinks.isNotEmpty) ...[
                _SectionHeader(title: l10n.readySectionDrinks, icon: Icons.local_bar),
                ...drinks.map((i) => _ItemLine(item: i)),
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
                child: OutlinedButton(
                  onPressed: () {
                    final venueId =
                        context.read<AuthProvider>().currentVenueId;
                    if (venueId != null) {
                      final rp = context.read<RegionsProvider>();
                      if (rp.regions.isEmpty && !rp.isLoading) {
                        rp.load(venueId);
                      }
                    }
                    showEditReservationDialog(
                      context: context,
                      reservation: reservation,
                    );
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: accentColor,
                    side: BorderSide(color: accentColor),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(l10n.confirmedResEditButton),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => _showCancelDialog(context),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.destructive,
                    foregroundColor: AppColors.onDestructive,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: Text(l10n.confirmedResCancelButton),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title, required this.icon});

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ],
      ),
    );
  }
}

class _ItemLine extends StatelessWidget {
  const _ItemLine({required this.item});

  final PendingOrderItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10, left: 26),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                ),
                if (item.notes.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    item.notes,
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
            'x${item.quantity}',
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
