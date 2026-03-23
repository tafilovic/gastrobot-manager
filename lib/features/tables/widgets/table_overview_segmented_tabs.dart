import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';

/// Two-pill segment control for reservations vs orders.
class TableOverviewSegmentedTabs extends StatelessWidget {
  const TableOverviewSegmentedTabs({
    super.key,
    required this.accentColor,
    required this.selectedIndex,
    required this.reservationsLabel,
    required this.ordersLabel,
    required this.onChanged,
  });

  final Color accentColor;
  final int selectedIndex;
  final String reservationsLabel;
  final String ordersLabel;
  final ValueChanged<int> onChanged;

  Widget _pill({
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: selected ? accentColor : AppColors.surface,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: selected ? accentColor : accentColor,
              width: 1.5,
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: selected ? AppColors.onPrimary : accentColor,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _pill(
            label: reservationsLabel,
            selected: selectedIndex == 0,
            onTap: () => onChanged(0),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _pill(
            label: ordersLabel,
            selected: selectedIndex == 1,
            onTap: () => onChanged(1),
          ),
        ),
      ],
    );
  }
}
