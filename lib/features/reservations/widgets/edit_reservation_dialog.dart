import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/regions/domain/models/region_model.dart';
import 'package:gastrobotmanager/features/regions/providers/regions_provider.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Dialog shown when the waiter taps "IZMENI REZERVACIJU" on a confirmed
/// reservation. Lets the waiter pick a new region + table and enter a note.
///
/// Commit the edit by calling [showEditReservationDialog]:
/// ```dart
/// await showEditReservationDialog(context: context, reservation: reservation);
/// ```
Future<void> showEditReservationDialog({
  required BuildContext context,
  required ConfirmedReservation reservation,
}) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => _EditReservationDialog(reservation: reservation),
  );
}

class _EditReservationDialog extends StatefulWidget {
  const _EditReservationDialog({required this.reservation});

  final ConfirmedReservation reservation;

  @override
  State<_EditReservationDialog> createState() => _EditReservationDialogState();
}

class _EditReservationDialogState extends State<_EditReservationDialog> {
  String? _selectedRegionId;
  String? _selectedTableId;
  bool _tableDropdownOpen = false;
  final _noteController = TextEditingController();
  String? _noteError;
  bool _submitting = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  List<RegionTableModel> _filteredTables(List<RegionModel> regions) {
    if (_selectedRegionId == null) {
      return regions.expand((r) => r.tables).toList();
    }
    return regions
        .where((r) => r.id == _selectedRegionId)
        .expand((r) => r.tables)
        .toList();
  }

  Future<void> _submit(AppLocalizations l10n) async {
    final note = _noteController.text.trim();
    if (note.isEmpty) {
      setState(() => _noteError = l10n.editResNoteHint);
      return;
    }
    setState(() {
      _noteError = null;
      _submitting = true;
    });

    // TODO: call edit reservation API with:
    //   reservationId: widget.reservation.id
    //   tableIds: [_selectedTableId] (if changed)
    //   note: note
    // On success: Navigator.of(context).pop()

    if (mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;
    final regionsProvider = context.watch<RegionsProvider>();
    final regions = regionsProvider.regions;
    final filteredTables = _filteredTables(regions);
    final selectedTable = _selectedTableId != null
        ? filteredTables.where((t) => t.id == _selectedTableId).firstOrNull
        : null;

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Title row
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.editResDialogTitle,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
                IconButton(
                  onPressed:
                      _submitting ? null : () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                  color: AppColors.textSecondary,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Region dropdown
            if (regionsProvider.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(),
              )
            else if (regions.isNotEmpty) ...[
              _StyledDropdown(
                hint: l10n.acceptSheetSelectRegion,
                value: _selectedRegionId,
                items: regions
                    .map(
                      (r) => DropdownMenuItem<String>(
                        value: r.id,
                        child: Text(r.title),
                      ),
                    )
                    .toList(),
                onChanged: _submitting
                    ? null
                    : (id) => setState(() {
                          _selectedRegionId = id;
                          _selectedTableId = null;
                          _tableDropdownOpen = false;
                        }),
              ),
              const SizedBox(height: 12),
            ],

            // Table inline selector
            _InlineTableSelector(
              hint: _selectedTableId != null
                  ? (selectedTable != null
                      ? l10n.tableNumber(selectedTable.name)
                      : l10n.acceptSheetSelectTable)
                  : l10n.acceptSheetSelectTable,
              noTablesLabel: l10n.acceptSheetNoTables,
              tables: filteredTables,
              isLoading: regionsProvider.isLoading,
              isOpen: _tableDropdownOpen,
              selectedTableId: _selectedTableId,
              onToggle: _submitting
                  ? null
                  : () => setState(
                        () => _tableDropdownOpen = !_tableDropdownOpen,
                      ),
              onSelectTable: (id) => setState(() {
                _selectedTableId = id;
                _tableDropdownOpen = false;
              }),
              tableNumberLabel: (name) => l10n.tableNumber(name),
            ),
            const SizedBox(height: 12),

            // Note field (required)
            TextField(
              controller: _noteController,
              enabled: !_submitting,
              maxLines: 5,
              onChanged: (_) {
                if (_noteError != null) setState(() => _noteError = null);
              },
              decoration: InputDecoration(
                hintText: l10n.editResNoteHint,
                errorText: _noteError,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColors.border),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Confirm button
            FilledButton(
              onPressed: _submitting ? null : () => _submit(l10n),
              style: FilledButton.styleFrom(
                backgroundColor: accentColor,
                foregroundColor: AppColors.onPrimary,
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _submitting
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : Text(l10n.editResConfirm),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private sub-widgets (scoped to this file)
// ---------------------------------------------------------------------------

class _StyledDropdown extends StatelessWidget {
  const _StyledDropdown({
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
        hint: Text(hint,
            style: const TextStyle(color: AppColors.textSecondary)),
        value: value,
        items: items,
        onChanged: onChanged,
      ),
    );
  }
}

class _InlineTableSelector extends StatelessWidget {
  const _InlineTableSelector({
    required this.hint,
    required this.noTablesLabel,
    required this.tables,
    required this.isLoading,
    required this.isOpen,
    required this.selectedTableId,
    required this.onToggle,
    required this.onSelectTable,
    required this.tableNumberLabel,
  });

  final String hint;
  final String noTablesLabel;
  final List<RegionTableModel> tables;
  final bool isLoading;
  final bool isOpen;
  final String? selectedTableId;
  final VoidCallback? onToggle;
  final ValueChanged<String> onSelectTable;
  final String Function(String name) tableNumberLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Header row
        GestureDetector(
          onTap: onToggle,
          child: Container(
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
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
                    hint,
                    style: TextStyle(
                      color: selectedTableId != null
                          ? AppColors.textPrimary
                          : AppColors.textSecondary,
                    ),
                  ),
                ),
                Icon(
                  isOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),

        // Expandable list
        if (isOpen)
          Container(
            constraints: const BoxConstraints(maxHeight: 200),
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
                          style: const TextStyle(
                              color: AppColors.textSecondary),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: tables.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, indent: 46),
                        itemBuilder: (_, i) {
                          final table = tables[i];
                          final isSelected = table.id == selectedTableId;
                          return InkWell(
                            onTap: () => onSelectTable(table.id),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 10),
                              child: Row(
                                children: [
                                  const Icon(Icons.table_restaurant,
                                      size: 20,
                                      color: AppColors.textSecondary),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                          '${table.capacity} mesta',
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
                                    onChanged: (_) =>
                                        onSelectTable(table.id),
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
