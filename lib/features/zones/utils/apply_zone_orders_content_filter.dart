import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/zones/domain/models/zone_orders_filters.dart';

/// Client-side filter when [ZoneOrdersFilters.orderType] is set but the API
/// does not return a filtered list.
List<PendingOrder> applyZoneOrdersContentFilter(
  List<PendingOrder> orders,
  ZoneOrdersFilters filters,
) {
  final type = filters.orderType;
  if (type == null || type.isEmpty) {
    return orders;
  }

  return orders.where((o) {
    final hasFood = o.items.any(
      (i) => i.type == null || i.type == 'food',
    );
    final hasDrink = o.items.any((i) => i.type == 'drink');
    if (type == ZoneOrdersFilters.orderTypeFood) {
      return hasFood;
    }
    if (type == ZoneOrdersFilters.orderTypeDrink) {
      return hasDrink;
    }
    return true;
  }).toList();
}
