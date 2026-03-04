/// Domain exception for auth failures (invalid credentials, server error, unsupported role, etc.).
/// Thrown by data layer; caught in presentation.
class AuthException implements Exception {
  AuthException(this.message);

  /// Message value when the user's role is not supported (chef, waiter, bartender only).
  /// UI should show localized [AppLocalizations.loginRoleNotSupported] instead.
  static const String funsupportedRoleMessage = 'UNSUPPORTED_ROLE';

  final String message;
  @override
  String toString() => message;
}
