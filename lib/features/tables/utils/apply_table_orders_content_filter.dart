import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_orders_filters.dart';

/// Client-side filter when [TableOrdersFilters.orderType] is set but the API
/// does not return a filtered list.
List<PendingOrder> applyTableOrdersContentFilter(
  List<PendingOrder> orders,
  TableOrdersFilters filters,
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
    if (type == TableOrdersFilters.orderTypeFood) {
      return hasFood;
    }
    if (type == TableOrdersFilters.orderTypeDrink) {
      return hasDrink;
    }
    return true;
  }).toList();
}
