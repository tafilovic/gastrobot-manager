/// Shared in-memory token container used by [AuthProvider] and [AuthInterceptor].
///
/// [AuthProvider] writes to this store after login, restore, and token refresh.
/// [AuthInterceptor] reads from it to inject the Authorization header and writes
/// new tokens after a successful refresh.
class TokenStore {
  String? accessToken;
  String? refreshToken;

  void clear() {
    accessToken = null;
    refreshToken = null;
  }
}
