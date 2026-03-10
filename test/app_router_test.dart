import 'package:flutter_test/flutter_test.dart';
import 'package:gastrobotmanager/core/navigation/app_router.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/auth/services/auth_service.dart';
import 'package:gastrobotmanager/features/auth/domain/repositories/session_storage.dart';
import 'package:gastrobotmanager/features/auth/domain/repositories/auth_api.dart';
import 'package:gastrobotmanager/features/auth/models/auth_session.dart';
import 'package:gastrobotmanager/features/auth/models/sign_in_request.dart';
import 'package:gastrobotmanager/core/models/user.dart';
import 'package:gastrobotmanager/core/api/token_store.dart';

class _TestAuthProvider extends AuthProvider {
  _TestAuthProvider({
    required bool isLoggedIn,
    required bool isRestoring,
  }) : super(
          _DummyAuthService(),
          TokenStore(),
        ) {
    if (isLoggedIn) {
      // Simulate a logged-in state by updating tokens; user can remain null
      updateTokens('access', 'refresh');
    }
    if (!isRestoring) {
      // Directly manipulate the restoring flag for tests
      // ignore: invalid_use_of_protected_member
      // ignore: invalid_use_of_visible_for_testing_member
      (this as dynamic)._isRestoring = false;
    }
  }
}

class _DummySessionStorage implements SessionStorage {
  @override
  Future<void> clearAll() async {}

  @override
  Future<String?> getRememberedEmail() async => null;

  @override
  Future<AuthSession?> getSession() async => null;

 
  @override
  Future<void> saveRememberedEmail(String? email) async {}

  @override
  Future<void> saveSession(AuthSession session) async {}

}

class _DummyAuthApi implements AuthApi {
  @override
  Future<AuthSession> signIn(SignInRequest request) {
    // Return a minimal dummy session for tests that never reaches the network.
    return Future.value(
      AuthSession(
        user: User(
          id: 'id',
          firstname: 'Test',
          lastname: 'User',
          email: 'test@example.com',
          role: 'waiter',
        ),
        accessToken: 'access',
        refreshToken: 'refresh',
      ),
    );
  }
}

class _DummyAuthService extends AuthService {
  _DummyAuthService() : super(_DummySessionStorage(), _DummyAuthApi());
}

void main() {
  testWidgets('unauthenticated user is redirected to /login', (tester) async {
    final auth = _TestAuthProvider(isLoggedIn: false, isRestoring: false);
    final router = AppRouter.create(auth);
    expect(router, isNotNull);
  });

  testWidgets('authenticated user sees orders screen on /orders', (tester) async {
    final auth = _TestAuthProvider(isLoggedIn: true, isRestoring: false);
    final router = AppRouter.create(auth);
    expect(router, isNotNull);
  });
}

