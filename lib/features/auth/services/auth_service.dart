import '../domain/errors/auth_exception.dart';
import '../domain/repositories/auth_api.dart';
import '../domain/repositories/session_storage.dart';
import '../models/auth_session.dart';
import '../models/sign_in_request.dart';
import '../utils/supported_roles.dart';

/// Auth use case: sign-in and session persistence.
/// Depends only on domain abstractions ([SessionStorage], [AuthApi]).
class AuthService {
  AuthService(this._sessionStorage, this._authApi);

  final SessionStorage _sessionStorage;
  final AuthApi _authApi;

  /// Sign in with email and password. Returns session (user + tokens).
  /// Throws [AuthException] with message [AuthException.unsupportedRoleMessage] if user role is not supported.
  Future<AuthSession> signIn(SignInRequest request) async {
    final session = await _authApi.signIn(request);
    if (!isSupportedRole(session.user.role)) {
      throw AuthException(AuthException.funsupportedRoleMessage);
    }
    await _sessionStorage.saveSession(session);
    return session;
  }

  /// Restore session from storage (e.g. on app start).
  Future<AuthSession?> restoreSession() async {
    return _sessionStorage.getSession();
  }

  /// Clear session and all stored user data (on logout).
  Future<void> signOut() async {
    await _sessionStorage.clearAll();
  }

  /// Pre-fill email from "remember me".
  Future<String?> getRememberedEmail() async {
    return _sessionStorage.getRememberedEmail();
  }

  /// Persist or clear remembered email (call after login with rememberEmail flag).
  Future<void> setRememberedEmail(String? email) async {
    await _sessionStorage.saveRememberedEmail(email);
  }
}
