import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_orders_filters.dart';

/// Contract for fetching venue tables.
abstract class TablesApi {
  Future<List<TableModel>> getTables(String venueId);

  /// GET /v1/tables/:tableId/reservations/active — confirmed reservations for this table.
  Future<List<ConfirmedReservation>> getActiveReservationsForTable(
    String tableId,
  );

  /// GET /v1/tables/:tableId/orders — pending orders for this table (waiter).
  Future<List<PendingOrder>> getOrdersForTable(
    String tableId,
    TableOrdersFilters filters,
  );
}
