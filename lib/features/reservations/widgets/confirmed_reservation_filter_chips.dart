import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/regions/providers/regions_provider.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservations_filters.dart';
import 'package:gastrobotmanager/features/reservations/providers/confirmed_reservations_provider.dart';
import 'package:gastrobotmanager/features/reservations/utils/format_filter_date.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Removable chips for active confirmed-reservation filters (code, region, dates).
class ConfirmedReservationFilterChips extends StatelessWidget {
  const ConfirmedReservationFilterChips({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final filters = context.watch<ConfirmedReservationsProvider>().filters;
    if (filters == null || filters.isEmpty) return const SizedBox.shrink();

    final regions = context.watch<RegionsProvider>().regions;
    final chips = <Widget>[];
    final code = filters.trimmedReservationNumber;
    if (code != null) {
      chips.add(
        _FilterChip(
          label: '#$code',
          onRemove: () => _clearFilter(
            context,
            filters.copyWith(clearReservationNumber: true),
          ),
        ),
      );
    }
    if (filters.regionId != null) {
      String? regionTitle;
      for (final region in regions) {
        if (region.id == filters.regionId) {
          regionTitle = region.title;
          break;
        }
      }
      chips.add(
        _FilterChip(
          label: regionTitle ?? l10n.filterRegionLabel,
          onRemove: () => _clearFilter(
            context,
            filters.copyWith(clearRegionId: true),
          ),
        ),
      );
    }
    if (filters.hasCustomDateRange) {
      chips.add(
        _FilterChip(
          label: formatFilterDateRangeLabel(filters),
          onRemove: () => _clearFilter(
            context,
            filters.copyWith(clearDateRange: true),
          ),
        ),
      );
    }

    return Wrap(spacing: 8, runSpacing: 8, children: chips);
  }

  Future<void> _clearFilter(
    BuildContext context,
    ConfirmedReservationsFilters next,
  ) async {
    await context.read<ConfirmedReservationsProvider>().applyFilters(
      next.isEmpty ? null : next,
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({required this.label, required this.onRemove});

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.filterChipBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.filterChipForeground,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(12),
            child: const Icon(
              Icons.close,
              size: 16,
              color: AppColors.filterChipForeground,
            ),
          ),
        ],
      ),
    );
  }
}
