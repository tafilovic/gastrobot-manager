import 'package:gastrobotmanager/features/auth/models/auth_session.dart';
import 'package:gastrobotmanager/features/auth/models/register_request.dart';
import 'package:gastrobotmanager/features/auth/models/sign_in_request.dart';

/// Contract for auth API (e.g. sign-in). Implementations live in the data layer.
abstract class AuthApi {
  Future<AuthSession> signIn(SignInRequest request);

  /// Creates a new user account. Expects HTTP 201 on success.
  Future<void> register(RegisterRequest request);
}
