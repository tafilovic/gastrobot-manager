import 'dart:convert';

class NotificationPayload {
  const NotificationPayload({
    required this.titleKey,
    required this.body,
    this.type,
    this.entityId,
  });

  final String titleKey;
  final Map<String, dynamic> body;
  final String? type;
  final String? entityId;

  String? get messageKey {
    final value = body['messageKey'];
    return value is String && value.isNotEmpty ? value : null;
  }

  Map<String, String> get routePayload => {
    if (type != null && type!.isNotEmpty) 'type': type!,
    if (entityId != null && entityId!.isNotEmpty) 'entityId': entityId!,
    if (body['type'] != null && body['type'].toString().isNotEmpty)
      'subtype': body['type'].toString(),
  };

  String encodeRoutePayload() => jsonEncode(routePayload);

  static NotificationPayload? fromRemoteData(Map<String, dynamic> data) {
    final title = data['title']?.toString();
    if (title == null || title.isEmpty) return null;

    return NotificationPayload(
      titleKey: title,
      body: _parseBody(data['body']),
      type: data['type']?.toString(),
      entityId: data['entityId']?.toString(),
    );
  }

  static NotificationPayload? fromLocalPayload(String? payload) {
    if (payload == null || payload.isEmpty) return null;
    try {
      final data = jsonDecode(payload);
      if (data is! Map<String, dynamic>) return null;
      return NotificationPayload.fromRemoteData(data);
    } catch (_) {
      return null;
    }
  }

  Map<String, dynamic> toJson() => {
    'title': titleKey,
    'body': body,
    if (type != null) 'type': type,
    if (entityId != null) 'entityId': entityId,
  };

  String toLocalPayload() => jsonEncode(toJson());

  static Map<String, dynamic> _parseBody(Object? value) {
    if (value == null) return const {};
    if (value is Map<String, dynamic>) return value;
    if (value is Map) return Map<String, dynamic>.from(value);
    if (value is String && value.isNotEmpty) {
      try {
        final decoded = jsonDecode(value);
        if (decoded is Map<String, dynamic>) return decoded;
        if (decoded is Map) return Map<String, dynamic>.from(decoded);
      } catch (_) {
        return {'message': value};
      }
    }
    return const {};
  }
}
