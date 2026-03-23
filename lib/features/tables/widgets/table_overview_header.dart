import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Table icon, number, region/type, and availability dot.
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
        SvgPicture.asset(
          'assets/icons/table.svg',
          width: 28,
          height: 28,
          colorFilter: ColorFilter.mode(
            AppColors.textSecondary,
            BlendMode.srcIn,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.tableNumber(table.name),
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
