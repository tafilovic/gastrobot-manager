import 'package:gastrobotmanager/features/auth/domain/errors/auth_exception.dart';
import 'package:gastrobotmanager/features/auth/domain/repositories/auth_api.dart';
import 'package:gastrobotmanager/features/auth/domain/repositories/session_storage.dart';
import 'package:gastrobotmanager/features/auth/models/auth_session.dart';
import 'package:gastrobotmanager/features/auth/models/register_request.dart';
import 'package:gastrobotmanager/features/auth/models/sign_in_request.dart';
import 'package:gastrobotmanager/features/auth/utils/supported_roles.dart';

/// Auth use case: sign-in and session persistence.
/// Depends only on domain abstractions ([SessionStorage], [AuthApi]).
class AuthService {
  AuthService(this._sessionStorage, this._authApi);

  final SessionStorage _sessionStorage;
  final AuthApi _authApi;

  /// Public sign-up; does not create a session.
  Future<void> register(RegisterRequest request) => _authApi.register(request);

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

  /// Persist updated tokens after a background token refresh.
  Future<void> updateSession(AuthSession session) async {
    await _sessionStorage.saveSession(session);
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
