class BotResponsePayload {
  const BotResponsePayload({
    required this.type,
    this.body = const {},
    this.message,
    this.userId,
  });

  final String type;
  final Map<String, dynamic> body;
  final String? message;
  final String? userId;

  static BotResponsePayload? fromDynamic(dynamic data) {
    if (data is! Map) return null;
    final map = Map<String, dynamic>.from(data);
    final type = map['type']?.toString();
    if (type == null || type.isEmpty) return null;

    Map<String, dynamic> body = const {};
    final rawBody = map['body'];
    if (rawBody is Map) {
      body = Map<String, dynamic>.from(rawBody);
    }

    return BotResponsePayload(
      type: type,
      body: body,
      message: map['message']?.toString(),
      userId: map['userId']?.toString(),
    );
  }
}
