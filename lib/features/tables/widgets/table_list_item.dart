import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Single row in the tables list showing status, number, type and next reservation.
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
    final statusColor = table.isFree ? AppColors.success : AppColors.destructive;

    return Container(
      color: AppColors.surface,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(Icons.table_restaurant, size: 22, color: AppColors.textSecondary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.tableNumber(table.name),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _typeLabel(l10n),
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
                if (reservation != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    '${l10n.tableReservationAt} ${_formatTime(reservation.startsAt)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
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
    );
  }
}
