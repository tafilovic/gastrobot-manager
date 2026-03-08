import 'dart:convert';

import 'package:gastrobotmanager/features/auth/domain/repositories/session_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gastrobotmanager/features/auth/models/auth_session.dart';

/// [SessionStorage] implementation using [SharedPreferences].
class SharedPreferencesSessionStorage implements SessionStorage {
  SharedPreferencesSessionStorage(this._prefs);

  final SharedPreferences _prefs;

  static const _keySession = 'auth_session';
  static const _keyRememberedEmail = 'auth_remembered_email';
  static const _keyVenueId = 'auth_venue_id';

  @override
  Future<void> saveSession(AuthSession session) async {
    await _prefs.setString(_keySession, jsonEncode(session.toJson()));
  }

  @override
  Future<AuthSession?> getSession() async {
    final raw = _prefs.getString(_keySession);
    if (raw == null) return null;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      return AuthSession.fromJson(map);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> clearAll() async {
    await _prefs.remove(_keySession);
    await _prefs.remove(_keyRememberedEmail);
    await _prefs.remove(_keyVenueId);
  }

  @override
  Future<void> saveRememberedEmail(String? email) async {
    if (email == null || email.isEmpty) {
      await _prefs.remove(_keyRememberedEmail);
    } else {
      await _prefs.setString(_keyRememberedEmail, email);
    }
  }

  @override
  Future<String?> getRememberedEmail() async {
    return _prefs.getString(_keyRememberedEmail);
  }

  @override
  Future<void> saveVenueId(String? venueId) async {
    if (venueId == null || venueId.isEmpty) {
      await _prefs.remove(_keyVenueId);
    } else {
      await _prefs.setString(_keyVenueId, venueId);
    }
  }

  @override
  Future<String?> getVenueId() async {
    return _prefs.getString(_keyVenueId);
  }
}
