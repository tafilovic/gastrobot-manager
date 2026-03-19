import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/regions/domain/models/region_model.dart';
import 'package:gastrobotmanager/features/regions/providers/regions_provider.dart';
import 'package:gastrobotmanager/features/reservations/providers/reservations_provider.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Bottom sheet shown when the waiter taps PRIHVATI on a pending reservation.
///
/// Loads venue regions (with their tables) via [RegionsProvider].
/// The waiter selects a region to filter tables, then picks a specific table.
/// Selecting a table enables the POTVRDI REZERVACIJU button.
class AcceptReservationSheet extends StatefulWidget {
  const AcceptReservationSheet({super.key, required this.order});

  final PendingOrder order;

  @override
  State<AcceptReservationSheet> createState() => _AcceptReservationSheetState();
}

class _AcceptReservationSheetState extends State<AcceptReservationSheet> {
  /// null = show all tables across all regions
  String? _selectedRegionId;
  String? _selectedTableId;
  bool _tableDropdownOpen = false;
  final _noteController = TextEditingController();
  bool _submitting = false;
  String? _error;

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
    final tableId = _selectedTableId;
    if (tableId == null) return;

    setState(() {
      _submitting = true;
      _error = null;
    });

    final venueId = context.read<AuthProvider>().currentVenueId;
    if (venueId == null) {
      setState(() => _submitting = false);
      return;
    }

    final note = _noteController.text.trim();
    final provider = context.read<ReservationsProvider>();
    final ok = await provider.acceptWaiterReservation(
      venueId: venueId,
      reservation: widget.order,
      tableIds: [tableId],
      note: note.isNotEmpty ? note : null,
    );

    if (!mounted) return;
    if (ok) {
      Navigator.of(context).pop(); // close sheet
      Navigator.of(context).pop(true); // close details screen
    } else {
      setState(() {
        _submitting = false;
        _error = provider.acceptError ?? l10n.acceptSheetErrorGeneric;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final regionsProvider = context.watch<RegionsProvider>();
    final regions = regionsProvider.regions;
    final filteredTables = _filteredTables(regions);
    final selectedTable = _selectedTableId != null
        ? filteredTables.where((t) => t.id == _selectedTableId).firstOrNull
        : null;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    final canConfirm = _selectedTableId != null && !_submitting;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.85,
      ),
      child: Padding(
        padding: EdgeInsets.fromLTRB(16, 12, 16, 16 + bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.acceptSheetTitle,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                  ),
                ),
                IconButton(
                  onPressed:
                      _submitting ? null : () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Scrollable body
            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Region dropdown
                    if (regionsProvider.isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: LinearProgressIndicator(),
                      )
                    else if (regions.isNotEmpty) ...[
                      _RegionDropdown(
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

                    // Inline expandable table selector
                    _TableSelector(
                      hint: l10n.acceptSheetSelectTable,
                      noTablesLabel: l10n.acceptSheetNoTables,
                      tables: filteredTables,
                      isLoading: regionsProvider.isLoading,
                      isOpen: _tableDropdownOpen,
                      selectedTable: selectedTable,
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

                    // Optional note
                    TextField(
                      controller: _noteController,
                      enabled: !_submitting,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: l10n.acceptSheetNoteHint,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                    if (_error != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _error!,
                        style: const TextStyle(
                          color: AppColors.error,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Confirm button — disabled until a table is selected
            FilledButton(
              onPressed: canConfirm ? () => _submit(l10n) : null,
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.success,
                foregroundColor: AppColors.onSuccess,
                disabledBackgroundColor:
                    AppColors.success.withValues(alpha: 0.4),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _submitting
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.onSuccess,
                      ),
                    )
                  : Text(l10n.acceptSheetConfirm),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private sub-widgets
// ---------------------------------------------------------------------------

/// Styled dropdown for selecting a region.
class _RegionDropdown extends StatelessWidget {
  const _RegionDropdown({
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

/// Inline expandable selector that lists tables with single-select checkboxes.
///
/// Each row shows the table name and its seating capacity.
class _TableSelector extends StatelessWidget {
  const _TableSelector({
    required this.hint,
    required this.noTablesLabel,
    required this.tables,
    required this.isLoading,
    required this.isOpen,
    required this.selectedTable,
    required this.onToggle,
    required this.onSelectTable,
    required this.tableNumberLabel,
  });

  final String hint;
  final String noTablesLabel;
  final List<RegionTableModel> tables;
  final bool isLoading;
  final bool isOpen;
  final RegionTableModel? selectedTable;
  final VoidCallback? onToggle;
  final ValueChanged<String> onSelectTable;
  final String Function(String name) tableNumberLabel;

  @override
  Widget build(BuildContext context) {
    final headerLabel =
        selectedTable != null ? tableNumberLabel(selectedTable!.name) : hint;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Dropdown header
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
                  isOpen
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  color: AppColors.textSecondary,
                ),
              ],
            ),
          ),
        ),

        // Expandable table list
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
                          style: const TextStyle(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : ListView.separated(
                        shrinkWrap: true,
                        itemCount: tables.length,
                        separatorBuilder: (_, __) =>
                            const Divider(height: 1, indent: 46),
                        itemBuilder: (_, i) {
                          final table = tables[i];
                          final isSelected = table.id == selectedTable?.id;
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
