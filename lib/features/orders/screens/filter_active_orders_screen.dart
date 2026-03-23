import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/currency/currency_provider.dart';
import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/active_order_filters.dart';
import 'package:gastrobotmanager/features/tables/providers/tables_provider.dart';
import 'package:gastrobotmanager/features/tables/widgets/tables_filter_table_chips_grouped.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Screen for filtering active orders: table numbers, food/drink statuses, bill range.
/// Pops with [ActiveOrderFilters] when user taps Apply.
class FilterActiveOrdersScreen extends StatefulWidget {
  const FilterActiveOrdersScreen({
    super.key,
    this.initialFilters,
  });

  final ActiveOrderFilters? initialFilters;

  @override
  State<FilterActiveOrdersScreen> createState() =>
      _FilterActiveOrdersScreenState();
}

class _FilterActiveOrdersScreenState extends State<FilterActiveOrdersScreen> {
  late Set<String> _tableIds;
  late Set<String> _foodStatuses;
  late Set<String> _drinkStatuses;
  late double _billMin;
  late double _billMax;

  static const double _billMaxValue = 200000;

  @override
  void initState() {
    super.initState();
    final f = widget.initialFilters;
    _tableIds = f?.tableIds.toSet() ?? {};
    _foodStatuses = f?.foodStatuses.toSet() ?? {};
    _drinkStatuses = f?.drinkStatuses.toSet() ?? {};
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

  ActiveOrderFilters get _currentFilters => ActiveOrderFilters(
        tableIds: _tableIds,
        foodStatuses: _foodStatuses,
        drinkStatuses: _drinkStatuses,
        billMin: _billMin,
        billMax: _billMax,
      );

  void _reset() {
    setState(() {
      _tableIds = {};
      _foodStatuses = {};
      _drinkStatuses = {};
      _billMin = 0;
      _billMax = _billMaxValue;
    });
  }

  void _apply() {
    Navigator.of(context).pop(_currentFilters);
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
                  _buildSectionLabel(l10n.filterTableNumber),
                  const SizedBox(height: 12),
                  _buildTableNumberGrid(),
                  const SizedBox(height: 24),
                  _buildSectionLabel(l10n.filterFood),
                  const SizedBox(height: 12),
                  _buildStatusChips(
                    selected: _foodStatuses,
                    onTap: (status) {
                      setState(() {
                        if (_foodStatuses.contains(status)) {
                          _foodStatuses = {..._foodStatuses}..remove(status);
                        } else {
                          _foodStatuses = {..._foodStatuses, status};
                        }
                      });
                    },
                    l10n: l10n,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionLabel(l10n.filterDrinks),
                  const SizedBox(height: 12),
                  _buildStatusChips(
                    selected: _drinkStatuses,
                    onTap: (status) {
                      setState(() {
                        if (_drinkStatuses.contains(status)) {
                          _drinkStatuses = {..._drinkStatuses}..remove(status);
                        } else {
                          _drinkStatuses = {..._drinkStatuses, status};
                        }
                      });
                    },
                    l10n: l10n,
                  ),
                  const SizedBox(height: 24),
                  _buildSectionLabel(l10n.filterBillAmount),
                  const SizedBox(height: 12),
                  _buildBillRangeSlider(l10n),
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
      style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: AppColors.textPrimary,
      ),
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

  Widget _buildStatusChips({
    required Set<String> selected,
    required void Function(String) onTap,
    required AppLocalizations l10n,
  }) {
    final statuses = [
      (ActiveOrderFilters.statusPending, l10n.filterStatusPending),
      (ActiveOrderFilters.statusInPreparation, l10n.filterStatusInPreparation),
      (ActiveOrderFilters.statusServed, l10n.filterStatusServed),
      (ActiveOrderFilters.statusRejected, l10n.filterStatusRejected),
    ];
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: statuses.map((s) {
        return _FilterChip(
          label: s.$2,
          selected: selected.contains(s.$1),
          onTap: () => onTap(s.$1),
        );
      }).toList(),
    );
  }

  Widget _buildBillRangeSlider(AppLocalizations l10n) {
    final currency = context.watch<CurrencyProvider>();

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
              currency.formatInt(_billMin.round()),
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textSecondary,
              ),
            ),
            Text(
              currency.formatInt(_billMax.round()),
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
