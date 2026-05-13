import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/zones/domain/models/create_zone_order_request.dart';
import 'package:gastrobotmanager/features/zones/domain/models/zone_model.dart';
import 'package:gastrobotmanager/features/zones/domain/models/zone_orders_filters.dart';

/// Contract for fetching venue zones.
abstract class ZonesApi {
  Future<List<ZoneModel>> getZones(String venueId);

  /// GET /v1/tables/:zoneId/reservations/active.
  Future<List<ConfirmedReservation>> getActiveReservationsForZone(
    String zoneId,
  );

  /// GET /v1/tables/:zoneId/orders.
  Future<List<PendingOrder>> getOrdersForZone(
    String zoneId,
    ZoneOrdersFilters filters,
  );

  /// POST /v1/venues/:venueId/orders — create a zone order (waiter).
  Future<void> createVenueOrder(
    String venueId,
    CreateZoneOrderRequest request,
  );
}
