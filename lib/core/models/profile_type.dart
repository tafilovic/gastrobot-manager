/// User profile types that determine app navigation and available features.
/// Domain concept; no UI/localization dependency.
enum ProfileType {
  kitchen,
  bar,
  waiter,
}

extension ProfileTypeExtension on ProfileType {
  /// Default display name (e.g. for logs). For UI, use presentation layer to resolve localized label.
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
