import 'package:flutter/material.dart';

import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/widgets/pending_order_items_expansion_card.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Card for a single order in waiter's History tab (table, time, amount); tap opens details.
class WaiterOrderHistoryCard extends StatelessWidget {
  const WaiterOrderHistoryCard({
    super.key,
    required this.order,
    required this.accentColor,
    required this.l10n,
    required this.onSeeDetails,
    this.isSelected = false,
  });

  final PendingOrder order;
  final Color accentColor;
  final AppLocalizations l10n;
  final VoidCallback onSeeDetails;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return PendingOrderItemsExpansionCard(
      order: order,
      l10n: l10n,
      accentColor: accentColor,
      layout: PendingOrderItemsCardLayout.list,
      showSeeDetailsButton: false,
      showCategoryRows: false,
      onTap: onSeeDetails,
      isSelected: isSelected,
    );
  }
}
