import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/currency/venue_currency_format.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/core/utils/calendar_day_bounds.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_orders_filters.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Filters for GET /v1/tables/:id/orders (date range, optional type/status, bill range).
/// Pops with [TableOrdersFilters] when the user applies.
class FilterTableOrdersScreen extends StatefulWidget {
  const FilterTableOrdersScreen({
    super.key,
    this.initialFilters,
  });

  final TableOrdersFilters? initialFilters;

  @override
  State<FilterTableOrdersScreen> createState() =>
      _FilterTableOrdersScreenState();
}

class _FilterTableOrdersScreenState extends State<FilterTableOrdersScreen> {
  late DateTime _dateFrom;
  late DateTime _dateTo;
  String? _orderType;
  String? _orderStatus;
  late double _billMin;
  late double _billMax;

  static const double _billMaxValue = 200000;

  @override
  void initState() {
    super.initState();
    final f = widget.initialFilters ?? TableOrdersFilters.defaults();
    _dateFrom = f.dateFrom;
    _dateTo = f.dateTo;
    _orderType = f.orderType;
    _orderStatus = f.orderStatus;
    _billMin = f.billMin;
    _billMax = f.billMax;
  }

  TableOrdersFilters get _currentFilters => TableOrdersFilters(
        dateFrom: _dateFrom,
        dateTo: _dateTo,
        orderType: _orderType,
        orderStatus: _orderStatus,
        billMin: _billMin,
        billMax: _billMax,
      );

  void _reset() {
    final d = TableOrdersFilters.defaults();
    setState(() {
      _dateFrom = d.dateFrom;
      _dateTo = d.dateTo;
      _orderType = null;
      _orderStatus = null;
      _billMin = d.billMin;
      _billMax = d.billMax;
    });
  }

  void _apply() {
    Navigator.of(context).pop(_currentFilters);
  }

  Future<void> _pickDate(BuildContext context, bool isFrom) async {
    final initial = isFrom ? _dateFrom : _dateTo;
    final first = isFrom ? null : _dateFrom;
    // "Od": cannot be after "Do". "Do": today or earlier (time set to 23:59:59.999 below).
    final last = isFrom ? _dateTo : DateTime.now();
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
          if (_dateTo.isBefore(_dateFrom)) {
            _dateTo = CalendarDayBounds.endOfDay(picked);
          }
        } else {
          _dateTo = CalendarDayBounds.endOfDay(picked);
          if (_dateFrom.isAfter(_dateTo)) {
            _dateFrom = CalendarDayBounds.startOfDay(picked);
          }
        }
      });
    }
  }

  static String _formatDate(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';
  }

  static String _statusLabel(AppLocalizations l10n, String status) {
    switch (status) {
      case 'awaiting_confirmation':
        return l10n.tableOrdersFilterStatusAwaitingConfirmation;
      case 'pending':
        return l10n.tableOrdersFilterStatusPending;
      case 'confirmed':
        return l10n.tableOrdersFilterStatusConfirmed;
      case 'rejected':
        return l10n.tableOrdersFilterStatusRejected;
      case 'expired':
        return l10n.tableOrdersFilterStatusExpired;
      case 'paid':
        return l10n.tableOrdersFilterStatusPaid;
      default:
        return status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final isTodayTo = _dateTo.year == now.year &&
        _dateTo.month == now.month &&
        _dateTo.day == now.day;
    final isTodayFrom = _dateFrom.year == now.year &&
        _dateFrom.month == now.month &&
        _dateFrom.day == now.day;

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
                      value: isTodayFrom
                          ? l10n.filterDateToday
                          : _formatDate(_dateFrom),
                      onTap: () => _pickDate(context, true),
                    ),
                    const SizedBox(height: 10),
                    _buildDateField(
                      label: l10n.filterDateTo,
                      value: isTodayTo
                          ? l10n.filterDateToday
                          : _formatDate(_dateTo),
                      onTap: () => _pickDate(context, false),
                    ),
                    const SizedBox(height: 24),
                    _buildSectionLabel(l10n.filterOrderContent),
                    const SizedBox(height: 12),
                    _buildOrderTypeChips(l10n),
                    const SizedBox(height: 24),
                    _buildSectionLabel(l10n.tableOrdersFilterStatusLabel),
                    const SizedBox(height: 12),
                    _buildStatusChips(l10n),
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
    required String value,
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
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Icon(Icons.calendar_today, size: 20, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderTypeChips(AppLocalizations l10n) {
    final options = <(String?, String)>[
      (null, l10n.tableOrdersFilterTypeAny),
      (TableOrdersFilters.orderTypeDrink, l10n.filterOrderContentDrinks),
      (TableOrdersFilters.orderTypeFood, l10n.filterOrderContentFood),
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((o) {
        final selected = _orderType == o.$1;
        return _TableOrderFilterChip(
          label: o.$2,
          selected: selected,
          onTap: () {
            setState(() => _orderType = o.$1);
          },
        );
      }).toList(),
    );
  }

  Widget _buildStatusChips(AppLocalizations l10n) {
    final options = <(String?, String)>[
      (null, l10n.tableOrdersFilterStatusAny),
      ...TableOrdersFilters.orderStatusValues.map(
        (s) => (s, _statusLabel(l10n, s)),
      ),
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: options.map((o) {
        final selected = _orderStatus == o.$1;
        return _TableOrderFilterChip(
          label: o.$2,
          selected: selected,
          onTap: () {
            setState(() => _orderStatus = o.$1);
          },
        );
      }).toList(),
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

class _TableOrderFilterChip extends StatelessWidget {
  const _TableOrderFilterChip({
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
