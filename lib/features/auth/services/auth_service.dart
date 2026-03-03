import '../../../core/models/user.dart';

/// Dummy auth service. Simulates fetching user data from backend.
/// In production, replace with real API call.
class AuthService {
  AuthService._();

  static final AuthService instance = AuthService._();

  /// Simulates login: validates credentials, fetches user data.
  /// User type (waiter, kitchen, bar) comes from the API response.
  /// For dummy: use username "waiter", "kitchen", or "bar" to test each flow.
  Future<User> login(String username, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));

    // Dummy: simulate API response with user data including type
    final response = _dummyUserResponse(username);
    return User.fromJson(response);
  }

  Map<String, dynamic> _dummyUserResponse(String username) {
    final lower = username.toLowerCase();
    final type = lower.contains('kitchen')
        ? 'kitchen'
        : lower.contains('bar')
            ? 'bar'
            : 'waiter';
    return {
      'id': '1',
      'name': username,
      'type': type,
    };
  }
}
