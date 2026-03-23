import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';
import 'package:gastrobotmanager/features/tables/utils/table_type_display.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Title, type line, and availability dot.
class TableOverviewHeader extends StatelessWidget {
  const TableOverviewHeader({
    super.key,
    required this.table,
    required this.l10n,
    required this.typeLabel,
  });

  final TableModel table;
  final AppLocalizations l10n;
  final String typeLabel;

  @override
  Widget build(BuildContext context) {
    final statusColor =
        table.isFree ? AppColors.success : AppColors.destructive;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                seatingQualifiedTitle(l10n, table),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
              ),
              const SizedBox(height: 4),
              Text(
                typeLabel,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textSecondary,
                    ),
              ),
            ],
          ),
        ),
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: statusColor,
            shape: BoxShape.circle,
          ),
        ),
      ],
    );
  }
}
