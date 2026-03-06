import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/domain/repositories/reservations_api.dart';

const Duration _reservationsRefreshInterval = Duration(seconds: 30);

/// Holds reservation requests for current role and refreshes periodically.
class ReservationsProvider extends ChangeNotifier {
  ReservationsProvider(this._authProvider, this._api);

  final AuthProvider _authProvider;
  final ReservationsApi _api;

  List<PendingOrder> _requests = [];
  bool _isLoading = false;
  String? _error;
  Timer? _refreshTimer;
  String? _currentVenueId;

  List<PendingOrder> get requests => List.unmodifiable(_requests);
  bool get isLoading => _isLoading;
  String? get error => _error;

  static int _orderByTargetTime(PendingOrder a, PendingOrder b) {
    return a.targetTime.compareTo(b.targetTime);
  }

  void startPeriodicRefresh(String venueId) {
    _currentVenueId = venueId;
    stopPeriodicRefresh();
    _load(venueId);
    _refreshTimer = Timer.periodic(
      _reservationsRefreshInterval,
      (_) => _load(venueId),
    );
  }

  void stopPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  Future<void> pullRefresh() async {
    final venueId = _currentVenueId;
    if (venueId == null) return;
    await _load(venueId);
    stopPeriodicRefresh();
    _refreshTimer = Timer.periodic(
      _reservationsRefreshInterval,
      (_) => _load(venueId),
    );
  }

  Future<void> _load(String venueId) async {
    final profileType = _authProvider.profileType;
    if (profileType == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final list = await _api.getRequests(venueId, profileType);
      _requests = list..sort(_orderByTargetTime);
      _error = null;
    } catch (e) {
      _error = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      _requests = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
