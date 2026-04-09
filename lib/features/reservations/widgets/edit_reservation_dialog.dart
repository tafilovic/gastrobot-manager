import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/regions/domain/models/region_model.dart';
import 'package:gastrobotmanager/features/regions/providers/regions_provider.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/reservations/widgets/region_table_picker.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Dialog shown when the waiter taps "IZMENI REZERVACIJU" on a confirmed
/// reservation. Lets the waiter pick a table in the guest's region and enter a note.
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
  String? _selectedTableId;
  bool _tableDropdownOpen = false;
  final _noteController = TextEditingController();
  String? _noteError;
  bool _submitting = false;

  @override
  void initState() {
    super.initState();
    final assigned = widget.reservation.tables;
    if (assigned.length == 1) {
      _selectedTableId = assigned.first.id;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
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
    final regionIdRaw = widget.reservation.regionId?.trim();
    final regionId = (regionIdRaw != null && regionIdRaw.isNotEmpty)
        ? regionIdRaw
        : null;
    final filteredTables = regionId != null
        ? filterTablesByRegion(regions, regionId)
        : const <RegionTableModel>[];

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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

            if (regionsProvider.isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: LinearProgressIndicator(),
              )
            else if (regions.isNotEmpty) ...[
              if (widget.reservation.regionTitle != null &&
                  widget.reservation.regionTitle!.isNotEmpty) ...[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.map_outlined,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        '${l10n.reservationLabelRegion} ${widget.reservation.regionTitle}',
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
              ],
            ],

            InlineTableSelector(
              hint: l10n.acceptSheetSelectTable,
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
              seatCountLabel: (count) => l10n.tableSeatCount(count),
            ),
            const SizedBox(height: 12),

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
