import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/screens/waiter_reservation_details_screen.dart';
import 'package:gastrobotmanager/features/reservations/widgets/kitchen_bar_reservation_request_details_content.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Reservation details: "Rezervacije" + # in app bar, date/time row, items with checkboxes, ODBIJ SVE / PRIHVATI.
/// Bar/waiter = direct accept; kitchen = time estimation screen.
class ReservationDetailsScreen extends StatelessWidget {
  const ReservationDetailsScreen({
    super.key,
    required this.order,
  });

  final PendingOrder order;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profileType = context.watch<AuthProvider>().profileType;

    if (profileType == ProfileType.waiter) {
      return WaiterReservationDetailsScreen(order: order);
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
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.backgroundMuted,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '#${order.orderNumber}',
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
      body: KitchenBarReservationRequestDetailsContent(order: order),
    );
  }
}
