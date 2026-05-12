import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/zones/domain/models/zone_model.dart';
import 'package:gastrobotmanager/features/zones/providers/zones_provider.dart';
import 'package:gastrobotmanager/features/zones/utils/group_zones_by_display_category.dart';
import 'package:gastrobotmanager/features/zones/utils/zone_type_display.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Zone filter chips grouped by venue category (room / sunbed / table).
class ZonesFilterZoneChipsGrouped extends StatelessWidget {
  const ZonesFilterZoneChipsGrouped({
    super.key,
    required this.selectedZoneIds,
    required this.onToggleZoneId,
  });

  final Set<String> selectedZoneIds;
  final ValueChanged<String> onToggleZoneId;

  static String _categoryLabel(
    AppLocalizations l10n,
    ZoneDisplayCategory category,
  ) {
    return switch (category) {
      ZoneDisplayCategory.room => l10n.tableTypeRoom,
      ZoneDisplayCategory.sunbed => l10n.tableTypeSunbed,
      ZoneDisplayCategory.table => l10n.tableTypeTable,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<ZonesProvider>();

    if (provider.isLoading && provider.zones.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.error != null && provider.zones.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          provider.error!,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      );
    }

    final grouped = groupZonesByDisplayCategory(provider.zones);

    if (grouped.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          l10n.acceptSheetNoTables,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (var i = 0; i < grouped.length; i++) ...[
          if (i > 0) const SizedBox(height: 18),
          Row(
            children: [
              Icon(
                zoneDisplayCategoryIcon(grouped[i].category),
                size: 20,
                color: AppColors.textSecondary,
              ),
              const SizedBox(width: 8),
              Text(
                _categoryLabel(l10n, grouped[i].category),
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: grouped[i].zones.map((ZoneModel zone) {
              final selected = selectedZoneIds.contains(zone.id);
              return _FilterZoneChip(
                label: zone.name,
                selected: selected,
                onTap: () => onToggleZoneId(zone.id),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class _FilterZoneChip extends StatelessWidget {
  const _FilterZoneChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
            width: 1,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: selected ? AppColors.onPrimary : AppColors.textPrimary,
          ),
        ),
      ),
    );
  }
}
