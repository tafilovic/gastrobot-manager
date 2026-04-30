import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/features/reservations/domain/constants/reservations_pagination.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/reservations/domain/repositories/confirmed_reservations_api.dart';
import 'package:gastrobotmanager/features/reservations/providers/pagination_state.dart';

/// Holds the list of confirmed reservations for the waiter role.
class ConfirmedReservationsProvider extends ChangeNotifier {
  ConfirmedReservationsProvider(this._api);

  final ConfirmedReservationsApi _api;
  final PaginationState _pagination = PaginationState();

  List<ConfirmedReservation> _items = [];
  bool _isLoading = false;
  String? _error;
  String? _currentVenueId;

  List<ConfirmedReservation> get items => List.unmodifiable(_items);
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _pagination.isLoadingMore;
  bool get hasMore => _pagination.hasMore;
  String? get error => _error;

  static int _byReservationStartDesc(
    ConfirmedReservation a,
    ConfirmedReservation b,
  ) {
    return b.reservationStart.compareTo(a.reservationStart);
  }

  Future<void> load(String venueId) async {
    _currentVenueId = venueId;
    await _fetch(venueId);
  }

  Future<void> pullRefresh() async {
    final venueId = _currentVenueId;
    if (venueId == null) return;
    await _fetch(venueId);
  }

  Future<void> loadMore() async {
    final venueId = _currentVenueId;
    if (venueId == null) return;
    if (!_pagination.canLoadMore(isLoading: _isLoading)) return;

    _pagination.startLoadingMore();
    notifyListeners();
    try {
      final nextPage = _pagination.nextPage();
      final pageData = await _api.getConfirmed(
        venueId: venueId,
        page: nextPage,
        limit: reservationsPageSize,
      );
      _items = [..._items, ...pageData.items];
      _pagination.markFetched(
        page: nextPage,
        loadedItemsCount: _items.length,
        total: pageData.total,
      );
    } catch (_) {
      // Keep current list and allow retry on next scroll.
      _pagination.stopLoadingMore();
    } finally {
      notifyListeners();
    }
  }

  Future<void> _fetch(String venueId) async {
    if (_isLoading) return;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final pageData = await _api.getConfirmed(
        venueId: venueId,
        page: 1,
        limit: reservationsPageSize,
      );
      _items = pageData.items..sort(_byReservationStartDesc);
      _pagination.markFetched(
        page: 1,
        loadedItemsCount: _items.length,
        total: pageData.total,
      );
      _error = null;
    } catch (e) {
      _error = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      _items = [];
      _pagination.reset(hasMore: false);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
