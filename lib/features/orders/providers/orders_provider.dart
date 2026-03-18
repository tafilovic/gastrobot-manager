import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/domain/repositories/pending_orders_api.dart';
import 'package:gastrobotmanager/features/orders/domain/repositories/waiter_order_actions_api.dart';

/// Interval for refreshing pending orders. Change this to adjust refresh rate.
const Duration ordersRefreshInterval = Duration(seconds: 30);

/// Holds pending orders for the current role (kitchen, bar, waiter) and refreshes periodically.
/// Waiter history: [loadWaiterPaidOrders] from GET paid-orders; [markWaiterOrderAsPaid] refreshes it.
class OrdersProvider extends ChangeNotifier {
  OrdersProvider(
    this._authProvider,
    this._api, {
    WaiterOrderActionsApi? waiterOrderActionsApi,
  }) : _waiterOrderActionsApi = waiterOrderActionsApi;

  final AuthProvider _authProvider;
  final PendingOrdersApi _api;
  final WaiterOrderActionsApi? _waiterOrderActionsApi;

  List<PendingOrder> _orders = [];
  List<PendingOrder> _waiterPaidOrders = [];
  bool _isLoading = false;
  bool _isLoadingPaidOrders = false;
  String? _error;
  String? _paidOrdersError;
  String? _markPaidError;
  String? _currentVenueId;

  List<PendingOrder> get orders => List.unmodifiable(_orders);
  /// Waiter paid orders from GET …/waiter/paid-orders (newest first).
  List<PendingOrder> get waiterHistoryOrders =>
      List.unmodifiable(_waiterPaidOrders);
  bool get isLoading => _isLoading;
  bool get isLoadingPaidOrders => _isLoadingPaidOrders;
  String? get error => _error;
  String? get paidOrdersError => _paidOrdersError;
  String? get markPaidError => _markPaidError;

  static int _orderByTargetTime(PendingOrder a, PendingOrder b) {
    return a.targetTime.compareTo(b.targetTime);
  }

  static int _orderByTargetTimeDesc(PendingOrder a, PendingOrder b) {
    return b.targetTime.compareTo(a.targetTime);
  }

  Future<void> loadOnce(String venueId) async {
    if (_currentVenueId != venueId) {
      _waiterPaidOrders = [];
      _paidOrdersError = null;
    }
    _currentVenueId = venueId;
    await _load(venueId);
  }

  Future<void> pullRefresh() async {
    final venueId = _currentVenueId;
    if (venueId == null) return;
    await _load(venueId);
  }

  /// Waiter: loads paid order history. Set [showLoadingIndicator] false when refreshing after pay.
  Future<void> loadWaiterPaidOrders(
    String venueId, {
    bool showLoadingIndicator = true,
  }) async {
    final api = _waiterOrderActionsApi;
    if (api == null || _authProvider.profileType != ProfileType.waiter) {
      return;
    }
    if (showLoadingIndicator) {
      _isLoadingPaidOrders = true;
      _paidOrdersError = null;
      notifyListeners();
    }
    try {
      final list = await api.getPaidOrders(venueId);
      _waiterPaidOrders = list..sort(_orderByTargetTimeDesc);
      _paidOrdersError = null;
    } catch (e) {
      _paidOrdersError =
          e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      _waiterPaidOrders = [];
    } finally {
      if (showLoadingIndicator) {
        _isLoadingPaidOrders = false;
      }
      notifyListeners();
    }
  }

  Future<void> _load(String venueId) async {
    final profileType = _authProvider.profileType;
    if (profileType == null) return;

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final list = await _api.getPendingOrders(venueId, profileType);
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

  /// PATCH pay; on success removes from active list and reloads paid-orders list.
  Future<bool> markWaiterOrderAsPaid(String venueId, PendingOrder order) async {
    _markPaidError = null;
    final api = _waiterOrderActionsApi;
    if (api == null) {
      _markPaidError = 'Pay action not available';
      notifyListeners();
      return false;
    }
    try {
      await api.markOrderAsPaid(venueId, order.orderId);
      _orders = _orders.where((o) => o.orderId != order.orderId).toList();
      _error = null;
      notifyListeners();
      await loadWaiterPaidOrders(venueId, showLoadingIndicator: false);
      return true;
    } catch (e) {
      _markPaidError =
          e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      notifyListeners();
      return false;
    }
  }
}
