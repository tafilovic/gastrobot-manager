import 'package:gastrobotmanager/features/zones/domain/models/zone_model.dart';

/// Matches API [ZoneModel.type]: `room`, `sunbed`, or default `table`.
enum ZoneDisplayCategory {
  room,
  sunbed,
  table,
}

ZoneDisplayCategory zoneDisplayCategory(ZoneModel t) {
  switch (t.type) {
    case 'room':
      return ZoneDisplayCategory.room;
    case 'sunbed':
      return ZoneDisplayCategory.sunbed;
    default:
      return ZoneDisplayCategory.table;
  }
}

void _sortZonesByName(List<ZoneModel> list) {
  list.sort((a, b) {
    final na = int.tryParse(a.name);
    final nb = int.tryParse(b.name);
    if (na != null && nb != null) return na.compareTo(nb);
    return a.name.compareTo(b.name);
  });
}

/// Non-empty groups only, in order: room, sunbed, table.
List<({ZoneDisplayCategory category, List<ZoneModel> zones})>
groupZonesByDisplayCategory(Iterable<ZoneModel> zones) {
  final room = <ZoneModel>[];
  final sunbed = <ZoneModel>[];
  final tableZones = <ZoneModel>[];

  for (final zone in zones) {
    switch (zoneDisplayCategory(zone)) {
      case ZoneDisplayCategory.room:
        room.add(zone);
      case ZoneDisplayCategory.sunbed:
        sunbed.add(zone);
      case ZoneDisplayCategory.table:
        tableZones.add(zone);
    }
  }

  _sortZonesByName(room);
  _sortZonesByName(sunbed);
  _sortZonesByName(tableZones);

  return [
    if (room.isNotEmpty) (category: ZoneDisplayCategory.room, zones: room),
    if (sunbed.isNotEmpty)
      (category: ZoneDisplayCategory.sunbed, zones: sunbed),
    if (tableZones.isNotEmpty)
      (category: ZoneDisplayCategory.table, zones: tableZones),
  ];
}
