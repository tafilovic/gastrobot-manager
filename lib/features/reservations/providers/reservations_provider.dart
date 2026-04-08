import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/pending_reservation.dart';
import 'package:gastrobotmanager/features/reservations/domain/repositories/reservation_actions_api.dart';
import 'package:gastrobotmanager/features/reservations/domain/repositories/reservations_api.dart';

/// Holds reservation requests for current role and refreshes periodically.
class ReservationsProvider extends ChangeNotifier {
  ReservationsProvider(
    this._authProvider,
    this._api, {
    ReservationActionsApi? reservationActionsApi,
  }) : _reservationActionsApi = reservationActionsApi;

  final AuthProvider _authProvider;
  final ReservationsApi _api;
  final ReservationActionsApi? _reservationActionsApi;

  List<PendingReservation> _waiterRequests = [];
  List<PendingOrder> _kitchenBarRequests = [];
  bool _isLoading = false;
  String? _error;
  String? _rejectError;
  String? _acceptError;
  String? _currentVenueId;

  /// Waiter: pending reservations from GET …/waiter/reservations/pending.
  List<PendingReservation> get waiterRequests =>
      List.unmodifiable(_waiterRequests);

  /// Kitchen/bar: pending order-shaped rows with `source=reservation`.
  List<PendingOrder> get kitchenBarRequests =>
      List.unmodifiable(_kitchenBarRequests);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get rejectError => _rejectError;
  String? get acceptError => _acceptError;

  static int _orderByTargetTimeDesc(PendingOrder a, PendingOrder b) {
    return b.targetTime.compareTo(a.targetTime);
  }

  static int _reservationByStartDesc(PendingReservation a, PendingReservation b) {
    return b.reservationStart.compareTo(a.reservationStart);
  }

  Future<void> loadOnce(String venueId) async {
    _currentVenueId = venueId;
    await _load(venueId);
  }

  Future<void> pullRefresh() async {
    final venueId = _currentVenueId;
    if (venueId == null) return;
    await _load(venueId);
  }

  /// Waiter: reject reservation with reason and remove it from pending list on success.
  Future<bool> rejectWaiterReservation({
    required String venueId,
    required PendingReservation reservation,
    required String reason,
  }) async {
    _rejectError = null;
    final api = _reservationActionsApi;
    if (api == null) {
      _rejectError = 'Reject not available';
      notifyListeners();
      return false;
    }
    try {
      await api.rejectReservation(
        venueId: venueId,
        reservationId: reservation.id,
        reason: reason,
      );
      _waiterRequests =
          _waiterRequests.where((r) => r.id != reservation.id).toList();
      notifyListeners();
      return true;
    } catch (e) {
      _rejectError = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      notifyListeners();
      return false;
    }
  }

  /// Waiter: confirm reservation with selected tableIds and remove it from pending list on success.
  Future<bool> acceptWaiterReservation({
    required String venueId,
    required PendingReservation reservation,
    required List<String> tableIds,
    String? note,
  }) async {
    _acceptError = null;
    final api = _reservationActionsApi;
    if (api == null) {
      _acceptError = 'Accept not available';
      notifyListeners();
      return false;
    }
    try {
      await api.acceptReservation(
        venueId: venueId,
        reservationId: reservation.id,
        tableIds: tableIds,
        note: note,
      );
      _waiterRequests =
          _waiterRequests.where((r) => r.id != reservation.id).toList();
      notifyListeners();
      return true;
    } catch (e) {
      _acceptError = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      notifyListeners();
      return false;
    }
  }

  Future<void> _load(String venueId) async {
    final profileType = _authProvider.profileType;
    if (profileType == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (profileType == ProfileType.waiter) {
        final list = await _api.getWaiterPendingReservations(venueId);
        _waiterRequests = list..sort(_reservationByStartDesc);
        _kitchenBarRequests = [];
      } else {
        final list =
            await _api.getKitchenBarReservationRequests(venueId, profileType);
        _kitchenBarRequests = list..sort(_orderByTargetTimeDesc);
        _waiterRequests = [];
      }
      _error = null;
    } catch (e) {
      _error = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      _waiterRequests = [];
      _kitchenBarRequests = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
