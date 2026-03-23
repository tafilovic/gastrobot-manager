import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';

/// Matches API [TableModel.type]: `room`, `sunbed`, or default `table`.
enum TableDisplayCategory {
  room,
  sunbed,
  table,
}

TableDisplayCategory tableDisplayCategory(TableModel t) {
  switch (t.type) {
    case 'room':
      return TableDisplayCategory.room;
    case 'sunbed':
      return TableDisplayCategory.sunbed;
    default:
      return TableDisplayCategory.table;
  }
}

void _sortTablesByName(List<TableModel> list) {
  list.sort((a, b) {
    final na = int.tryParse(a.name);
    final nb = int.tryParse(b.name);
    if (na != null && nb != null) return na.compareTo(nb);
    return a.name.compareTo(b.name);
  });
}

/// Non-empty groups only, in order: room → sunbed → table.
List<({TableDisplayCategory category, List<TableModel> tables})>
groupTablesByDisplayCategory(Iterable<TableModel> tables) {
  final room = <TableModel>[];
  final sunbed = <TableModel>[];
  final table = <TableModel>[];

  for (final t in tables) {
    switch (tableDisplayCategory(t)) {
      case TableDisplayCategory.room:
        room.add(t);
      case TableDisplayCategory.sunbed:
        sunbed.add(t);
      case TableDisplayCategory.table:
        table.add(t);
    }
  }

  _sortTablesByName(room);
  _sortTablesByName(sunbed);
  _sortTablesByName(table);

  return [
    if (room.isNotEmpty) (category: TableDisplayCategory.room, tables: room),
    if (sunbed.isNotEmpty)
      (category: TableDisplayCategory.sunbed, tables: sunbed),
    if (table.isNotEmpty) (category: TableDisplayCategory.table, tables: table),
  ];
}
