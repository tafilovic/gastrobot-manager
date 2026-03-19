import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/reservations/widgets/confirmed_reservation_details_content.dart';
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
      body: ConfirmedReservationDetailsContent(reservation: reservation),
    );
  }
}
