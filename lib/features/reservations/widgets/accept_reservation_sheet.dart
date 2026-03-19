import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/regions/providers/regions_provider.dart';
import 'package:gastrobotmanager/features/reservations/providers/reservations_provider.dart';
import 'package:gastrobotmanager/features/reservations/widgets/region_table_picker.dart';
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
      Navigator.of(context).pop();
      Navigator.of(context).pop(true);
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
    final filteredTables = filterTablesByRegion(regions, _selectedRegionId);
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

            Flexible(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (regionsProvider.isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 8),
                        child: LinearProgressIndicator(),
                      )
                    else if (regions.isNotEmpty) ...[
                      StyledDropdown(
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
                                () =>
                                    _tableDropdownOpen = !_tableDropdownOpen,
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
