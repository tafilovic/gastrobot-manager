import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/regions/providers/regions_provider.dart';
import 'package:gastrobotmanager/features/reservations/widgets/region_table_picker.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Dialog for creating a new table reservation from the Tables screen.
///
/// Displays form fields: name, party size, date, time, region, table, internal note.
Future<void> showTableReservationsDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    barrierDismissible: true,
    builder: (_) => const _TableReservationsDialog(),
  );
}

class _TableReservationsDialog extends StatefulWidget {
  const _TableReservationsDialog();

  @override
  State<_TableReservationsDialog> createState() =>
      _TableReservationsDialogState();
}

class _TableReservationsDialogState extends State<_TableReservationsDialog> {
  final _nameController = TextEditingController();
  int? _selectedPartySize;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String? _selectedRegionId;
  String? _selectedTableId;
  bool _tableDropdownOpen = false;
  final _internalNoteController = TextEditingController();
  bool _submitting = false;
  String? _error;

  static const List<int> _partySizeOptions = [
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20,
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _ensureRegionsLoaded());
  }

  void _ensureRegionsLoaded() {
    final venueId = context.read<AuthProvider>().currentVenueId;
    if (venueId != null) {
      final rp = context.read<RegionsProvider>();
      if (rp.regions.isEmpty && !rp.isLoading) {
        rp.load(venueId);
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _internalNoteController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null && mounted) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final now = DateTime.now();
    final initial = _selectedTime ??
        TimeOfDay(hour: now.hour, minute: (now.minute ~/ 15) * 15);
    final picked = await showTimePicker(
      context: context,
      initialTime: initial,
    );
    if (picked != null && mounted) {
      setState(() => _selectedTime = picked);
    }
  }

  Future<void> _submit(AppLocalizations l10n) async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      setState(() => _error = l10n.tableReservationNameRequired);
      return;
    }
    if (_selectedPartySize == null) {
      setState(() => _error = l10n.tableReservationPartySizeRequired);
      return;
    }
    if (_selectedDate == null) {
      setState(() => _error = l10n.tableReservationDateRequired);
      return;
    }
    if (_selectedTime == null) {
      setState(() => _error = l10n.tableReservationTimeRequired);
      return;
    }
    if (_selectedTableId == null) {
      setState(() => _error = l10n.tableReservationTableRequired);
      return;
    }

    setState(() {
      _error = null;
      _submitting = true;
    });

    // TODO: call create reservation API with:
    //   venueId, name, partySize: _selectedPartySize!, date: _selectedDate!,
    //   time: _selectedTime!, tableIds: [_selectedTableId!],
    //   internalNote: _internalNoteController.text.trim()
    // On success: Navigator.of(context).pop()

    if (mounted) {
      Navigator.of(context).pop();
    }
  }

  String _formatDate(DateTime? d, AppLocalizations l10n) {
    if (d == null) return l10n.tableReservationDateHint;
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMd(locale).format(d);
  }

  String _formatTime(TimeOfDay? t, AppLocalizations l10n) {
    if (t == null) return l10n.tableReservationTimeHint;
    final h = t.hour.toString().padLeft(2, '0');
    final m = t.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;
    final regionsProvider = context.watch<RegionsProvider>();
    final regions = regionsProvider.regions;
    final filteredTables = filterTablesByRegion(regions, _selectedRegionId);

    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 400,
          maxHeight: MediaQuery.of(context).size.height * 0.85,
        ),
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
                      l10n.tableReservationDialogTitle,
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
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
              const SizedBox(height: 20),

              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextField(
                        controller: _nameController,
                        enabled: !_submitting,
                        onChanged: (_) {
                          if (_error != null) setState(() => _error = null);
                        },
                        decoration: InputDecoration(
                          hintText: l10n.tableReservationNameHint,
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
                      const SizedBox(height: 12),

                      _StyledDropdownField<int>(
                        hint: l10n.tableReservationPartySizeHint,
                        value: _selectedPartySize,
                        items: _partySizeOptions
                            .map(
                              (n) => DropdownMenuItem<int>(
                                value: n,
                                child: Text(n.toString()),
                              ),
                            )
                            .toList(),
                        onChanged: _submitting
                            ? null
                            : (v) => setState(() {
                                  _selectedPartySize = v;
                                  _error = null;
                                }),
                      ),
                      const SizedBox(height: 12),

                      _TapField(
                        hint: l10n.tableReservationDateHint,
                        value: _formatDate(_selectedDate, l10n),
                        icon: Icons.calendar_today,
                        onTap: _submitting ? null : _pickDate,
                      ),
                      const SizedBox(height: 12),

                      _TapField(
                        hint: l10n.tableReservationTimeHint,
                        value: _formatTime(_selectedTime, l10n),
                        icon: Icons.access_time,
                        onTap: _submitting ? null : _pickTime,
                      ),
                      const SizedBox(height: 12),

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
                                  () => _tableDropdownOpen = !_tableDropdownOpen,
                                ),
                        onSelectTable: (id) => setState(() {
                          _selectedTableId = id;
                          _tableDropdownOpen = false;
                        }),
                        tableNumberLabel: (name) => l10n.tableNumber(name),
                        seatCountLabel: (count) =>
                            l10n.tableSeatCount(count),
                      ),
                      const SizedBox(height: 12),

                      TextField(
                        controller: _internalNoteController,
                        enabled: !_submitting,
                        maxLines: 4,
                        onChanged: (_) {
                          if (_error != null) setState(() => _error = null);
                        },
                        decoration: InputDecoration(
                          hintText: l10n.tableReservationInternalNoteHint,
                          alignLabelWithHint: true,
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
                      if (_error != null) ...[
                        const SizedBox(height: 12),
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
              const SizedBox(height: 20),

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
                    : Text(l10n.tableReservationCreateButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StyledDropdownField<T> extends StatelessWidget {
  const _StyledDropdownField({
    required this.hint,
    required this.items,
    required this.onChanged,
    this.value,
  });

  final String hint;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(12),
        color: AppColors.surface,
      ),
      child: DropdownButton<T>(
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

class _TapField extends StatelessWidget {
  const _TapField({
    required this.hint,
    required this.value,
    required this.icon,
    required this.onTap,
  });

  final String hint;
  final String value;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final isPlaceholder = value == hint;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(12),
          color: AppColors.surface,
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                value,
                style: TextStyle(
                  color: isPlaceholder
                      ? AppColors.textSecondary
                      : AppColors.textPrimary,
                ),
              ),
            ),
            Icon(icon, size: 20, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
