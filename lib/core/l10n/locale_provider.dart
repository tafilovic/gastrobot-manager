import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

const _keyLocale = 'app_locale';

/// Supported app locales with display info.
class SupportedLocale {
  const SupportedLocale({
    required this.locale,
    required this.flag,
    required this.name,
  });

  final Locale locale;
  final String flag;
  final String name;
}

/// App-supported locales for the language picker.
const supportedLocales = [
  SupportedLocale(locale: Locale('de'), flag: '🇩🇪', name: 'Deutsch'),
  SupportedLocale(locale: Locale('en'), flag: '🇬🇧', name: 'English'),
  SupportedLocale(locale: Locale('sr'), flag: '🇷🇸', name: 'Srpski'),
];

/// Holds the selected app locale. Persists to SharedPreferences.
class LocaleProvider extends ChangeNotifier {
  LocaleProvider(this._prefs) {
    _load();
  }

  final SharedPreferences _prefs;

  Locale? _locale;

  /// Current locale. Null = use system default.
  Locale? get locale => _locale;

  /// Display name for current locale.
  String get currentLocaleName {
    if (_locale == null) {
      return _systemLocaleName;
    }
    return supportedLocales
        .firstWhere(
          (s) => s.locale.languageCode == _locale!.languageCode,
          orElse: () => supportedLocales.first,
        )
        .name;
  }

  String get _systemLocaleName {
    final system = WidgetsBinding.instance.platformDispatcher.locale;
    return supportedLocales
        .firstWhere(
          (s) => s.locale.languageCode == system.languageCode,
          orElse: () => supportedLocales.first,
        )
        .name;
  }

  void _load() {
    final code = _prefs.getString(_keyLocale);
    if (code != null && code.isNotEmpty) {
      _locale = Locale(code);
    }
    notifyListeners();
  }

  /// Sets the app locale and persists it.
  Future<void> setLocale(Locale? locale) async {
    _locale = locale;
    if (locale != null) {
      await _prefs.setString(_keyLocale, locale.languageCode);
    } else {
      await _prefs.remove(_keyLocale);
    }
    notifyListeners();
  }
}
