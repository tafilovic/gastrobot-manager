import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../auth/providers/auth_provider.dart';
import '../domain/models/kitchen_pending_order.dart';
import '../domain/repositories/kitchen_pending_api.dart';

/// Interval for refreshing kitchen pending orders. Change this value to adjust refresh rate.
const Duration kitchenOrdersRefreshInterval = Duration(seconds: 30);

/// Holds kitchen pending orders and refreshes periodically ([kitchenOrdersRefreshInterval]).
/// Call [startPeriodicRefresh] when the kitchen orders screen is shown, [stopPeriodicRefresh] when left.
class KitchenOrdersProvider extends ChangeNotifier {
  KitchenOrdersProvider(this._authProvider, this._api);

  final AuthProvider _authProvider;
  final KitchenPendingApi _api;

  List<KitchenPendingOrder> _orders = [];
  bool _isLoading = false;
  String? _error;
  Timer? _refreshTimer;
  String? _currentVenueId;

  List<KitchenPendingOrder> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Sorts by [KitchenPendingOrder.targetTime] ascending (oldest first).
  static int _orderByTargetTime(KitchenPendingOrder a, KitchenPendingOrder b) {
    return a.targetTime.compareTo(b.targetTime);
  }

  /// Starts loading and schedules refresh every [kitchenOrdersRefreshInterval]. Call with [venueId] from current user.
  void startPeriodicRefresh(String venueId) {
    _currentVenueId = venueId;
    stopPeriodicRefresh();
    _load(venueId);
    _refreshTimer = Timer.periodic(
      kitchenOrdersRefreshInterval,
      (_) => _load(venueId),
    );
  }

  void stopPeriodicRefresh() {
    _refreshTimer?.cancel();
    _refreshTimer = null;
  }

  /// Manual refresh (e.g. pull-to-refresh). Reloads data and resets the 30s timer from this moment.
  Future<void> pullRefresh() async {
    final venueId = _currentVenueId;
    if (venueId == null) return;
    await _load(venueId);
    stopPeriodicRefresh();
    _refreshTimer = Timer.periodic(
      kitchenOrdersRefreshInterval,
      (_) => _load(venueId),
    );
  }

  Future<void> _load(String venueId) async {
    final token = _authProvider.accessToken;
    if (token == null || token.isEmpty) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final list = await _api.getPendingOrders(venueId, token);
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

  @override
  void dispose() {
    stopPeriodicRefresh();
    super.dispose();
  }
}
