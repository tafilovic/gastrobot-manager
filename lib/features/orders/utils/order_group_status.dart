import 'package:gastrobotmanager/features/orders/domain/models/pending_order_item.dart';

/// Display status for a group of items (food or drinks) on waiter order card.
enum OrderGroupStatus {
  pending,
  inPreparation,
  served,
  rejected,
}

/// Derives a single display status from a list of items (e.g. food items or drink items).
OrderGroupStatus orderGroupStatusFromItems(List<PendingOrderItem> items) {
  if (items.isEmpty) return OrderGroupStatus.pending;
  final hasPending = items.any((i) => i.status == 'pending');
  final hasReady = items.any((i) => i.status == 'ready');
  final hasRejected = items.any((i) => i.status == 'rejected');
  if (hasRejected && !hasPending && !hasReady) return OrderGroupStatus.rejected;
  if (items.every((i) => i.status == 'ready')) return OrderGroupStatus.served;
  if (items.every((i) => i.status == 'pending')) return OrderGroupStatus.pending;
  return OrderGroupStatus.inPreparation;
}
