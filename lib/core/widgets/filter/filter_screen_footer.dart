import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';

enum FilterFooterLayout { row, column }

/// Reset/Cancel + Apply actions pinned to the bottom of filter screens.
class FilterScreenFooter extends StatelessWidget {
  const FilterScreenFooter({
    super.key,
    required this.secondaryLabel,
    required this.primaryLabel,
    required this.onSecondary,
    required this.onPrimary,
    this.layout = FilterFooterLayout.row,
  });

  final String secondaryLabel;
  final String primaryLabel;
  final VoidCallback onSecondary;
  final VoidCallback onPrimary;
  final FilterFooterLayout layout;

  @override
  Widget build(BuildContext context) {
    final secondary = SizedBox(
      width: layout == FilterFooterLayout.column ? double.infinity : null,
      child: OutlinedButton(
        onPressed: onSecondary,
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.accent,
          side: const BorderSide(color: AppColors.accent),
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(secondaryLabel),
      ),
    );

    final primary = SizedBox(
      width: layout == FilterFooterLayout.column ? double.infinity : null,
      child: FilledButton(
        onPressed: onPrimary,
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: AppColors.onPrimary,
          padding: const EdgeInsets.symmetric(vertical: 14),
        ),
        child: Text(primaryLabel),
      ),
    );

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: layout == FilterFooterLayout.row
          ? Row(
              children: [
                Expanded(child: secondary),
                const SizedBox(width: 12),
                Expanded(child: primary),
              ],
            )
          : Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                secondary,
                const SizedBox(height: 12),
                primary,
              ],
            ),
    );
  }
}
