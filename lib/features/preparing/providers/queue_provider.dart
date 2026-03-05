import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/preparing/domain/models/queue_order.dart';
import 'package:gastrobotmanager/features/preparing/domain/repositories/queue_api.dart';

/// Interval for refreshing queue (preparing). Change this value to adjust refresh rate.
const Duration queueRefreshInterval = Duration(seconds: 30);

/// Holds queue (preparing) orders for current role (kitchen or bar) and refreshes periodically.
class QueueProvider extends ChangeNotifier {
  QueueProvider(this._authProvider, this._api);

  final AuthProvider _authProvider;
  final QueueApi _api;

  List<QueueOrder> _orders = [];
  bool _isLoading = false;
  String? _error;
  Timer? _refreshTimer;
  String? _currentVenueId;

  List<QueueOrder> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String? get error => _error;

  static int _orderByTargetTime(QueueOrder a, QueueOrder b) {
    return a.targetTime.compareTo(b.targetTime);
  }

  void startPeriodicRefresh(String venueId) {
    _currentVenueId = venueId;
    stopPeriodicRefresh();
    _load(venueId);
    _refreshTimer = Timer.periodic(
      queueRefreshInterval,
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
      queueRefreshInterval,
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
      final list = await _api.getQueue(venueId, profileType);
      _orders = list..sort(_orderByTargetTime);
      _error = null;
    } catch (e) {
      _error = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      _orders = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Marks the order's items as ready. On success removes the order from the list.
  /// Returns [true] on success, [false] on failure (error stored in [error]).
  Future<bool> markOrderAsReady(QueueOrder order) async {
    final venueId = _currentVenueId;
    final profileType = _authProvider.profileType;
    if (venueId == null || profileType == null) return false;

    final itemIds = order.items.map((e) => e.id).toList();
    if (itemIds.isEmpty) return false;

    try {
      final success = await _api.markAsReady(venueId, itemIds, profileType);
      if (success) {
        _orders = _orders.where((o) => o.orderId != order.orderId).toList();
        _error = null;
        notifyListeners();
      }
      return success;
    } catch (e) {
      _error = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      notifyListeners();
      return false;
    }
  }

  @override
  void dispose() {
    stopPeriodicRefresh();
    super.dispose();
  }
}
