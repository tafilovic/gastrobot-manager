import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';

/// Removable chip for an active reservation list filter.
class ReservationFilterChip extends StatelessWidget {
  const ReservationFilterChip({
    super.key,
    required this.label,
    required this.onRemove,
  });

  final String label;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.filterChipBackground,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.filterChipForeground,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 6),
          InkWell(
            onTap: onRemove,
            borderRadius: BorderRadius.circular(12),
            child: const Icon(
              Icons.close,
              size: 16,
              color: AppColors.filterChipForeground,
            ),
          ),
        ],
      ),
    );
  }
}
