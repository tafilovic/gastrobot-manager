import 'dart:io';

import 'package:gastrobotmanager/core/models/user.dart';

/// Contract for profile-related API (e.g. get current user, update profile image).
/// Implementations live in the data layer.
abstract class ProfileApi {
  /// Fetches the user by id (GET /v1/users/{userId}). Returns null on failure.
  Future<User?> getCurrentUser(String userId);

  /// Uploads profile image. Returns the new profile image URL on success.
  Future<String?> updateProfileImage(File imageFile);
}
