import 'dart:convert';

import 'package:gastrobotmanager/core/log/app_logger.dart';
import 'package:gastrobotmanager/features/auth/domain/repositories/session_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:gastrobotmanager/features/auth/models/auth_session.dart';

/// [SessionStorage] implementation using [SharedPreferences].
class SharedPreferencesSessionStorage implements SessionStorage {
  SharedPreferencesSessionStorage(this._prefs);

  final SharedPreferences _prefs;

  static const keySession = 'auth_session';
  static const keyRememberedEmail = 'auth_remembered_email';

  @override
  Future<void> saveSession(AuthSession session) async {
    debugLog(
      'Saving auth session for user=${session.user.id}, role=${session.user.role}',
    );
    await _prefs.setString(keySession, jsonEncode(session.toJson()));
  }

  @override
  Future<AuthSession?> getSession() async {
    final raw = _prefs.getString(keySession);
    if (raw == null) {
      debugLog('No saved auth session found');
      return null;
    }
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      final session = AuthSession.fromJson(map);
      debugLog(
        'Restored auth session for user=${session.user.id}, role=${session.user.role}',
      );
      return session;
    } catch (e) {
      debugLog('Failed to restore saved auth session: $e');
      return null;
    }
  }

  @override
  Future<void> clearAll() async {
    debugLog('Clearing saved auth session');
    await _prefs.remove(keySession);
    await _prefs.remove(keyRememberedEmail);
  }

  @override
  Future<void> saveRememberedEmail(String? email) async {
    if (email == null || email.isEmpty) {
      await _prefs.remove(keyRememberedEmail);
    } else {
      await _prefs.setString(keyRememberedEmail, email);
    }
  }

  @override
  Future<String?> getRememberedEmail() async {
    return _prefs.getString(keyRememberedEmail);
  }
}
