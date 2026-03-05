import 'dart:io';

/// Contract for profile-related API (e.g. update profile image).
/// Implementations live in the data layer.
abstract class ProfileApi {
  /// Uploads profile image. Returns the new profile image URL on success.
  Future<String?> updateProfileImage(File imageFile);
}
