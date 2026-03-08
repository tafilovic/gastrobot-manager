import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/reservations/providers/reservations_provider.dart';
import 'package:gastrobotmanager/features/reservations/widgets/reservations_content.dart';

/// Reservations screen: requests (and accepted) for current role (kitchen / bar / waiter).
class ReservationsScreen extends StatelessWidget {
  const ReservationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final accentColor = Theme.of(context).colorScheme.primary;

    return ReservationsContent(
      accentColor: accentColor,
      onStartRefresh: () {
        final venueId = auth.currentVenueId;
        if (venueId != null) {
          context.read<ReservationsProvider>().startPeriodicRefresh(venueId);
        }
      },
    );
  }
}
