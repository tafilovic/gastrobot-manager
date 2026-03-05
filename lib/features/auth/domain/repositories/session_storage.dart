import 'package:gastrobotmanager/features/auth/models/auth_session.dart';

/// Contract for persisting and restoring auth session and remembered email.
/// Implementations live in the data layer (e.g. SharedPreferences).
abstract class SessionStorage {
  Future<void> saveSession(AuthSession session);
  Future<AuthSession?> getSession();
  Future<void> clearAll();
  Future<void> saveRememberedEmail(String? email);
  Future<String?> getRememberedEmail();
}
