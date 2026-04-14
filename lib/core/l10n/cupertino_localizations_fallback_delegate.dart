import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Loads [CupertinoLocalizations] for [locale], or English when Flutter has no
/// Cupertino translations for that language (e.g. Maltese `mt`).
class CupertinoLocalizationsFallbackDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const CupertinoLocalizationsFallbackDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    final effective = kCupertinoSupportedLanguages.contains(locale.languageCode)
        ? locale
        : const Locale('en');
    return GlobalCupertinoLocalizations.delegate.load(effective);
  }

  @override
  bool shouldReload(CupertinoLocalizationsFallbackDelegate old) => false;
}
