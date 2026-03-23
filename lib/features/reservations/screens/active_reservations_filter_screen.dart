import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/core/utils/calendar_day_bounds.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/active_reservations_filters.dart';
import 'package:gastrobotmanager/features/tables/providers/tables_provider.dart';
import 'package:gastrobotmanager/features/tables/widgets/tables_filter_table_chips_grouped.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Screen for filtering active (accepted) reservations.
/// Design: date, people count, region, reservation content, table numbers.
/// Pops with [ActiveReservationsFilters] when user taps Apply.
class ActiveReservationsFilterScreen extends StatefulWidget {
  const ActiveReservationsFilterScreen({super.key, this.initialFilters});

  final ActiveReservationsFilters? initialFilters;

  @override
  State<ActiveReservationsFilterScreen> createState() =>
      _ActiveReservationsFilterScreenState();
}

class _ActiveReservationsFilterScreenState
    extends State<ActiveReservationsFilterScreen> {
  DateTime? _dateFrom;
  DateTime? _dateTo;
  late Set<int> _peopleCounts;
  late Set<String> _regions;
  late Set<String> _reservationContents;
  late Set<String> _tableIds;

  @override
  void initState() {
    super.initState();
    final f = widget.initialFilters;
    _dateFrom = f?.dateFrom;
    _dateTo = f?.dateTo;
    _peopleCounts = f?.peopleCounts.toSet() ?? {};
    _regions = f?.regions.toSet() ?? {};
    _reservationContents = f?.reservationContents.toSet() ?? {};
    _tableIds = f?.tableIds.toSet() ?? {};
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTables());
  }

  void _loadTables() {
    if (!mounted) return;
    final venueId = context.read<AuthProvider>().currentVenueId;
    if (venueId != null) {
      context.read<TablesProvider>().load(venueId);
    }
  }

  ActiveReservationsFilters get _currentFilters => ActiveReservationsFilters(
    dateFrom: _dateFrom,
    dateTo: _dateTo,
    peopleCounts: _peopleCounts,
    regions: _regions,
    reservationContents: _reservationContents,
    tableIds: _tableIds,
  );

  void _reset() {
    setState(() {
      _dateFrom = null;
      _dateTo = null;
      _peopleCounts = {};
      _regions = {};
      _reservationContents = {};
      _tableIds = {};
    });
  }

  void _apply() {
    Navigator.of(context).pop(_currentFilters);
  }

  Future<void> _pickDate(BuildContext context, bool isFrom) async {
    final initial = isFrom ? _dateFrom : _dateTo;
    final base = initial ?? DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(base.year, base.month, base.day),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel(l10n.filterDate),
                    const SizedBox(height: 12),
                    _buildDateRow(context, l10n),
                    _buildDivider(),
                    _buildSectionLabel(l10n.filterPeopleCount),
                    const SizedBox(height: 12),
                    _buildPeopleCountGrid(),
                    _buildDivider(),
                    _buildSectionLabel(l10n.filterRegion),
                    const SizedBox(height: 12),
                    _buildRegionChips(l10n),
                    _buildDivider(),
                    _buildSectionLabel(l10n.filterReservationContent),
                    const SizedBox(height: 12),
                    _buildReservationContentChips(l10n),
                    _buildDivider(),
                    _buildSectionLabel(l10n.filterTableNumber),
                    const SizedBox(height: 12),
                    _buildTableNumberGrid(),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
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
                      onPressed: _reset,
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

  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Divider(height: 1, color: AppColors.border),
    );
  }

  Widget _buildSectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
    );
  }

  Widget _buildDateRow(BuildContext context, AppLocalizations l10n) {
    String formatDate(DateTime? d) {
      if (d == null) return l10n.filterDateToday;
      final now = DateTime.now();
      final today = DateTime(now.year, now.month, now.day);
      final dateOnly = DateTime(d.year, d.month, d.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final tomorrow = today.add(const Duration(days: 1));

      if (dateOnly == today) return l10n.filterDateToday;
      if (dateOnly == yesterday) return l10n.filterDateYesterday;
      if (dateOnly == tomorrow) return l10n.filterDateTomorrow;

      final locale = Localizations.localeOf(context).toString();
      return DateFormat.yMd(locale).format(d);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _DateField(
          label: '${l10n.filterDateFrom} ${formatDate(_dateFrom)}',
          onTap: () => _pickDate(context, true),
        ),
        const SizedBox(height: 12),
        _DateField(
          label: '${l10n.filterDateTo} ${formatDate(_dateTo)}',
          onTap: () => _pickDate(context, false),
        ),
      ],
    );
  }

  Widget _buildPeopleCountGrid() {
    const counts = [
      1,
      2,
      3,
      4,
      5,
      6,
      7,
      8,
      9,
      10,
      11,
      12,
      13,
      14,
      15,
      16,
      17,
      18,
      19,
      20,
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: counts.map((n) {
        final selected = _peopleCounts.contains(n);
        return _FilterChip(
          label: n.toString(),
          selected: selected,
          onTap: () {
            setState(() {
              if (selected) {
                _peopleCounts = {..._peopleCounts}..remove(n);
              } else {
                _peopleCounts = {..._peopleCounts, n};
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildRegionChips(AppLocalizations l10n) {
    final options = [
      (ActiveReservationsFilters.regionIndoors, l10n.filterRegionIndoors),
      (ActiveReservationsFilters.regionGarden, l10n.filterRegionGarden),
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((o) {
        final selected = _regions.contains(o.$1);
        return _FilterChip(
          label: o.$2,
          selected: selected,
          onTap: () {
            setState(() {
              if (selected) {
                _regions = {..._regions}..remove(o.$1);
              } else {
                _regions = {..._regions, o.$1};
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildReservationContentChips(AppLocalizations l10n) {
    final options = [
      (ActiveReservationsFilters.contentDrink, l10n.filterOrderContentDrinks),
      (ActiveReservationsFilters.contentFood, l10n.filterOrderContentFood),
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((o) {
        final selected = _reservationContents.contains(o.$1);
        return _FilterChip(
          label: o.$2,
          selected: selected,
          onTap: () {
            setState(() {
              if (selected) {
                _reservationContents = {..._reservationContents}..remove(o.$1);
              } else {
                _reservationContents = {..._reservationContents, o.$1};
              }
            });
          },
        );
      }).toList(),
    );
  }

  Widget _buildTableNumberGrid() {
    return TablesFilterTableChipsGrouped(
      selectedTableIds: _tableIds,
      onToggleTableId: (id) {
        setState(() {
          if (_tableIds.contains(id)) {
            _tableIds = {..._tableIds}..remove(id);
          } else {
            _tableIds = {..._tableIds, id};
          }
        });
      },
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Icon(
              Icons.calendar_today,
              size: 20,
              color: AppColors.textSecondary,
            ),
          ],
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
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
