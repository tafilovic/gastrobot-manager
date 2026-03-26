import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:gastrobotmanager/core/models/user.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/profile/domain/errors/profile_exception.dart';
import 'package:gastrobotmanager/features/profile/domain/repositories/profile_api.dart';

/// Profile use-case state: current user, update image, clear image, logout.
/// Delegates to [AuthProvider] and [ProfileApi]; notifies when auth state changes.
class ProfileProvider extends ChangeNotifier {
  ProfileProvider(this._authProvider, this._profileApi) {
    _authProvider.addListener(_onAuthChanged);
  }

  final AuthProvider _authProvider;
  final ProfileApi _profileApi;

  void _onAuthChanged() => notifyListeners();

  /// Current user from auth; null when not logged in.
  User? get user => _authProvider.user;

  /// Signs out and clears session.
  Future<void> logout() => _authProvider.logout();

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChanged);
    super.dispose();
  }

  /// Uploads new profile image and updates the current user's profileImageUrl on success.
  /// Throws [ProfileException] on API failure.
  Future<void> updateProfileImage(File imageFile) async {
    final newUrl = await _profileApi.updateProfileImage(imageFile);
    if (newUrl != null) {
      _authProvider.updateProfileImageUrl(newUrl);
    }
  }

  /// Clears the profile image in local state (e.g. after user chose to remove it).
  void clearProfileImage() {
    _authProvider.updateProfileImageUrl(null);
  }

  /// Fetches the current user from the API (GET /v1/users/me) and updates auth state.
  Future<void> refreshUser() async {
    if (!_authProvider.isLoggedIn) return;
    final user = await _profileApi.getMe();
    if (user != null) {
      await _authProvider.updateUser(user);
    }
  }
}
