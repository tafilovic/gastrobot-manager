import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Count label + filter button (+ optional chips) for waiter reservation tabs.
class WaiterReservationsFilterHeader extends StatelessWidget {
  const WaiterReservationsFilterHeader({
    super.key,
    required this.countLabel,
    required this.showFilterControls,
    required this.onOpenFilters,
    required this.accentColor,
    this.filterChips,
  });

  final String countLabel;
  final bool showFilterControls;
  final VoidCallback onOpenFilters;
  final Color accentColor;
  final Widget? filterChips;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: showFilterControls
              ? Row(
                  children: [
                    Text(
                      countLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: onOpenFilters,
                      icon: Icon(
                        Icons.filter_list,
                        size: 18,
                        color: accentColor,
                      ),
                      label: Text(
                        l10n.reservationsFilters,
                        style: TextStyle(
                          color: accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                )
              : Text(
                  countLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
        ),
        if (showFilterControls && filterChips != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
            child: filterChips,
          ),
      ],
    );
  }
}
