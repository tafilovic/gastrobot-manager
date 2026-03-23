import 'package:flutter/material.dart';

import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/utils/format_reservation_date.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Reservation request card. Waiter pending list: datum + šifra, Vreme, Region, Broj ljudi.
/// Kitchen/bar: stariji prikaz sa brojem stavki.
class ReservationRequestCard extends StatelessWidget {
  const ReservationRequestCard({
    super.key,
    required this.order,
    required this.l10n,
    required this.accentColor,
    required this.itemCountLabel,
    required this.onSeeDetails,
    this.showWaiterPendingLayout = false,
  });

  final PendingOrder order;
  final AppLocalizations l10n;
  final Color accentColor;
  final String itemCountLabel;
  final VoidCallback onSeeDetails;
  final bool showWaiterPendingLayout;

  static (String? region, int? party) _regionAndParty(PendingOrder order) {
    final d = order.reservationDetails;
    if (d is! Map) return (null, null);
    final m = Map<String, dynamic>.from(d);
    final r = m['region']?.toString().trim();
    final p = m['partySize'];
    final pi = p is int ? p : int.tryParse(p?.toString() ?? '');
    return ((r != null && r.isNotEmpty) ? r : null, pi);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final locale = Localizations.localeOf(context).languageCode;
    final dateStr = formatReservationDate(
      order.targetTime,
      l10n,
      locale: locale,
    );
    final timeStr = formatReservationTime(order.targetTime);
    final ref = order.orderNumber.isNotEmpty
        ? order.orderNumber
        : (order.orderId.isNotEmpty ? order.orderId : '—');

    if (showWaiterPendingLayout) {
      final (region, party) = _regionAndParty(order);
      return Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.calendar_today, size: 22, color: accentColor),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      dateStr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: accentColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.backgroundMuted,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      ref,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _waiterDetailRow(
                theme,
                l10n.reservationLabelTime,
                timeStr.isNotEmpty ? timeStr : 'N/A',
              ),
              _waiterDetailRow(
                theme,
                l10n.reservationLabelRegion,
                region ?? 'N/A',
              ),
              _waiterDetailRow(
                theme,
                l10n.reservationLabelPartySize,
                party != null ? '$party' : 'N/A',
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onSeeDetails,
                  style: FilledButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: AppColors.onPrimary,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(l10n.orderSeeDetails),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.calendar_today,
                  size: 20,
                  color: AppColors.textMuted,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        dateStr,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        itemCountLabel,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '#${order.orderNumber}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      timeStr,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Icon(
                      Icons.info_outline,
                      size: 20,
                      color: AppColors.textMuted,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed: onSeeDetails,
                style: FilledButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: Text(l10n.orderSeeDetails),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _waiterDetailRow(ThemeData theme, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 108,
            child: Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
