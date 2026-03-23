import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';

/// Contract for fetching venue tables.
abstract class TablesApi {
  Future<List<TableModel>> getTables(String venueId);

  /// GET /v1/tables/:tableId/reservations/active — confirmed reservations for this table.
  Future<List<ConfirmedReservation>> getActiveReservationsForTable(
    String tableId,
  );
}
