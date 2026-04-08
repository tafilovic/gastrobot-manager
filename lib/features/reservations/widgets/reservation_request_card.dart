import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/core/widgets/selectable_ink_card.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/pending_reservation.dart';
import 'package:gastrobotmanager/features/reservations/utils/format_reservation_date.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Reservation request card. Waiter pending: datum + šifra, Vreme, Region ([region.title]), Broj ljudi.
/// Kitchen/bar: stariji prikaz sa brojem stavki.
class ReservationRequestCard extends StatelessWidget {
  const ReservationRequestCard({
    super.key,
    this.order,
    this.waiterReservation,
    required this.l10n,
    required this.accentColor,
    required this.itemCountLabel,
    required this.onSeeDetails,
    this.showWaiterPendingLayout = false,
    this.isSelected = false,
  }) : assert(
          (order != null) != (waiterReservation != null),
          'Exactly one of order or waiterReservation must be provided',
        );

  final PendingOrder? order;
  final PendingReservation? waiterReservation;
  final AppLocalizations l10n;
  final Color accentColor;
  final String itemCountLabel;
  final VoidCallback onSeeDetails;
  final bool showWaiterPendingLayout;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;

    if (showWaiterPendingLayout) {
      final r = waiterReservation!;
      final dateStr = formatReservationDate(
        r.reservationStart,
        l10n,
        locale: locale,
      );
      final timeStr = formatReservationTime(r.reservationStart);
      final ref = r.displayReference;
      final regionLabel = (r.regionTitle != null && r.regionTitle!.trim().isNotEmpty)
          ? r.regionTitle!.trim()
          : 'N/A';

      return SelectableInkCard(
        accentColor: accentColor,
        isSelected: isSelected,
        onTap: onSeeDetails,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.calendar_today, size: 22, color: accentColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      dateStr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundMuted,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      ref,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _waiterDetailRow(
                theme,
                l10n.reservationLabelTime,
                timeStr.isNotEmpty ? timeStr : 'N/A',
              ),
              _waiterDetailRow(
                theme,
                l10n.reservationLabelRegion,
                regionLabel,
              ),
              _waiterDetailRow(
                theme,
                l10n.reservationLabelPartySize,
                '${r.peopleCount}',
              ),
            ],
          ),
        ),
      );
    }

    final o = order!;
    final dateStr = formatReservationDate(
      o.targetTime,
      l10n,
      locale: locale,
    );
    final timeStr = formatReservationTime(o.targetTime);

    return SelectableInkCard(
      accentColor: accentColor,
      isSelected: isSelected,
      onTap: onSeeDetails,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateStr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        itemCountLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '#${o.orderNumber}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      timeStr,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static Widget _waiterDetailRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 108,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
