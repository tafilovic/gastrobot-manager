import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/zones/domain/models/zone_model.dart';
import 'package:gastrobotmanager/features/zones/domain/models/zone_orders_filters.dart';
import 'package:gastrobotmanager/features/zones/domain/repositories/zones_api.dart';

/// Holds the list of venue zones; loads on demand and supports pull-to-refresh.
class ZonesProvider extends ChangeNotifier {
  ZonesProvider(this._api);

  final ZonesApi _api;

  List<ZoneModel> _zones = [];
  bool _isLoading = false;
  String? _error;
  String? _currentVenueId;

  List<ZoneModel> get zones => List.unmodifiable(_zones);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Venue id from the last [load] / [pullRefresh] call, if any.
  String? get loadedVenueId => _currentVenueId;

  Future<void> load(String venueId) async {
    _currentVenueId = venueId;
    await _fetch(venueId);
  }

  Future<void> pullRefresh() async {
    final venueId = _currentVenueId;
    if (venueId == null) return;
    await _fetch(venueId);
  }

  Future<void> _fetch(String venueId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _zones = await _api.getZones(venueId);
      _error = null;
    } catch (e) {
      _error = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      _zones = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<ConfirmedReservation>> fetchActiveReservationsForZone(
    String zoneId,
  ) {
    return _api.getActiveReservationsForZone(zoneId);
  }

  Future<List<PendingOrder>> fetchOrdersForZone(
    String zoneId,
    ZoneOrdersFilters filters,
  ) {
    return _api.getOrdersForZone(zoneId, filters);
  }
}
