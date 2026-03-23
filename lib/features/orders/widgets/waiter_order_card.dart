import 'package:flutter/material.dart';

import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/widgets/pending_order_items_expansion_card.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Active-tab order card: compact food/drink status rows; tap opens details (full card).
class WaiterOrderCard extends StatelessWidget {
  const WaiterOrderCard({
    super.key,
    required this.order,
    required this.accentColor,
    required this.l10n,
    required this.onTap,
    this.isSelected = false,
  });

  final PendingOrder order;
  final Color accentColor;
  final AppLocalizations l10n;
  final VoidCallback onTap;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return PendingOrderItemsExpansionCard(
      order: order,
      l10n: l10n,
      accentColor: accentColor,
      layout: PendingOrderItemsCardLayout.listCompact,
      showSeeDetailsButton: false,
      onTap: onTap,
      isSelected: isSelected,
    );
  }
}
