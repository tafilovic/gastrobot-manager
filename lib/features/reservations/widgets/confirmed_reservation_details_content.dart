import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order_item.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/reservations/utils/format_reservation_date.dart';
import 'package:gastrobotmanager/features/reservations/widgets/reservation_date_time_header.dart';
import 'package:gastrobotmanager/features/reservations/widgets/reservation_detail_row.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Read-only confirmed reservation details (waiter view).
/// Used in [ConfirmedReservationDetailsScreen] and master-detail pane.
class ConfirmedReservationDetailsContent extends StatelessWidget {
  const ConfirmedReservationDetailsContent({
    super.key,
    required this.reservation,
  });

  final ConfirmedReservation reservation;

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
