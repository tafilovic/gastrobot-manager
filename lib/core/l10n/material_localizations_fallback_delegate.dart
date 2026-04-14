import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

/// Loads [MaterialLocalizations] for [locale], or English when Flutter has no
/// Material translations for that language (e.g. Maltese `mt`).
class MaterialLocalizationsFallbackDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const MaterialLocalizationsFallbackDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    final effective = kMaterialSupportedLanguages.contains(locale.languageCode)
        ? locale
        : const Locale('en');
    return GlobalMaterialLocalizations.delegate.load(effective);
  }

  @override
  bool shouldReload(MaterialLocalizationsFallbackDelegate old) => false;
}
