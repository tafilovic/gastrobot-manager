import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/reservations/utils/format_reservation_date.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Card showing a single confirmed reservation in the waiter "Prihvaćeno" tab.
///
/// Layout (matches pending reservation card):
///   [calendar icon]  date label          [reservation number chip]
///   Vreme:           HH:mm
///   Korisnik:        Firstname Lastname
///   Sto broj:        1, 2
///   [VIDI DETALJE button]
class ConfirmedReservationCard extends StatelessWidget {
  const ConfirmedReservationCard({
    super.key,
    required this.reservation,
    required this.l10n,
    required this.accentColor,
    required this.onSeeDetails,
  });

  final ConfirmedReservation reservation;
  final AppLocalizations l10n;
  final Color accentColor;
  final VoidCallback onSeeDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = formatReservationDate(
      reservation.reservationStart.toIso8601String(),
      l10n,
      locale: locale,
    );
    final timeStr = formatReservationTime(
      reservation.reservationStart.toIso8601String(),
    );

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Date row + reservation number chip
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
                    reservation.reservationNumber,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Detail rows
            _detailRow(theme, l10n.reservationLabelTime, timeStr),
            _detailRow(
              theme,
              l10n.confirmedResUser,
              reservation.user?.fullName.isNotEmpty == true
                  ? reservation.user!.fullName
                  : '—',
            ),
            _detailRow(
              theme,
              l10n.confirmedResTableNumber,
              reservation.tableNamesLabel,
            ),
            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onSeeDetails,
                style: FilledButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(l10n.orderSeeDetails),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _detailRow(ThemeData theme, String label, String value) {
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
