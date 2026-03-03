import '../data/auth_remote.dart';
import '../data/session_storage.dart';
import '../models/auth_session.dart';
import '../models/sign_in_request.dart';

/// Auth service: sign-in via API and session persistence.
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  final AuthRemote _remote = AuthRemote();

  /// Sign in with email and password. Returns session (user + tokens).
  Future<AuthSession> signIn(SignInRequest request) async {
    final session = await _remote.signIn(request);
    await SessionStorage.saveSession(session);
    return session;
  }

  /// Restore session from storage (e.g. on app start).
  Future<AuthSession?> restoreSession() async {
    return SessionStorage.getSession();
  }

  /// Clear session and all stored user data (on logout).
  Future<void> signOut() async {
    await SessionStorage.clearAll();
  }
}
