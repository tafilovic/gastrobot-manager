import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/domain/repositories/pending_orders_api.dart';
import 'package:gastrobotmanager/features/orders/domain/repositories/waiter_order_actions_api.dart';

/// Interval for refreshing pending orders. Change this to adjust refresh rate.
const Duration ordersRefreshInterval = Duration(seconds: 30);

/// Holds pending orders for the current role (kitchen, bar, waiter) and refreshes periodically.
/// Waiter: [markWaiterOrderAsPaid] moves an order from [orders] to [waiterHistoryOrders].
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
  final List<PendingOrder> _waiterPaidHistory = [];
  bool _isLoading = false;
  String? _error;
  String? _markPaidError;
  String? _currentVenueId;

  List<PendingOrder> get orders => List.unmodifiable(_orders);
  /// Orders marked paid in this session (waiter). Shown on History tab.
  List<PendingOrder> get waiterHistoryOrders =>
      List.unmodifiable(_waiterPaidHistory);
  bool get isLoading => _isLoading;
  String? get error => _error;
  String? get markPaidError => _markPaidError;

  static int _orderByTargetTime(PendingOrder a, PendingOrder b) {
    return a.targetTime.compareTo(b.targetTime);
  }

  Future<void> loadOnce(String venueId) async {
    if (_currentVenueId != venueId) {
      _waiterPaidHistory.clear();
    }
    _currentVenueId = venueId;
    await _load(venueId);
  }

  Future<void> pullRefresh() async {
    final venueId = _currentVenueId;
    if (venueId == null) return;
    await _load(venueId);
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

  /// PATCH pay; on success removes [order] from active list and prepends to waiter history.
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
      _waiterPaidHistory.removeWhere((o) => o.orderId == order.orderId);
      _waiterPaidHistory.insert(0, order);
      _error = null;
      notifyListeners();
      return true;
    } catch (e) {
      _markPaidError =
          e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      notifyListeners();
      return false;
    }
  }
}

