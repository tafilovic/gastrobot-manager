import 'dart:async';

import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/venue_settings/domain/models/venue_settings.dart';
import 'package:gastrobotmanager/features/venue_settings/domain/repositories/venue_settings_api.dart';

class VenueSettingsProvider extends ChangeNotifier {
  VenueSettingsProvider(this._authProvider, this._api) {
    _authProvider.addListener(_handleAuthChanged);
    unawaited(refresh());
  }

  final AuthProvider _authProvider;
  final VenueSettingsApi _api;

  VenueSettings _settings =
      const VenueSettings(waiterActsAsBartender: false);
  bool _isLoading = false;
  String? _error;
  String? _loadedVenueId;

  VenueSettings get settings => _settings;
  bool get isLoading => _isLoading;
  String? get error => _error;

  bool get canWaiterActAsBartender =>
      _authProvider.profileType == ProfileType.waiter &&
      _settings.waiterActsAsBartender;

  Future<void> refresh() async {
    final venueId = _authProvider.currentVenueId;
    if (!_authProvider.isLoggedIn || venueId == null || venueId.isEmpty) {
      _loadedVenueId = null;
      _settings = const VenueSettings(waiterActsAsBartender: false);
      _error = null;
      notifyListeners();
      return;
    }

    _loadedVenueId = venueId;
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _settings = await _api.getVenueSettings(venueId);
      _error = null;
    } catch (e) {
      _settings = const VenueSettings(waiterActsAsBartender: false);
      _error = e.toString().replaceFirst(RegExp(r'^Exception: '), '');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void _handleAuthChanged() {
    final venueId = _authProvider.currentVenueId;
    if (!_authProvider.isLoggedIn || venueId != _loadedVenueId) {
      unawaited(refresh());
    }
  }

  @override
  void dispose() {
    _authProvider.removeListener(_handleAuthChanged);
    super.dispose();
  }
}
