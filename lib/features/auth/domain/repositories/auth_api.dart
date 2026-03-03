import '../../models/auth_session.dart';
import '../../models/sign_in_request.dart';

/// Contract for auth API (e.g. sign-in). Implementations live in the data layer.
abstract class AuthApi {
  Future<AuthSession> signIn(SignInRequest request);
}
