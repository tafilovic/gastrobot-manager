import 'package:gastrobotmanager/features/orders/domain/models/pending_order_item.dart';

/// Sums [PendingOrderItem.totalPrice] when present. Returns null if total is zero.
double? orderItemsTotalPriceSum(Iterable<PendingOrderItem> items) {
  var sum = 0.0;
  for (final item in items) {
    if (item.totalPrice != null) {
      sum += item.totalPrice!;
    }
  }
  if (sum == 0) {
    return null;
  }
  return sum;
}
