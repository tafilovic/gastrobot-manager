import 'package:flutter/foundation.dart';
import 'package:gastrobotmanager/core/api/token_store.dart';
import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/models/user.dart';
import 'package:gastrobotmanager/features/auth/models/auth_session.dart';
import 'package:gastrobotmanager/features/auth/models/sign_in_request.dart';
import 'package:gastrobotmanager/features/auth/services/auth_service.dart';
import 'package:gastrobotmanager/features/auth/utils/supported_roles.dart';

/// Auth state: current user, tokens, and session persistence.
/// [profileType] (from user.role) drives app flow.
/// Writes tokens into [TokenStore] so [AuthInterceptor] always has fresh values.
class AuthProvider extends ChangeNotifier {
  AuthProvider(this._authService, this._tokenStore) {
    _restoreSession();
  }

  final AuthService _authService;
  final TokenStore _tokenStore;

  User? _user;
  String? _accessToken;
  String? _refreshToken;
  bool _isRestoring = true;

  User? get user => _user;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;

  /// Role-based type for navigation and features.
  ProfileType? get profileType => _user?.type;

  bool get isLoggedIn => _user != null;
  bool get isRestoring => _isRestoring;

  void _syncTokenStore() {
    _tokenStore.accessToken = _accessToken;
    _tokenStore.refreshToken = _refreshToken;
  }

  Future<void> _restoreSession() async {
    try {
      var session = await _authService.restoreSession();
      if (session != null && !isSupportedRole(session.user.role)) {
        await _authService.signOut();
        session = null;
      }
      if (session != null) {
        _user = session.user;
        _accessToken = session.accessToken;
        _refreshToken = session.refreshToken;
        _syncTokenStore();
      }
    } catch (_) {
      // On any error, treat as logged out so user can retry
    } finally {
      _isRestoring = false;
      notifyListeners();
    }
  }

  Future<void> login(
    String email,
    String password, {
    bool rememberEmail = false,
  }) async {
    final session = await _authService.signIn(
      SignInRequest(email: email.trim(), password: password),
    );
    _user = session.user;
    _accessToken = session.accessToken;
    _refreshToken = session.refreshToken;
    _syncTokenStore();
    await _authService.setRememberedEmail(rememberEmail ? email.trim() : null);
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    _tokenStore.clear();
    notifyListeners();
  }

  /// Called by [AuthInterceptor] after a successful background token refresh.
  /// Updates in-memory state, syncs [TokenStore], and persists the new session.
  Future<void> updateTokens(String accessToken, String refreshToken) async {
    _accessToken = accessToken;
    _refreshToken = refreshToken;
    _syncTokenStore();
    if (_user != null) {
      await _authService.updateSession(
        AuthSession(
          user: _user!,
          accessToken: accessToken,
          refreshToken: refreshToken,
        ),
      );
    }
    notifyListeners();
  }

  /// Pre-fill email from "remember me". Call once when showing login.
  Future<String?> getRememberedEmail() => _authService.getRememberedEmail();

  /// Update the current user's profile image URL (e.g. after upload).
  void updateProfileImageUrl(String? newUrl) {
    if (_user == null) return;
    _user = _user!.copyWith(profileImageUrl: newUrl);
    notifyListeners();
  }

  /// Replace the current user (e.g. after fetching fresh profile from API).
  /// Persists the updated session so it survives app restart.
  Future<void> updateUser(User user) async {
    _user = user;
    if (_accessToken != null && _refreshToken != null) {
      await _authService.updateSession(
        AuthSession(
          user: user,
          accessToken: _accessToken!,
          refreshToken: _refreshToken!,
        ),
      );
    }
    notifyListeners();
  }
}
