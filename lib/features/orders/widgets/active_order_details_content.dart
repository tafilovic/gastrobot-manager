import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/app_breakpoints.dart';
import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order_item.dart';
import 'package:gastrobotmanager/features/orders/providers/orders_provider.dart';
import 'package:gastrobotmanager/features/orders/utils/order_time_ago.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Reusable active order details body: table, time, food/drinks with status, bill, Mark as paid.
/// Used in [ActiveOrderDetailsScreen] and in master-detail detail pane.
/// When [markOrderAsPaid] is set, confirms then PATCH pay; on success calls [onCompleted] or pops.
class ActiveOrderDetailsContent extends StatefulWidget {
  const ActiveOrderDetailsContent({
    super.key,
    required this.order,
    this.billAmount,
    this.onCompleted,
    this.markOrderAsPaid,
  });

  final PendingOrder order;
  final String? billAmount;
  final VoidCallback? onCompleted;
  final Future<bool> Function()? markOrderAsPaid;

  static String? _computedBillTotal(PendingOrder order) {
    double sum = 0;
    for (final item in order.items) {
      if (item.totalPrice != null) sum += item.totalPrice!;
    }
    if (sum == 0) return null;
    return _formatRsd(sum);
  }

  static String _formatRsd(double value) {
    final intPart = value.floor();
    final frac = ((value - intPart) * 100).round().clamp(0, 99);
    final intStr = intPart.toString();
    final buf = StringBuffer();
    for (var i = 0; i < intStr.length; i++) {
      if (i > 0 && (intStr.length - i) % 3 == 0) buf.write('.');
      buf.write(intStr[i]);
    }
    return '${buf.toString()},${frac.toString().padLeft(2, '0')} RSD';
  }

  @override
  State<ActiveOrderDetailsContent> createState() =>
      _ActiveOrderDetailsContentState();
}

class _ActiveOrderDetailsContentState extends State<ActiveOrderDetailsContent> {
  bool _isPaying = false;

  Future<void> _onMarkAsPaidPressed() async {
    final pay = widget.markOrderAsPaid;
    final l10n = AppLocalizations.of(context)!;
    if (pay == null) {
      if (widget.onCompleted != null) {
        widget.onCompleted!();
      } else {
        Navigator.of(context).pop(true);
      }
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.orderMarkAsPaidConfirmTitle),
        content: Text(l10n.orderMarkAsPaidConfirmMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.dialogNo),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.dialogYes),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    setState(() => _isPaying = true);
    final ok = await pay();
    if (!mounted) return;
    setState(() => _isPaying = false);

    final messenger = ScaffoldMessenger.maybeOf(context);
    if (ok) {
      messenger?.showSnackBar(
        SnackBar(content: Text(l10n.orderMarkAsPaidSuccess)),
      );
      if (widget.onCompleted != null) {
        widget.onCompleted!();
      } else {
        Navigator.of(context).pop(true);
      }
    } else {
      final orders = context.read<OrdersProvider>();
      messenger?.showSnackBar(
        SnackBar(
          content: Text(orders.markPaidError ?? l10n.orderMarkAsPaidError),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final order = widget.order;
    final accentColor = Theme.of(context).colorScheme.primary;
    final tableNum = int.tryParse(order.tableNumber) ?? 0;
    final timeAgo = formatOrderTimeAgo(order.targetTime, l10n);
    final canMarkAsPaid = order.items.isNotEmpty &&
        order.items.every(
          (i) => i.status == 'rejected' || i.status == 'delivered',
        );
    final foodItems = order.items
        .where((i) => i.type == null || i.type == 'food')
        .toList();
    final drinkItems = order.items.where((i) => i.type == 'drink').toList();
    final billTotal = widget.billAmount ??
        ActiveOrderDetailsContent._computedBillTotal(order);
    final width = MediaQuery.sizeOf(context).width;
    final maxWidth = width >= AppBreakpoints.expanded
        ? AppBreakpoints.contentMaxWidthWide
        : AppBreakpoints.contentMaxWidth;

    return ConstrainedContent(
      maxWidth: maxWidth,
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.table_restaurant,
                          size: 20, color: accentColor),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.orderTableNumber(tableNum),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: accentColor,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              timeAgo,
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: AppColors.backgroundMuted,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          order.orderNumber,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(height: 1),
                  LayoutBuilder(
                    builder: (context, constraints) {
                      final width = MediaQuery.sizeOf(context).width;
                      final useTwoColumns = width >= AppBreakpoints.expanded;
                      final foodSection = [
                        if (foodItems.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _SectionHeader(
                              icon: Icons.restaurant,
                              label: l10n.ordersFoodLabel),
                          const SizedBox(height: 12),
                          ...foodItems.map((item) => _OrderDetailItemRow(
                                item: item,
                                accentColor: accentColor,
                              )),
                        ],
                      ];
                      final drinkSection = [
                        if (drinkItems.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          _SectionHeader(
                              icon: Icons.local_bar,
                              label: l10n.ordersDrinksLabel),
                          const SizedBox(height: 12),
                          ...drinkItems.map((item) => _OrderDetailItemRow(
                                item: item,
                                accentColor: accentColor,
                              )),
                        ],
                      ];
                      if (useTwoColumns &&
                          foodItems.isNotEmpty &&
                          drinkItems.isNotEmpty) {
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 16),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: foodSection,
                                  ),
                                ),
                                const SizedBox(width: 24),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: drinkSection,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            const Divider(height: 1),
                          ],
                        );
                      }
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ...foodSection,
                          if (foodItems.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Divider(height: 1),
                          ],
                          ...drinkSection,
                          if (drinkItems.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            const Divider(height: 1),
                          ],
                        ],
                      );
                    },
                  ),
                  if (billTotal != null) ...[
                    const SizedBox(height: 16),
                    _SectionHeader(
                        icon: Icons.receipt_long, label: l10n.orderBill),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Text(
                        billTotal,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border(top: BorderSide(color: AppColors.border)),
            ),
            child: SizedBox(
              width: double.infinity,
              child: FilledButton(
                onPressed:
                    (_isPaying || !canMarkAsPaid) ? null : _onMarkAsPaidPressed,
                style: FilledButton.styleFrom(
                  backgroundColor: accentColor,
                  foregroundColor: AppColors.onPrimary,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: _isPaying
                    ? SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.onPrimary,
                        ),
                      )
                    : Text(l10n.orderMarkAsPaid),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: AppColors.textPrimary),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _OrderDetailItemRow extends StatelessWidget {
  const _OrderDetailItemRow({
    required this.item,
    required this.accentColor,
  });

  final PendingOrderItem item;
  final Color accentColor;

  (Color color, IconData icon) _statusIcon() {
    switch (item.status) {
      case 'pending':
        return (const Color(0xFFFF9800), Icons.help_outline);
      case 'ready':
        return (AppColors.success, Icons.check_circle);
      case 'rejected':
        return (AppColors.error, Icons.cancel);
      default:
        return (accentColor, Icons.settings);
    }
  }

  @override
  Widget build(BuildContext context) {
    final (color, icon) = _statusIcon();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 18, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                if (item.notes.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    item.notes,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            'x${item.quantity}',
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
