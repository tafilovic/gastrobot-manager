import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/features/regions/domain/models/region_model.dart';
import 'package:gastrobotmanager/features/regions/domain/repositories/regions_api.dart';

/// Holds the list of venue regions (each with embedded tables).
/// Loads on demand and supports pull-to-refresh.
class RegionsProvider extends ChangeNotifier {
  RegionsProvider(this._api);

  final RegionsApi _api;

  List<RegionModel> _regions = [];
  bool _isLoading = false;
  String? _error;
  String? _currentVenueId;

  List<RegionModel> get regions => List.unmodifiable(_regions);
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> load(String venueId) async {
    _currentVenueId = venueId;
    await _fetch(venueId);
  }

  Future<void> pullRefresh() async {
    final venueId = _currentVenueId;
    if (venueId == null) return;
    await _fetch(venueId);
  }

  Future<void> _fetch(String venueId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _regions = await _api.getRegions(venueId);
      _error = null;
    } catch (e) {
      _error = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
      _regions = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
