import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';

/// Whether [order] belongs to [table] (by display number or table code).
bool pendingOrderMatchesTable(PendingOrder order, TableModel table) {
  final tn = order.tableNumber.trim();
  if (tn.isEmpty) return false;
  if (tn == table.name.trim()) return true;
  final code = table.code;
  if (code != null && code.isNotEmpty && tn == code.trim()) return true;
  return false;
}

/// Active waiter orders assigned to [table].
List<PendingOrder> pendingOrdersForTable(
  List<PendingOrder> orders,
  TableModel table,
) {
  return orders.where((o) => pendingOrderMatchesTable(o, table)).toList();
}
