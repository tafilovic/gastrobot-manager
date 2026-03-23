import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';
import 'package:gastrobotmanager/features/tables/providers/tables_provider.dart';
import 'package:gastrobotmanager/features/tables/utils/group_tables_by_display_category.dart';
import 'package:gastrobotmanager/features/tables/utils/table_type_display.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Table filter chips grouped by venue category (room / sunbed / table), like the tables list.
class TablesFilterTableChipsGrouped extends StatelessWidget {
  const TablesFilterTableChipsGrouped({
    super.key,
    required this.selectedTableIds,
    required this.onToggleTableId,
  });

  final Set<String> selectedTableIds;
  final ValueChanged<String> onToggleTableId;

  static String _categoryLabel(
    AppLocalizations l10n,
    TableDisplayCategory category,
  ) {
    return switch (category) {
      TableDisplayCategory.room => l10n.tableTypeRoom,
      TableDisplayCategory.sunbed => l10n.tableTypeSunbed,
      TableDisplayCategory.table => l10n.tableTypeTable,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final provider = context.watch<TablesProvider>();

    if (provider.isLoading && provider.tables.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 24),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (provider.error != null && provider.tables.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Text(
          provider.error!,
          style: const TextStyle(fontSize: 14, color: AppColors.textSecondary),
        ),
      );
    }

    final grouped = groupTablesByDisplayCategory(provider.tables);

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
                tableDisplayCategoryIcon(grouped[i].category),
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
            children: grouped[i].tables.map((TableModel t) {
              final selected = selectedTableIds.contains(t.id);
              return _FilterTableChip(
                label: t.name,
                selected: selected,
                onTap: () => onToggleTableId(t.id),
              );
            }).toList(),
          ),
        ],
      ],
    );
  }
}

class _FilterTableChip extends StatelessWidget {
  const _FilterTableChip({
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
