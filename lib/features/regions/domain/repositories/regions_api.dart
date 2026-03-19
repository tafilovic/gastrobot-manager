import 'package:gastrobotmanager/features/regions/domain/models/region_model.dart';

/// Contract for fetching venue regions (each region includes its tables).
abstract class RegionsApi {
  /// GET /regions — returns all regions visible to the current user.
  /// The caller is responsible for filtering by [venueId].
  Future<List<RegionModel>> getRegions(String venueId);
}
