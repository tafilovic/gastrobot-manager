import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/utils/format_reservation_date.dart';
import 'package:gastrobotmanager/features/reservations/widgets/reservation_item_tile.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Read-only kitchen/bar pending reservation request details (no accept/reject).
class KitchenBarReservationRequestDetailsContent extends StatelessWidget {
  const KitchenBarReservationRequestDetailsContent({
    super.key,
    required this.order,
    this.onCompleted,
  });

  final PendingOrder order;
  final VoidCallback? onCompleted;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accentColor = Theme.of(context).colorScheme.primary;
    final profileType = context.watch<AuthProvider>().profileType;
    final itemIcon = profileType == ProfileType.kitchen
        ? Icons.restaurant
        : Icons.local_bar;
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = formatReservationDate(
      order.targetTime,
      l10n,
      locale: locale,
    );
    final timeStr = formatReservationTime(order.targetTime);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: Row(
            children: [
              Icon(Icons.calendar_today, size: 20, color: accentColor),
              const SizedBox(width: 8),
              Text(
                dateStr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const Spacer(),
              Text(
                timeStr,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: accentColor,
                      fontWeight: FontWeight.w500,
                    ),
              ),
              const SizedBox(width: 6),
              Icon(Icons.access_time, size: 20, color: accentColor),
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: order.items.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = order.items[index];
              return ReservationItemTile(
                item: item,
                isChecked: false,
                accentColor: accentColor,
                isDisabled: true,
                readOnly: true,
                itemIcon: itemIcon,
                onTap: null,
              );
            },
          ),
        ),
      ],
    );
  }
}
