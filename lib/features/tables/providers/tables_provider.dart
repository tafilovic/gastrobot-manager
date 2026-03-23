import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_orders_filters.dart';
import 'package:gastrobotmanager/features/tables/domain/repositories/tables_api.dart';

/// Holds the list of venue tables; loads on demand and supports pull-to-refresh.
class TablesProvider extends ChangeNotifier {
  TablesProvider(this._api);

  final TablesApi _api;

  List<TableModel> _tables = [];
  bool _isLoading = false;
  String? _error;
  String? _currentVenueId;

  List<TableModel> get tables => List.unmodifiable(_tables);
  bool get isLoading => _isLoading;
  String? get error => _error;

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
      _tables = await _api.getTables(venueId);
      _error = null;
    } catch (e) {
      _error = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      _tables = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<ConfirmedReservation>> fetchActiveReservationsForTable(
    String tableId,
  ) {
    return _api.getActiveReservationsForTable(tableId);
  }

  Future<List<PendingOrder>> fetchOrdersForTable(
    String tableId,
    TableOrdersFilters filters,
  ) {
    return _api.getOrdersForTable(tableId, filters);
  }
}
