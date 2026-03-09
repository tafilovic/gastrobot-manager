import 'dart:async';

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

  // --- Dependencies ---
  final AuthService _authService;
  final TokenStore _tokenStore;

  // --- State ---
  User? _user;
  String? _accessToken;
  String? _refreshToken;
  String? _storedVenueId;
  bool _isRestoring = true;

  // --- Getters ---
  User? get user => _user;
  String? get accessToken => _accessToken;
  String? get refreshToken => _refreshToken;
  ProfileType? get profileType => _user?.type;
  String? get currentVenueId =>
      _user?.venueUsers.isNotEmpty == true
          ? _user!.venueUsers.first.venueId
          : _storedVenueId;
  bool get isLoggedIn => _user != null;
  bool get isRestoring => _isRestoring;

  /// Completes when session restore has finished. Use for app bootstrap.
  Future<void> get whenRestoreComplete => _restoreCompleter.future;
  final Completer<void> _restoreCompleter = Completer<void>();

  // --- Session restore ---
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
      _storedVenueId = await _authService.getVenueId();
    } catch (_) {
      // On any error, treat as logged out so user can retry
    } finally {
      _isRestoring = false;
      if (!_restoreCompleter.isCompleted) {
        _restoreCompleter.complete();
      }
      notifyListeners();
    }
  }

  void _syncTokenStore() {
    _tokenStore.accessToken = _accessToken;
    _tokenStore.refreshToken = _refreshToken;
  }

  // --- Auth lifecycle ---
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
    if (session.user.venueUsers.isNotEmpty) {
      final venueId = session.user.venueUsers.first.venueId;
      _storedVenueId = venueId;
      await _authService.saveVenueId(venueId);
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await _authService.signOut();
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    _storedVenueId = null;
    _tokenStore.clear();
    notifyListeners();
  }

  // --- Token refresh (called by AuthInterceptor) ---
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

  // --- User state ---
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
    if (user.venueUsers.isNotEmpty) {
      final venueId = user.venueUsers.first.venueId;
      _storedVenueId = venueId;
      await _authService.saveVenueId(venueId);
    }
    notifyListeners();
  }

  void updateProfileImageUrl(String? newUrl) {
    if (_user == null) return;
    _user = _user!.copyWith(profileImageUrl: newUrl);
    notifyListeners();
  }

  // --- Misc ---
  Future<String?> getRememberedEmail() => _authService.getRememberedEmail();
}
