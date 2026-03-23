import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';
import 'package:gastrobotmanager/features/tables/utils/venue_table_id_match.dart';

/// Whether [order] matches a non-empty [selectedTableIds] set from the venue tables list.
///
/// 1. If [order.tableId] is set: match when it equals any selected id ([sameVenueTableId]).
/// 2. If not set: match only when **exactly one** selected [venueTables] row has
///    [TableModel.name] equal to [order.tableNumber] (disambiguates duplicate names
///    when the user selected a single table; excludes ambiguous multi-match cases).
bool orderMatchesSelectedTableIds(
  PendingOrder order,
  Set<String> selectedTableIds,
  List<TableModel> venueTables,
) {
  if (selectedTableIds.isEmpty) return true;

  final oid = order.tableId?.trim();
  if (oid != null && oid.isNotEmpty) {
    return selectedTableIds.any((id) => sameVenueTableId(id, oid));
  }

  if (venueTables.isEmpty) return false;

  final orderName = order.tableNumber.trim();
  final matches = venueTables.where((t) {
    final selected = selectedTableIds.any((id) => sameVenueTableId(id, t.id));
    return selected && t.name.trim() == orderName;
  }).length;

  return matches == 1;
}
