import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';

/// A single info row used in waiter reservation detail screens.
///
/// Renders an [icon] on the left, then [label] in secondary colour followed
/// by [value] in bold primary colour.
class ReservationDetailRow extends StatelessWidget {
  const ReservationDetailRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.textMuted),
          const SizedBox(width: 10),
          Expanded(
            child: Text.rich(
              TextSpan(
                style: textTheme.bodyMedium
                    ?.copyWith(color: AppColors.textSecondary),
                children: [
                  TextSpan(text: '$label '),
                  TextSpan(
                    text: value,
                    style: textTheme.bodyMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
