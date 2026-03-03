/// Domain exception for profile operations (e.g. image upload failed).
class ProfileException implements Exception {
  ProfileException(this.message);
  final String message;
  @override
  String toString() => message;
}
