import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/domain/constants/reservations_pagination.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/pending_reservation.dart';
import 'package:gastrobotmanager/features/reservations/domain/repositories/reservation_actions_api.dart';
import 'package:gastrobotmanager/features/reservations/domain/repositories/reservations_api.dart';
import 'package:gastrobotmanager/features/reservations/providers/pagination_state.dart';

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
  final PaginationState _waiterPagination = PaginationState();

  List<PendingReservation> _waiterRequests = [];
  List<PendingOrder> _kitchenBarRequests = [];
  bool _isLoading = false;
  bool _isRefreshingPendingIncremental = false;
  String? _error;
  String? _rejectError;
  String? _acceptError;
  String? _currentVenueId;

  /// Waiter: pending reservations from GET …/v1/venues/:venueId/reservations?status=pending.
  List<PendingReservation> get waiterRequests =>
      List.unmodifiable(_waiterRequests);

  /// Kitchen/bar: pending order-shaped rows with `source=reservation`.
  List<PendingOrder> get kitchenBarRequests =>
      List.unmodifiable(_kitchenBarRequests);
  bool get isLoading => _isLoading;
  bool get isLoadingMoreWaiter => _waiterPagination.isLoadingMore;
  bool get hasMoreWaiter => _waiterPagination.hasMore;
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
    final sameVenue = _currentVenueId == venueId;
    _currentVenueId = venueId;
    if (_shouldUseIncrementalRefresh(sameVenue: sameVenue)) {
      await refreshPendingIncremental();
      return;
    }
    await _load(venueId);
  }

  Future<void> pullRefresh() async {
    final venueId = _currentVenueId;
    if (venueId == null) return;
    if (_authProvider.profileType == ProfileType.waiter &&
        _waiterRequests.isNotEmpty) {
      await refreshPendingIncremental();
      return;
    }
    await _load(venueId);
  }

  bool _shouldUseIncrementalRefresh({required bool sameVenue}) {
    return _authProvider.profileType == ProfileType.waiter &&
        sameVenue &&
        _waiterRequests.isNotEmpty;
  }

  Future<void> refreshPendingIncremental([String? venueIdOverride]) async {
    final venueId = venueIdOverride ?? _currentVenueId;
    if (venueId == null) return;
    _currentVenueId = venueId;
    if (_mustFallbackToFullLoad()) {
      await _load(venueId);
      return;
    }
    if (_isBlockedForIncrementalRefresh()) {
      return;
    }

    _isRefreshingPendingIncremental = true;
    try {
      final refreshResult = await _collectIncrementalPendingUpdates(venueId);
      final newItems = refreshResult.$1;
      final total = refreshResult.$2;
      if (newItems.isNotEmpty) {
        _waiterRequests = [...newItems, ..._waiterRequests];
        _updateWaiterHasMore(total: total);
        notifyListeners();
      }
    } catch (_) {
      // Keep current list and retry on next timer tick.
    } finally {
      _isRefreshingPendingIncremental = false;
    }
  }

  bool _mustFallbackToFullLoad() {
    return _authProvider.profileType != ProfileType.waiter ||
        _waiterRequests.isEmpty;
  }

  bool _isBlockedForIncrementalRefresh() {
    return _isLoading ||
        _waiterPagination.isLoadingMore ||
        _isRefreshingPendingIncremental;
  }

  Future<(List<PendingReservation>, int)> _collectIncrementalPendingUpdates(
    String venueId,
  ) async {
    final existingIds = _waiterRequests.map((r) => r.id).toSet();
    final newItems = <PendingReservation>[];
    var page = 1;
    var total = _waiterRequests.length;
    var overlapFound = false;

    while (!overlapFound) {
      final pageData = await _api.getWaiterPendingReservations(
        venueId: venueId,
        page: page,
        limit: reservationsPageSize,
      );
      if (page == 1) {
        total = pageData.total;
      }
      if (pageData.items.isEmpty) break;

      for (final item in pageData.items) {
        if (existingIds.contains(item.id)) {
          overlapFound = true;
          break;
        }
        existingIds.add(item.id);
        newItems.add(item);
      }

      if (overlapFound || newItems.length >= total) {
        break;
      }
      page += 1;
    }

    return (newItems, total);
  }

  Future<void> loadMoreWaiterRequests() async {
    final venueId = _currentVenueId;
    if (venueId == null) return;
    if (_authProvider.profileType != ProfileType.waiter) return;
    if (!_waiterPagination.canLoadMore(isLoading: _isLoading)) return;

    _waiterPagination.startLoadingMore();
    notifyListeners();
    try {
      final nextPage = _waiterPagination.nextPage();
      final pageData = await _api.getWaiterPendingReservations(
        venueId: venueId,
        page: nextPage,
        limit: reservationsPageSize,
      );
      _waiterRequests = [..._waiterRequests, ...pageData.items];
      _waiterPagination.markFetched(page: nextPage, loadedItemsCount: _waiterRequests.length, total: pageData.total);
    } catch (_) {
      // Keep existing items; next scroll can retry.
      _waiterPagination.stopLoadingMore();
    } finally {
      notifyListeners();
    }
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
    if (_isLoading) return;
    final profileType = _authProvider.profileType;
    if (profileType == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      if (profileType == ProfileType.waiter) {
        final pageData = await _api.getWaiterPendingReservations(
          venueId: venueId,
          page: 1,
          limit: reservationsPageSize,
        );
        _waiterRequests = pageData.items..sort(_reservationByStartDesc);
        _waiterPagination.markFetched(page: 1, loadedItemsCount: _waiterRequests.length, total: pageData.total);
        _kitchenBarRequests = [];
      } else {
        final list =
            await _api.getKitchenBarReservationRequests(venueId, profileType);
        _kitchenBarRequests = list..sort(_orderByTargetTimeDesc);
        _waiterRequests = [];
        _waiterPagination.reset(hasMore: false);
      }
      _error = null;
    } catch (e) {
      _error = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      _waiterRequests = [];
      _kitchenBarRequests = [];
      _waiterPagination.reset(hasMore: false);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _updateWaiterHasMore({required int total}) {
    _waiterPagination.updateHasMore(
      loadedItemsCount: _waiterRequests.length,
      total: total,
    );
  }
}
