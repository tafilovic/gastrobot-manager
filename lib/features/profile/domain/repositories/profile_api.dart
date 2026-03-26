import 'dart:io';

import 'package:gastrobotmanager/core/models/user.dart';

/// Contract for profile-related API (e.g. get current user, update profile image).
/// Implementations live in the data layer.
abstract class ProfileApi {
  /// Fetches the current user (GET /v1/users/me). Uses Bearer token. Returns null on failure.
  Future<User?> getMe();

  /// Uploads profile image. Returns the new profile image URL on success.
  Future<String?> updateProfileImage(File imageFile);

  /// Deletes the current user (DELETE /v1/users/me). Success when response is 2xx.
  /// Throws [ProfileException] on failure.
  Future<void> deleteAccount();
}
