import 'dart:io';

import 'package:flutter/foundation.dart';

import '../../../core/models/user.dart';
import '../../auth/providers/auth_provider.dart';
import '../domain/errors/profile_exception.dart';
import '../domain/repositories/profile_api.dart';

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
  void logout() => _authProvider.logout();

  @override
  void dispose() {
    _authProvider.removeListener(_onAuthChanged);
    super.dispose();
  }

  /// Uploads new profile image and updates the current user's profileImageUrl on success.
  /// Throws [ProfileException] on API failure.
  Future<void> updateProfileImage(File imageFile) async {
    final token = _authProvider.accessToken;
    if (token == null || token.isEmpty) {
      throw ProfileException('Not logged in');
    }
    final newUrl = await _profileApi.updateProfileImage(imageFile, token);
    if (newUrl != null) {
      _authProvider.updateProfileImageUrl(newUrl);
    }
  }

  /// Clears the profile image in local state (e.g. after user chose to remove it).
  /// Does not call backend; use when backend has no delete endpoint or after upload of removal.
  void clearProfileImage() {
    _authProvider.updateProfileImageUrl(null);
  }
}
