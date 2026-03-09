import 'package:flutter/foundation.dart';

import '../../auth/providers/auth_provider.dart';
import '../domain/models/pending_order.dart';
import '../domain/repositories/pending_orders_api.dart';

/// Interval for refreshing pending orders. Change this to adjust refresh rate.
const Duration ordersRefreshInterval = Duration(seconds: 30);

/// Holds pending orders for the current role (kitchen or bar) and refreshes periodically.
/// Uses [PendingOrdersApi] and [AuthProvider.profileType] to load the correct endpoint.
class OrdersProvider extends ChangeNotifier {
  OrdersProvider(this._authProvider, this._api);

  final AuthProvider _authProvider;
  final PendingOrdersApi _api;

  List<PendingOrder> _orders = [];
  bool _isLoading = false;
  String? _error;
  String? _currentVenueId;

  List<PendingOrder> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String? get error => _error;

  static int _orderByTargetTime(PendingOrder a, PendingOrder b) {
    return a.targetTime.compareTo(b.targetTime);
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

}
