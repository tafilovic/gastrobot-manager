import 'package:flutter/material.dart';

import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/widgets/pending_order_items_expansion_card.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Highlighted active order summary on table overview (occupied table).
class TableOverviewActiveOrderCard extends StatelessWidget {
  const TableOverviewActiveOrderCard({
    super.key,
    required this.order,
    required this.l10n,
    required this.accentColor,
  });

  final PendingOrder order;
  final AppLocalizations l10n;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return PendingOrderItemsExpansionCard(
      order: order,
      l10n: l10n,
      accentColor: accentColor,
      layout: PendingOrderItemsCardLayout.tableOverviewHighlight,
      showSeeDetailsButton: false,
      showCategoryRows: false,
    );
  }
}
