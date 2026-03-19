import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order_item.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/reservations/utils/format_reservation_date.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Detail view for a confirmed reservation.
///
/// Shows: date/time header, guest info rows, optional food & drink sections,
/// and action buttons (Edit / Cancel).
class ConfirmedReservationDetailsScreen extends StatelessWidget {
  const ConfirmedReservationDetailsScreen({
    super.key,
    required this.reservation,
  });

  final ConfirmedReservation reservation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
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
                  reservation.reservationNumber,
                  style: theme.textTheme.titleSmall?.copyWith(
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
          // Date / time header
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
            child: Row(
              children: [
                Icon(Icons.calendar_today, size: 20, color: accentColor),
                const SizedBox(width: 8),
                Text(
                  dateStr,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  timeStr,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 6),
                Icon(Icons.access_time, size: 20, color: accentColor),
              ],
            ),
          ),

          // Scrollable details
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              children: [
                _detailRow(
                  context,
                  Icons.person,
                  l10n.confirmedResUser,
                  reservation.user?.fullName.isNotEmpty == true
                      ? reservation.user!.fullName
                      : '—',
                ),
                _detailRow(
                  context,
                  Icons.table_restaurant,
                  l10n.confirmedResTableNumber,
                  reservation.tableNamesLabel,
                ),
                if (reservation.regionTitle != null &&
                    reservation.regionTitle!.isNotEmpty)
                  _detailRow(
                    context,
                    Icons.map,
                    l10n.reservationLabelRegion,
                    reservation.regionTitle!,
                  ),
                _detailRow(
                  context,
                  Icons.groups,
                  l10n.reservationLabelPartySize,
                  '${reservation.peopleCount}',
                ),
                _detailRow(
                  context,
                  Icons.celebration,
                  l10n.confirmedResOccasion,
                  occasionLabel,
                ),
                if (reservation.additionalInfo != null &&
                    reservation.additionalInfo!.isNotEmpty)
                  _detailRow(
                    context,
                    Icons.note,
                    l10n.confirmedResNote,
                    reservation.additionalInfo!,
                  ),

                // Food section
                if (food.isNotEmpty) ...[
                  _sectionHeader(context, l10n.readySectionFood),
                  ...food.map((i) => _itemLine(context, i)),
                ],

                // Drink section
                if (drinks.isNotEmpty) ...[
                  _sectionHeader(context, l10n.readySectionDrinks),
                  ...drinks.map((i) => _itemLine(context, i)),
                ],
              ],
            ),
          ),

          // Action buttons
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
                      // TODO: implement edit reservation
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
                    onPressed: () {
                      // TODO: implement cancel reservation
                    },
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
      ),
    );
  }

  static Widget _detailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
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

  static Widget _sectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 12, bottom: 8),
      child: Row(
        children: [
          Icon(
            title.contains('rana') || title.contains('ood')
                ? Icons.restaurant
                : Icons.local_bar,
            size: 18,
            color: AppColors.textMuted,
          ),
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

  static Widget _itemLine(BuildContext context, PendingOrderItem item) {
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
