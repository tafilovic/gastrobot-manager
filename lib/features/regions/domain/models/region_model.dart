/// A table embedded inside a [RegionModel] from GET /regions.
///
/// Unlike [TableModel] (from /venues/:id/tables), this does not include
/// real-time status or next-reservation data.
class RegionTableModel {
  const RegionTableModel({
    required this.id,
    required this.name,
    required this.type,
    required this.capacity,
    required this.venueId,
    required this.regionId,
    this.code,
  });

  final String id;

  /// Table number label, e.g. "1", "31".
  final String name;

  /// "table" | "room" | "sunbed"
  final String type;

  final int capacity;
  final String venueId;
  final String regionId;
  final String? code;

  factory RegionTableModel.fromJson(Map<String, dynamic> json) {
    return RegionTableModel(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String? ?? 'table',
      capacity: (json['capacity'] as num?)?.toInt() ?? 0,
      venueId: json['venueId'] as String,
      regionId: json['regionId'] as String,
      code: json['code'] as String?,
    );
  }
}

/// A venue region from GET /regions.
/// Each region has a human-readable [title], an [area] tag and its [tables].
class RegionModel {
  const RegionModel({
    required this.id,
    required this.title,
    required this.venueId,
    required this.area,
    required this.tables,
  });

  final String id;

  /// Display name, e.g. "stolovi od 1-10 levo".
  final String title;

  final String venueId;

  /// "inside" | "outside"
  final String area;

  final List<RegionTableModel> tables;

  factory RegionModel.fromJson(Map<String, dynamic> json) {
    final rawTables = json['tables'];
    final tables = rawTables is List
        ? rawTables
            .whereType<Map<String, dynamic>>()
            .map(RegionTableModel.fromJson)
            .toList()
        : <RegionTableModel>[];

    return RegionModel(
      id: json['id'] as String,
      title: json['title'] as String,
      venueId: json['venueId'] as String,
      area: json['area'] as String? ?? 'inside',
      tables: tables,
    );
  }
}
