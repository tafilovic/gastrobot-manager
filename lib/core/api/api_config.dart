import 'package:flutter/foundation.dart';

/// API base URL for auth and other endpoints.
///
/// When [ENV] is not set via --dart-define: debug builds use dev, release builds use prod.
/// Override with --dart-define=ENV=dev or --dart-define=ENV=prod to force an environment.
class ApiConfig {
  ApiConfig._();

  static const String _env = String.fromEnvironment('ENV', defaultValue: '');

  static const String _baseUrlDev = 'https://devapi.gastro-bot.eu';
  static const String _baseUrlProd =
      'https://api.gastro-bot.eu'; //'https://apirestobot.brrm.eu';

  /// Optional `Authorization: Bearer …` for POST `/v1/users/register`.
  /// Build: `--dart-define=REGISTER_BEARER=your_token`
  static const String registerBearer = String.fromEnvironment(
    'REGISTER_BEARER',
    defaultValue: '',
  );

  static String get baseUrl {
    if (_env == 'prod') return _baseUrlProd;
    if (_env == 'dev') return _baseUrlDev;
    return kDebugMode ? _baseUrlDev : _baseUrlProd;
  }
}
