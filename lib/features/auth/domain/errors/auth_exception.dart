/// Domain exception for auth failures (invalid credentials, server error, etc.).
/// Thrown by data layer; caught in presentation.
class AuthException implements Exception {
  AuthException(this.message);
  final String message;
  @override
  String toString() => message;
}
