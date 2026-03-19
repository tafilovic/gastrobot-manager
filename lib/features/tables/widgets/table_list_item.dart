import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Card in the tables list showing status, number, type and next reservation.
class TableListItem extends StatelessWidget {
  const TableListItem({super.key, required this.table});

  final TableModel table;

  String _typeLabel(AppLocalizations l10n) {
    switch (table.type) {
      case 'room':
        return l10n.tableTypeRoom;
      case 'sunbed':
        return l10n.tableTypeSunbed;
      default:
        return l10n.tableTypeTable;
    }
  }

  String _formatTime(DateTime dt) {
    final h = dt.hour.toString().padLeft(2, '0');
    final m = dt.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final reservation = table.nextReservation;
    final statusColor =
        table.isFree ? AppColors.success : AppColors.destructive;

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SvgPicture.asset(
                'assets/icons/table.svg',
                width: 22,
                height: 22,
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
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _typeLabel(l10n),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          if (reservation != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  l10n.tableReservationAt,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                Text(
                  _formatTime(reservation.startsAt),
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
