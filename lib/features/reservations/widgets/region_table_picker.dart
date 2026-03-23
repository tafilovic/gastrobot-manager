import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/regions/domain/models/region_model.dart';

/// Returns the tables for [regionId], or all tables across all regions when
/// [regionId] is null.
List<RegionTableModel> filterTablesByRegion(
  List<RegionModel> regions,
  String? regionId,
) {
  if (regionId == null) return regions.expand((r) => r.tables).toList();
  return regions
      .where((r) => r.id == regionId)
      .expand((r) => r.tables)
      .toList();
}

// ---------------------------------------------------------------------------

/// Styled bordered dropdown for selecting a region (or any string value).
class StyledDropdown extends StatelessWidget {
  const StyledDropdown({
    super.key,
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
  });

  final String hint;
  final String? value;
  final List<DropdownMenuItem<String>> items;
  final ValueChanged<String?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
        color: AppColors.surface,
      ),
      child: DropdownButton<String>(
        isExpanded: true,
        underline: const SizedBox.shrink(),
        hint: Text(
          hint,
          style: const TextStyle(color: AppColors.textSecondary),
        ),
        value: value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}

// ---------------------------------------------------------------------------

/// Expandable inline table selector with single-select checkbox rows.
///
/// Each row shows the table name (via [tableNumberLabel]) and seat capacity.
/// Selecting a row calls [onSelectTable] with the table's id.
class InlineTableSelector extends StatelessWidget {
  const InlineTableSelector({
    super.key,
    required this.hint,
    required this.noTablesLabel,
    required this.tables,
    required this.isLoading,
    required this.isOpen,
    required this.selectedTableId,
    required this.onToggle,
    required this.onSelectTable,
    required this.tableNumberLabel,
    required this.seatCountLabel,
  });

  final String hint;
  final String noTablesLabel;
  final List<RegionTableModel> tables;
  final bool isLoading;
  final bool isOpen;

  /// Currently selected table id, or null if nothing is selected.
  final String? selectedTableId;

  final VoidCallback? onToggle;
  final ValueChanged<String> onSelectTable;

  /// Returns a display label for [name], e.g. `l10n.tableNumber(name)`.
  final String Function(String name) tableNumberLabel;

  /// Returns the seat count label for [count], e.g. `l10n.tableSeatCount(count)`.
  final String Function(int count) seatCountLabel;

  @override
  Widget build(BuildContext context) {
    final selectedTable = selectedTableId != null && tables.isNotEmpty
        ? tables.where((t) => t.id == selectedTableId).firstOrNull
        : null;

    final headerLabel = selectedTable != null
        ? tableNumberLabel(selectedTable.name)
        : hint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header / trigger row
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.border),
              borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(12),
                topRight: const Radius.circular(12),
                bottomLeft: Radius.circular(isOpen ? 0 : 12),
                bottomRight: Radius.circular(isOpen ? 0 : 12),
              ),
              color: AppColors.surface,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    headerLabel,
                    style: TextStyle(
                      color: selectedTable != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                Icon(
                  isOpen ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),

        // Expandable list
        if (isOpen)
          Container(
            constraints: const BoxConstraints(maxHeight: 240),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: AppColors.border),
                right: BorderSide(color: AppColors.border),
                bottom: BorderSide(color: AppColors.border),
              ),
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(12),
                bottomRight: Radius.circular(12),
              ),
              color: AppColors.surface,
            ),
            child: isLoading
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  )
                : tables.isEmpty
                ? Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(
                      noTablesLabel,
                      style: const TextStyle(color: AppColors.textSecondary),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true,
                    itemCount: tables.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, indent: 46),
                    itemBuilder: (_, i) {
                      final table = tables[i];
                      final isSelected = table.id == selectedTableId;
                      return InkWell(
                        onTap: () => onSelectTable(table.id),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 10,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.table_restaurant,
                                size: 20,
                                color: AppColors.textSecondary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      tableNumberLabel(table.name),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      seatCountLabel(table.capacity),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Checkbox(
                                value: isSelected,
                                onChanged: (_) => onSelectTable(table.id),
                                activeColor: AppColors.accent,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
          ),
      ],
    );
  }
}
