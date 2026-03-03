import 'profile_type.dart';

/// User model with type from backend.
class User {
  const User({
    required this.id,
    required this.name,
    required this.type,
  });

  final String id;
  final String name;
  final ProfileType type;

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      type: _parseType(json['type'] as String),
    );
  }

  static ProfileType _parseType(String value) {
    switch (value.toLowerCase()) {
      case 'waiter':
        return ProfileType.waiter;
      case 'kitchen':
        return ProfileType.kitchen;
      case 'bar':
        return ProfileType.bar;
      default:
        return ProfileType.waiter;
    }
  }
}
