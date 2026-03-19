import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/reservations/domain/repositories/confirmed_reservations_api.dart';

/// Holds the list of confirmed reservations for the waiter role.
class ConfirmedReservationsProvider extends ChangeNotifier {
  ConfirmedReservationsProvider(this._api);

  final ConfirmedReservationsApi _api;

  List<ConfirmedReservation> _items = [];
  bool _isLoading = false;
  String? _error;
  String? _currentVenueId;

  List<ConfirmedReservation> get items => List.unmodifiable(_items);
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
      _items = await _api.getConfirmed(venueId);
      _error = null;
    } catch (e) {
      _error = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      _items = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
