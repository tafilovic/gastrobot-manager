import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/pending_reservation.dart';
import 'package:gastrobotmanager/features/reservations/widgets/waiter_reservation_request_details_content.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Full-screen detail view for a *pending* waiter reservation.
///
/// Displays reservation info, optional food/drink items, and ODBIJ / PRIHVATI
/// action buttons.
class WaiterReservationDetailsScreen extends StatelessWidget {
  const WaiterReservationDetailsScreen({super.key, required this.reservation});

  final PendingReservation reservation;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
                  reservation.displayReference,
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
      body: WaiterReservationRequestDetailsContent(reservation: reservation),
    );
  }
}
