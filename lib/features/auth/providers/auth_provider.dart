import 'package:flutter/foundation.dart';

import '../../../core/models/profile_type.dart';
import '../../../core/models/user.dart';
import '../data/session_storage.dart';
import '../models/auth_session.dart';
import '../models/sign_in_request.dart';
import '../services/auth_service.dart';

/// Auth state: current user, tokens, and session persistence.
/// [profileType] (from user.role) drives app flow. Tokens available for API calls.
class AuthProvider extends ChangeNotifier {
  AuthProvider() {
    _restoreSession();
  }

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

  Future<void> _restoreSession() async {
    final session = await AuthService.instance.restoreSession();
    if (session != null) {
      _user = session.user;
      _accessToken = session.accessToken;
      _refreshToken = session.refreshToken;
    }
    _isRestoring = false;
    notifyListeners();
  }

  Future<void> login(String email, String password, {bool rememberEmail = false}) async {
    final session = await AuthService.instance.signIn(
      SignInRequest(email: email.trim(), password: password),
    );
    _user = session.user;
    _accessToken = session.accessToken;
    _refreshToken = session.refreshToken;
    if (rememberEmail) {
      await SessionStorage.saveRememberedEmail(email.trim());
    } else {
      await SessionStorage.saveRememberedEmail(null);
    }
    notifyListeners();
  }

  Future<void> logout() async {
    await AuthService.instance.signOut();
    _user = null;
    _accessToken = null;
    _refreshToken = null;
    notifyListeners();
  }

  /// Pre-fill email from "remember me". Call once when showing login.
  Future<String?> getRememberedEmail() => SessionStorage.getRememberedEmail();
}
