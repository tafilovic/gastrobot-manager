import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/reservations/utils/format_reservation_date.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Reservation row for table overview: date, time, guest, party size; tap opens details.
class TableOverviewReservationCard extends StatelessWidget {
  const TableOverviewReservationCard({
    super.key,
    required this.reservation,
    required this.l10n,
    required this.accentColor,
    required this.onTap,
    this.isSelected = false,
  });

  final ConfirmedReservation reservation;
  final AppLocalizations l10n;
  final Color accentColor;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final iso = reservation.reservationStart.toIso8601String();
    final dateStr = formatReservationDate(iso, l10n, locale: locale);
    final timeStr = formatReservationTime(iso);
    final guest = reservation.user?.fullName.isNotEmpty == true
        ? reservation.user!.fullName
        : '—';

    final decoration = BoxDecoration(
      color: isSelected
          ? Color.alphaBlend(
              accentColor.withValues(alpha: 0.12),
              AppColors.surface,
            )
          : AppColors.surface,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: isSelected ? accentColor : AppColors.border,
        width: isSelected ? 2 : 1,
      ),
      boxShadow: [
        BoxShadow(
          color: isSelected
              ? accentColor.withValues(alpha: 0.28)
              : AppColors.shadow,
          blurRadius: isSelected ? 16 : 4,
          offset: Offset(0, isSelected ? 8 : 2),
        ),
        if (isSelected)
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
      ],
    );

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          decoration: decoration,
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
                        reservation.reservationNumber,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
                const Divider(height: 24),
                _detailRow(theme, l10n.reservationLabelTime, timeStr),
                _detailRow(theme, l10n.confirmedResUser, guest),
                _detailRow(
                  theme,
                  l10n.reservationLabelPartySize,
                  '${reservation.peopleCount}',
                ),
              ],
            ),
          ),
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
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              ],
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
