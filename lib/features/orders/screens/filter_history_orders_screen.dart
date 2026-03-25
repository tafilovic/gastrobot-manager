import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/currency/venue_currency_format.dart';
import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/core/utils/calendar_day_bounds.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/history_order_filters.dart';
import 'package:gastrobotmanager/features/tables/providers/tables_provider.dart';
import 'package:gastrobotmanager/features/tables/widgets/tables_filter_table_chips_grouped.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Screen for filtering history orders: date range, order content (food/drinks), table numbers, bill range.
/// Pops with [HistoryOrderFilters] when user taps Apply.
class FilterHistoryOrdersScreen extends StatefulWidget {
  const FilterHistoryOrdersScreen({
    super.key,
    this.initialFilters,
  });

  final HistoryOrderFilters? initialFilters;

  @override
  State<FilterHistoryOrdersScreen> createState() =>
      _FilterHistoryOrdersScreenState();
}

class _FilterHistoryOrdersScreenState extends State<FilterHistoryOrdersScreen> {
  DateTime? _dateFrom;
  DateTime? _dateTo;
  late Set<String> _orderContentTypes;
  late Set<String> _tableIds;
  late double _billMin;
  late double _billMax;

  static const double _billMaxValue = 200000;

  @override
  void initState() {
    super.initState();
    final f = widget.initialFilters;
    _dateFrom = f?.dateFrom;
    _dateTo = f?.dateTo ?? CalendarDayBounds.endOfDay(DateTime.now());
    _orderContentTypes = f?.orderContentTypes.toSet() ?? {};
    _tableIds = f?.tableIds.toSet() ?? {};
    _billMin = f?.billMin ?? 0;
    _billMax = f?.billMax ?? _billMaxValue;
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTables());
  }

  void _loadTables() {
    if (!mounted) return;
    final venueId = context.read<AuthProvider>().currentVenueId;
    if (venueId != null) {
      context.read<TablesProvider>().load(venueId);
    }
  }

  HistoryOrderFilters get _currentFilters => HistoryOrderFilters(
        dateFrom: _dateFrom,
        dateTo: _dateTo,
        orderContentTypes: _orderContentTypes,
        tableIds: _tableIds,
        billMin: _billMin,
        billMax: _billMax,
      );

  void _reset() {
    setState(() {
      _dateFrom = null;
      _dateTo = CalendarDayBounds.endOfDay(DateTime.now());
      _orderContentTypes = {};
      _tableIds = {};
      _billMin = 0;
      _billMax = _billMaxValue;
    });
  }

  void _apply() {
    Navigator.of(context).pop(_currentFilters);
  }

  Future<void> _pickDate(BuildContext context, bool isFrom) async {
    final initial = isFrom ? (_dateFrom ?? DateTime.now()) : (_dateTo ?? DateTime.now());
    final first = isFrom ? null : _dateFrom;
    final last = isFrom ? (_dateTo ?? DateTime.now()) : DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(initial.year, initial.month, initial.day),
      firstDate: first != null
          ? DateTime(first.year, first.month, first.day)
          : DateTime(2020),
      lastDate: DateTime(last.year, last.month, last.day),
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

  static String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final isToday = _dateTo != null &&
        _dateTo!.year == now.year &&
        _dateTo!.month == now.month &&
        _dateTo!.day == now.day;

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
                    _buildDateField(
                      label: l10n.filterDateFrom,
                      value: _dateFrom != null ? _formatDate(_dateFrom!) : null,
                      onTap: () => _pickDate(context, true),
                    ),
                    const SizedBox(height: 10),
                    _buildDateField(
                      label: l10n.filterDateTo,
                      value: _dateTo != null
                          ? (isToday ? l10n.filterDateToday : _formatDate(_dateTo!))
                          : null,
                      onTap: () => _pickDate(context, false),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionLabel(l10n.filterOrderContent),
                    const SizedBox(height: 12),
                    _buildOrderContentChips(l10n),
                    const SizedBox(height: 24),
                    _buildSectionLabel(l10n.filterTableNumber),
                    const SizedBox(height: 12),
                    _buildTableNumberGrid(),
                    const SizedBox(height: 24),
                    _buildSectionLabel(l10n.filterBillAmount),
                    const SizedBox(height: 12),
                    _buildBillRangeSlider(),
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

  Widget _buildDateField({
    required String label,
    required String? value,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.border),
        ),
        child: Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            if (value != null && value.isNotEmpty) ...[
              const SizedBox(width: 8),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
            const Spacer(),
            Icon(Icons.calendar_today, size: 20, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderContentChips(AppLocalizations l10n) {
    final options = [
      (HistoryOrderFilters.orderContentDrink, l10n.filterOrderContentDrinks),
      (HistoryOrderFilters.orderContentFood, l10n.filterOrderContentFood),
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((o) {
        final selected = _orderContentTypes.contains(o.$1);
        return _HistoryFilterChip(
          label: o.$2,
          selected: selected,
          onTap: () {
            setState(() {
              if (selected) {
                _orderContentTypes = {..._orderContentTypes}..remove(o.$1);
              } else {
                _orderContentTypes = {..._orderContentTypes, o.$1};
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

  Widget _buildBillRangeSlider() {
    context.watch<AuthProvider>();
    final venueCurrency = context.read<AuthProvider>().currentVenueCurrency;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RangeSlider(
          values: RangeValues(_billMin, _billMax),
          min: 0,
          max: _billMaxValue,
          divisions: 200,
          activeColor: AppColors.accent,
          onChanged: (v) {
            setState(() {
              _billMin = v.start;
              _billMax = v.end;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              formatVenueIntForDisplay(
                context,
                _billMin.round(),
                venueCurrency,
              ),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              formatVenueIntForDisplay(
                context,
                _billMax.round(),
                venueCurrency,
              ),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _HistoryFilterChip extends StatelessWidget {
  const _HistoryFilterChip({
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
