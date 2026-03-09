import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/features/preparing/domain/models/queue_order.dart';
import 'package:gastrobotmanager/features/ready_items/domain/repositories/ready_items_api.dart';

/// Interval for refreshing ready items (waiter). Change to adjust refresh rate.
const Duration readyItemsRefreshInterval = Duration(seconds: 30);

/// Holds ready-to-serve orders for waiter and refreshes periodically.
class ReadyItemsProvider extends ChangeNotifier {
  ReadyItemsProvider(this._api);

  final ReadyItemsApi _api;

  List<QueueOrder> _orders = [];
  bool _isLoading = false;
  String? _error;
  String? _currentVenueId;

  List<QueueOrder> get orders => List.unmodifiable(_orders);
  bool get isLoading => _isLoading;
  String? get error => _error;

  static int _orderByTargetTime(QueueOrder a, QueueOrder b) {
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
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final list = await _api.getReadyItems(venueId);
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

  /// Marks the order's items as served. On success removes the order from the list.
  /// Returns [true] on success, [false] on failure (error stored in [error]).
  Future<bool> markOrderAsServed(QueueOrder order) async {
    final itemIds = order.items.map((e) => e.id).toList();
    return markItemIdsAsServed(itemIds);
  }

  /// Marks given order item IDs as served, then refreshes the list.
  /// Returns [true] on success, [false] on failure (error stored in [error]).
  Future<bool> markItemIdsAsServed(List<String> itemIds) async {
    final venueId = _currentVenueId;
    if (venueId == null || itemIds.isEmpty) return false;

    try {
      final success = await _api.markAsServed(venueId, itemIds);
      if (success && venueId == _currentVenueId) {
        _error = null;
        await _load(venueId);
      }
      return success;
    } catch (e) {
      _error = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      notifyListeners();
      return false;
    }
  }

}
