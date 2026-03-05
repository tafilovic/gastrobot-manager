import 'package:dio/dio.dart';
import 'package:gastrobotmanager/features/menu/domain/errors/menu_exception.dart';
import 'package:gastrobotmanager/features/menu/domain/models/venue_menu.dart';
import 'package:gastrobotmanager/features/menu/domain/repositories/menus_api.dart';

import 'package:gastrobotmanager/core/api/api_config.dart';

/// Fetches venue menus via GET /v1/venues/{venueId}/menus?type=food|drinks.
class VenueMenusRemote implements MenusApi {
  VenueMenusRemote([Dio? dio])
      : _dio = dio ?? Dio(BaseOptions(baseUrl: ApiConfig.baseUrl));

  final Dio _dio;

  @override
  Future<List<VenueMenu>> getMenus(String venueId, String menuType) async {
    try {
      final response = await _dio.get<List<dynamic>>(
        '/v1/venues/$venueId/menus',
        queryParameters: {'type': menuType},
        options: Options(
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      if (response.data == null) {
        throw const MenuException('Invalid response');
      }

      if (response.statusCode != 200) {
        final msg = (response.data is Map)
            ? (response.data as Map)['message']?.toString()
            : null;
        throw MenuException(msg ?? 'Failed to load menu');
      }

      return (response.data!)
          .map((e) => VenueMenu.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw MenuException(message ?? e.message ?? 'Network error');
    }
  }

  @override
  Future<bool> toggleMenuItemAvailability(
    String venueId,
    String menuId,
    String menuItemId,
  ) async {
    try {
      final response = await _dio.patch<Map<String, dynamic>>(
        '/venues/$venueId/menus/$menuId/menu-items/$menuItemId/toggle-availability',
        data: {'isProtected': false},
        options: Options(
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      if (response.data == null) {
        throw const MenuException('Invalid response');
      }

      if (response.statusCode != 200) {
        final msg =
            (response.data!['message'] ?? response.data!['error'])?.toString();
        throw MenuException(msg ?? 'Failed to update availability');
      }

      final isAvailable = response.data!['isAvailable'] as bool?;
      return isAvailable ?? true;
    } on DioException catch (e) {
      final message = e.response?.data is Map
          ? (e.response!.data as Map)['message']?.toString()
          : null;
      throw MenuException(message ?? e.message ?? 'Network error');
    }
  }
}
