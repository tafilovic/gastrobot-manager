import 'package:flutter_test/flutter_test.dart';
import 'package:gastrobotmanager/core/models/user.dart';
import 'package:gastrobotmanager/features/auth/domain/repositories/auth_api.dart';
import 'package:gastrobotmanager/features/auth/domain/repositories/session_storage.dart';
import 'package:gastrobotmanager/features/auth/models/auth_session.dart';
import 'package:gastrobotmanager/features/auth/models/register_request.dart';
import 'package:gastrobotmanager/features/auth/models/sign_in_request.dart';
import 'package:gastrobotmanager/features/auth/services/auth_service.dart';
import 'package:mocktail/mocktail.dart';

class MockSessionStorage extends Mock implements SessionStorage {}

class MockAuthApi extends Mock implements AuthApi {}

void main() {
  late MockSessionStorage storage;
  late MockAuthApi authApi;
  late AuthService service;

  setUpAll(() {
    registerFallbackValue(const SignInRequest(email: '', password: ''));
    registerFallbackValue(
      const RegisterRequest(
        firstname: '',
        lastname: '',
        email: '',
        password: '',
      ),
    );
    registerFallbackValue(AuthSession(
      user: const User(id: '', firstname: '', lastname: '', email: '', role: 'waiter'),
      accessToken: '',
      refreshToken: '',
    ));
  });

  setUp(() {
    storage = MockSessionStorage();
    authApi = MockAuthApi();
    service = AuthService(storage, authApi);
  });

  group('AuthService', () {
    final session = AuthSession(
      user: const User(
        id: '1',
        firstname: 'Test',
        lastname: 'User',
        email: 'test@example.com',
        role: 'waiter',
      ),
      accessToken: 'access',
      refreshToken: 'refresh',
    );

    test('signIn saves session to storage after authApi returns', () async {
      when(() => authApi.signIn(any())).thenAnswer((_) async => session);
      when(() => storage.saveSession(any())).thenAnswer((_) async {});

      await service.signIn(const SignInRequest(email: 'a@b.com', password: 'p'));

      verify(() => authApi.signIn(any())).called(1);
      verify(() => storage.saveSession(session)).called(1);
    });

    test('restoreSession returns session from storage', () async {
      when(() => storage.getSession()).thenAnswer((_) async => session);

      final result = await service.restoreSession();

      expect(result, session);
      verify(() => storage.getSession()).called(1);
    });

    test('restoreSession returns null when storage has no session', () async {
      when(() => storage.getSession()).thenAnswer((_) async => null);

      final result = await service.restoreSession();

      expect(result, isNull);
    });

    test('signOut calls storage clearAll', () async {
      when(() => storage.clearAll()).thenAnswer((_) async {});

      await service.signOut();

      verify(() => storage.clearAll()).called(1);
    });

    test('setRememberedEmail delegates to storage', () async {
      when(() => storage.saveRememberedEmail(any())).thenAnswer((_) async {});

      await service.setRememberedEmail('a@b.com');

      verify(() => storage.saveRememberedEmail('a@b.com')).called(1);
    });

    test('getRememberedEmail returns value from storage', () async {
      when(() => storage.getRememberedEmail()).thenAnswer((_) async => 'a@b.com');

      final result = await service.getRememberedEmail();

      expect(result, 'a@b.com');
    });

    test('register delegates to authApi only', () async {
      when(() => authApi.register(any())).thenAnswer((_) async {});

      await service.register(
        const RegisterRequest(
          firstname: 'A',
          lastname: 'B',
          email: 'a@b.com',
          password: 'secret',
        ),
      );

      verify(() => authApi.register(any())).called(1);
      verifyNever(() => storage.saveSession(any()));
    });
  });
}
