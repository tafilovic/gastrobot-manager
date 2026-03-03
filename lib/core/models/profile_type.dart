import '../../l10n/generated/app_localizations.dart';

/// User profile types that determine app navigation and available features.
enum ProfileType {
  kitchen,
  bar,
  waiter,
}

extension ProfileTypeExtension on ProfileType {
  /// Default English display name (e.g. for logs). Use [displayNameLocalized] for UI.
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

  /// Returns localized display name for UI.
  String displayNameLocalized(AppLocalizations l10n) {
    switch (this) {
      case ProfileType.kitchen:
        return l10n.profileTypeKitchen;
      case ProfileType.bar:
        return l10n.profileTypeBar;
      case ProfileType.waiter:
        return l10n.profileTypeWaiter;
    }
  }
}
