import 'package:gastrobotmanager/features/auth/models/auth_session.dart';
import 'package:gastrobotmanager/features/auth/models/sign_in_request.dart';

/// Contract for auth API (e.g. sign-in). Implementations live in the data layer.
abstract class AuthApi {
  Future<AuthSession> signIn(SignInRequest request);
}
