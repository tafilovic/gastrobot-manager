import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/features/regions/providers/regions_provider.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/pending_reservations_filters.dart';
import 'package:gastrobotmanager/features/reservations/providers/reservations_provider.dart';
import 'package:gastrobotmanager/features/reservations/utils/region_filter_label.dart';
import 'package:gastrobotmanager/features/reservations/widgets/reservation_filter_chip.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Removable chips for active pending-reservation filters (code, region).
class PendingReservationFilterChips extends StatelessWidget {
  const PendingReservationFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filters = context.watch<ReservationsProvider>().pendingFilters;
    if (filters == null || filters.isEmpty) return const SizedBox.shrink();

    final regions = context.watch<RegionsProvider>().regions;
    final chips = <Widget>[];
    final code = filters.trimmedReservationNumber;
    if (code != null) {
      chips.add(
        ReservationFilterChip(
          label: '#$code',
          onRemove: () => _clearFilter(
            context,
            filters.copyWith(clearReservationNumber: true),
          ),
        ),
      );
    }
    if (filters.regionId != null) {
      chips.add(
        ReservationFilterChip(
          label: regionFilterLabel(
            regions,
            filters.regionId,
            fallback: l10n.filterRegionLabel,
          ),
          onRemove: () => _clearFilter(
            context,
            filters.copyWith(clearRegionId: true),
          ),
        ),
      );
    }

    return Wrap(spacing: 8, runSpacing: 8, children: chips);
  }

  Future<void> _clearFilter(
    BuildContext context,
    PendingReservationsFilters next,
  ) async {
    await context.read<ReservationsProvider>().applyPendingFilters(
      next.isEmpty ? null : next,
    );
  }
}
