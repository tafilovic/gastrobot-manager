import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/models/venue_user.dart';

/// User model from auth API. [role] determines app flow (ProfileType).
class User {
  const User({
    required this.id,
    required this.firstname,
    required this.lastname,
    required this.email,
    required this.role,
    this.venueUsers = const [],
    this.profileImageUrl,
    this.phoneNumber,
    this.organizationId,
    this.isVerified,
    this.isSmsVerified,
    this.lastTableId,
    this.brandOwnerId,
  });

  final String id;
  final String firstname;
  final String lastname;
  final String email;

  /// Backend role: waiter, kitchen, bar, etc. Drives [type] and app flow.
  final String role;
  final List<VenueUser> venueUsers;
  final String? profileImageUrl;
  final String? phoneNumber;
  final String? organizationId;
  final bool? isVerified;
  final bool? isSmsVerified;
  final String? lastTableId;
  final String? brandOwnerId;

  /// Display name (firstname + lastname).
  String get name => '$firstname $lastname'.trim();

  /// Profile type for navigation; derived from [role].
  ProfileType get type => _roleToProfileType(role);

  factory User.fromJson(Map<String, dynamic> json) {
    final venueUsersList = json['venueUsers'] as List<dynamic>?;
    return User(
      id: json['id'] as String,
      firstname: json['firstname'] as String? ?? '',
      lastname: json['lastname'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? 'waiter',
      venueUsers: venueUsersList != null
          ? venueUsersList
                .map((e) => VenueUser.fromJson(e as Map<String, dynamic>))
                .toList()
          : const [],
      profileImageUrl: json['profileImageUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      organizationId: json['organizationId'] as String?,
      isVerified: json['isVerified'] as bool?,
      isSmsVerified: json['isSmsVerified'] as bool?,
      lastTableId: json['lastTableId'] as String?,
      brandOwnerId: json['brandOwnerId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'firstname': firstname,
    'lastname': lastname,
    'email': email,
    'role': role,
    'venueUsers': venueUsers.map((e) => e.toJson()).toList(),
    'profileImageUrl': profileImageUrl,
    'phoneNumber': phoneNumber,
    'organizationId': organizationId,
    'isVerified': isVerified,
    'isSmsVerified': isSmsVerified,
    'lastTableId': lastTableId,
    'brandOwnerId': brandOwnerId,
  };

  User copyWith({Object? profileImageUrl = _omit}) => User(
    id: id,
    firstname: firstname,
    lastname: lastname,
    email: email,
    role: role,
    venueUsers: venueUsers,
    profileImageUrl: profileImageUrl == _omit
        ? this.profileImageUrl
        : profileImageUrl as String?,
    phoneNumber: phoneNumber,
    organizationId: organizationId,
    isVerified: isVerified,
    isSmsVerified: isSmsVerified,
    lastTableId: lastTableId,
    brandOwnerId: brandOwnerId,
  );

  static const _omit = Object();

  static ProfileType _roleToProfileType(String value) {
    switch (value.toLowerCase()) {
      case 'waiter':
        return ProfileType.waiter;
      case 'chef':
      case 'kitchen':
        return ProfileType.kitchen;
      case 'bartender':
      case 'bar':
        return ProfileType.bar;
      default:
        return ProfileType.waiter;
    }
  }
}
