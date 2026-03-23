import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Highlights the numeric count in [reservationCountList].
class TableOverviewReservationCountRow extends StatelessWidget {
  const TableOverviewReservationCountRow({
    super.key,
    required this.count,
    required this.l10n,
    required this.accentColor,
    required this.theme,
  });

  final int count;
  final AppLocalizations l10n;
  final Color accentColor;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final full = l10n.reservationCountList(count);
    final suffix = full.replaceFirst(RegExp(r'^\d+'), '');
    return Text.rich(
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
    );
  }
}
