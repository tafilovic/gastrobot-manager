import '../../../core/api/api_config.dart';

/// Resolves full URL for profile image. Use in presentation when displaying.
/// Relative paths are prepended with [ApiConfig.baseUrl].
String? resolveProfileImageUrl(String? url) {
  if (url == null || url.isEmpty) return null;
  if (url.startsWith('http://') || url.startsWith('https://')) return url;
  return ApiConfig.baseUrl + (url.startsWith('/') ? url : '/$url');
}
