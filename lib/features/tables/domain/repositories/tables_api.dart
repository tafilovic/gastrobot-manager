import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';

/// Contract for fetching venue tables.
abstract class TablesApi {
  Future<List<TableModel>> getTables(String venueId);
}
