import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Count label (highlighted number) and filter action for the table orders tab.
class TableOverviewOrdersHeaderRow extends StatelessWidget {
  const TableOverviewOrdersHeaderRow({
    super.key,
    required this.count,
    required this.l10n,
    required this.accentColor,
    required this.theme,
    required this.onFilterTap,
  });

  final int count;
  final AppLocalizations l10n;
  final Color accentColor;
  final ThemeData theme;
  final VoidCallback onFilterTap;

  @override
  Widget build(BuildContext context) {
    final full = l10n.ordersCount(count);
    final suffix = full.replaceFirst(RegExp(r'^\d+'), '');
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text.rich(
            TextSpan(
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
              children: [
                TextSpan(
                  text: '$count',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: accentColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
                TextSpan(text: suffix),
              ],
            ),
          ),
        ),
        TextButton.icon(
          onPressed: onFilterTap,
          style: TextButton.styleFrom(
            foregroundColor: accentColor,
            padding: const EdgeInsets.symmetric(horizontal: 8),
          ),
          icon: Icon(Icons.filter_list, size: 20, color: accentColor),
          label: Text(
            l10n.ordersFilters,
            style: theme.textTheme.labelLarge?.copyWith(
              color: accentColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
