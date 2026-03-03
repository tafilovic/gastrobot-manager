/// User profile types that determine app navigation and available features.
enum ProfileType {
  kitchen,
  bar,
  waiter,
}

extension ProfileTypeExtension on ProfileType {
  String get displayName {
    switch (this) {
      case ProfileType.kitchen:
        return 'Kitchen';
      case ProfileType.bar:
        return 'Bar';
      case ProfileType.waiter:
        return 'Waiter';
    }
  }
}
