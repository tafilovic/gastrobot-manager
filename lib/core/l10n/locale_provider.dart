import 'package:flutter/material.dart';
import 'package:sealed_countries/sealed_countries.dart';
import 'package:shared_preferences/shared_preferences.dart';

const _keyLocale = 'app_locale';

/// Supported app locales with display info.
class SupportedLocale {
  const SupportedLocale({
    required this.locale,
    required this.country,
    required this.name,
  });

  final Locale locale;
  final WorldCountry country;
  final String name;
}

/// App-supported locales for the language picker.
const supportedLocales = [
  SupportedLocale(locale: Locale('de'), country: CountryDeu(), name: 'Deutsch'),
  SupportedLocale(locale: Locale('en'), country: CountryGbr(), name: 'English'),
  SupportedLocale(locale: Locale('sr'), country: CountrySrb(), name: 'Srpski'),
  SupportedLocale(locale: Locale('it'), country: CountryIta(), name: 'Italiano'),
  SupportedLocale(locale: Locale('ru'), country: CountryRus(), name: 'Русский'),
  SupportedLocale(locale: Locale('es'), country: CountryEsp(), name: 'Español'),
  SupportedLocale(locale: Locale('hr'), country: CountryHrv(), name: 'Hrvatski'),
  SupportedLocale(locale: Locale('fr'), country: CountryFra(), name: 'Français'),
  SupportedLocale(locale: Locale('hi'), country: CountryInd(), name: 'हिन्दी'),
  SupportedLocale(locale: Locale('ne'), country: CountryNpl(), name: 'नेपाली'),
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
