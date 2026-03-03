import 'package:flutter/foundation.dart';

import '../../../core/models/profile_type.dart';
import '../../../core/models/user.dart';
import '../services/auth_service.dart';

/// Auth provider. Holds current user (fetched on login).
/// User type from backend determines app flow.
class AuthProvider extends ChangeNotifier {
  User? _user;

  User? get user => _user;

  ProfileType? get profileType => _user?.type;

  bool get isLoggedIn => _user != null;

  Future<void> login(String username, String password) async {
    final user = await AuthService.instance.login(username, password);
    _user = user;
    notifyListeners();
  }

  void logout() {
    _user = null;
    notifyListeners();
  }
}
