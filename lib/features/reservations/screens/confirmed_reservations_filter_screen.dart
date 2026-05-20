import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/core/utils/calendar_day_bounds.dart';
import 'package:gastrobotmanager/core/widgets/filter/filter_form_fields.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/regions/domain/models/region_model.dart';
import 'package:gastrobotmanager/features/regions/providers/regions_provider.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservations_filters.dart';
import 'package:gastrobotmanager/features/reservations/utils/format_filter_date.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Filter screen for confirmed reservations: unique code, region, date range.
/// Pops with [ConfirmedReservationsFilters] only when the user taps Apply.
class ConfirmedReservationsFilterScreen extends StatefulWidget {
  const ConfirmedReservationsFilterScreen({super.key, this.initialFilters});

  final ConfirmedReservationsFilters? initialFilters;

  @override
  State<ConfirmedReservationsFilterScreen> createState() =>
      _ConfirmedReservationsFilterScreenState();
}

class _ConfirmedReservationsFilterScreenState
    extends State<ConfirmedReservationsFilterScreen> {
  late final TextEditingController _codeController;
  String? _regionId;
  DateTime? _dateFrom;
  DateTime? _dateTo;

  @override
  void initState() {
    super.initState();
    final f = widget.initialFilters;
    _codeController = TextEditingController(text: f?.reservationNumber ?? '');
    _regionId = f?.regionId;
    _dateFrom = f?.dateFrom;
    _dateTo = f?.dateTo;
    _codeController.addListener(_notifyLocalChange);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadRegions());
  }

  @override
  void dispose() {
    _codeController
      ..removeListener(_notifyLocalChange)
      ..dispose();
    super.dispose();
  }

  void _notifyLocalChange() {
    if (mounted) setState(() {});
  }

  void _loadRegions() {
    if (!mounted) return;
    final venueId = context.read<AuthProvider>().currentVenueId;
    if (venueId != null) {
      context.read<RegionsProvider>().load(venueId);
    }
  }

  ConfirmedReservationsFilters get _currentFilters => ConfirmedReservationsFilters(
    reservationNumber: _codeController.text.trim().isEmpty
        ? null
        : _codeController.text.trim(),
    regionId: _regionId,
    dateFrom: _dateFrom,
    dateTo: _dateTo,
  );

  bool get _showsDefaultDateHint => _dateFrom == null && _dateTo == null;

  void _close() {
    Navigator.of(context).pop();
  }

  void _resetFilters() {
    Navigator.of(context).pop(ConfirmedReservationsFilters());
  }

  void _apply() {
    Navigator.of(context).pop(_currentFilters);
  }

  Future<void> _pickDate(bool isFrom) async {
    final initial = isFrom ? _dateFrom : _dateTo;
    final base = initial ?? DateTime.now();
    final first = isFrom
        ? DateTime(2020)
        : (_dateFrom != null
              ? DateTime(_dateFrom!.year, _dateFrom!.month, _dateFrom!.day)
              : DateTime(2020));
    final last = isFrom
        ? (_dateTo != null
              ? DateTime(_dateTo!.year, _dateTo!.month, _dateTo!.day)
              : DateTime(2035))
        : DateTime(2035);
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(base.year, base.month, base.day),
      firstDate: first,
      lastDate: last,
    );
    if (picked != null && mounted) {
      setState(() {
        if (isFrom) {
          _dateFrom = CalendarDayBounds.startOfDay(picked);
          if (_dateTo != null && _dateTo!.isBefore(_dateFrom!)) {
            _dateTo = CalendarDayBounds.endOfDay(picked);
          }
        } else {
          _dateTo = CalendarDayBounds.endOfDay(picked);
          if (_dateFrom != null && _dateFrom!.isAfter(_dateTo!)) {
            _dateFrom = CalendarDayBounds.startOfDay(picked);
          }
        }
      });
    }
  }

  String _formatDate(DateTime? date, AppLocalizations l10n) {
    return formatFilterDateOptional(
      date,
      emptyLabel: '—',
      todayLabel: l10n.filterDateToday,
      locale: Localizations.localeOf(context).toString(),
    );
  }

  String _defaultDateHint(AppLocalizations l10n) {
    final range = ConfirmedReservationsFilters.defaultApiDateRange();
    return l10n.confirmedResFilterDefaultDateHint(
      formatFilterDate(range.from),
      formatFilterDate(range.to),
    );
  }

  Future<void> _openRegionPicker(
    AppLocalizations l10n,
    List<RegionModel> regions,
  ) async {
    final result = await showDialog<_RegionPickerResult>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return Dialog(
          insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420, maxHeight: 520),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      l10n.filterRegionLabel,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      RadioListTile<String?>(
                        title: Text(l10n.filterAllRegions),
                        value: null,
                        groupValue: _regionId,
                        onChanged: (value) => Navigator.pop(
                          ctx,
                          _RegionPickerResult(regionId: value),
                        ),
                      ),
                      ...regions.map(
                        (r) => RadioListTile<String?>(
                          title: Text(r.title),
                          value: r.id,
                          groupValue: _regionId,
                          onChanged: (value) => Navigator.pop(
                            ctx,
                            _RegionPickerResult(regionId: value),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
    if (mounted && result != null) {
      setState(() => _regionId = result.regionId);
    }
  }

  String _regionLabel(AppLocalizations l10n, List<RegionModel> regions) {
    if (_regionId == null) return l10n.filterAllRegions;
    for (final r in regions) {
      if (r.id == _regionId) return r.title;
    }
    return l10n.filterAllRegions;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final regions = context.watch<RegionsProvider>().regions;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: _close,
        ),
        title: Text(l10n.filterTitle),
        centerTitle: true,
        backgroundColor: AppColors.appBarBackground,
        foregroundColor: AppColors.appBarForeground,
        elevation: 0,
      ),
      body: ConstrainedContent(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            FilterFieldLabel(l10n.filterUniqueCode),
                            const SizedBox(height: 8),
                            FilterTextField(
                              controller: _codeController,
                              hint: l10n.filterUniqueCodeHint,
                              prefixText: '# ',
                            ),
                            const SizedBox(height: 16),
                            FilterFieldLabel(l10n.filterRegionLabel),
                            const SizedBox(height: 8),
                            FilterTapField(
                              value: _regionLabel(l10n, regions),
                              trailing: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.textSecondary,
                                size: 22,
                              ),
                              onTap: () => _openRegionPicker(l10n, regions),
                            ),
                            const SizedBox(height: 16),
                            FilterFieldLabel(l10n.filterDateFilter),
                            const SizedBox(height: 8),
                            FilterFieldLabel(l10n.filterDateFrom),
                            const SizedBox(height: 8),
                            FilterTapField(
                              value: _formatDate(_dateFrom, l10n),
                              trailing: const Icon(
                                Icons.calendar_today_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              onTap: () => _pickDate(true),
                            ),
                            const SizedBox(height: 12),
                            FilterFieldLabel(l10n.filterDateTo),
                            const SizedBox(height: 8),
                            FilterTapField(
                              value: _formatDate(_dateTo, l10n),
                              trailing: const Icon(
                                Icons.calendar_today_outlined,
                                color: AppColors.textSecondary,
                                size: 20,
                              ),
                              onTap: () => _pickDate(false),
                            ),
                            if (_showsDefaultDateHint) ...[
                              const SizedBox(height: 10),
                              Text(
                                _defaultDateHint(l10n),
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.textSecondary,
                                  height: 1.35,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              decoration: BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.border)),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: _resetFilters,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.accent,
                        side: const BorderSide(color: AppColors.accent),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(l10n.filterReset),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: _apply,
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: AppColors.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      child: Text(l10n.filterApply),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Non-null when the user picked a region; null when the dialog was dismissed.
class _RegionPickerResult {
  const _RegionPickerResult({required this.regionId});

  final String? regionId;
}
