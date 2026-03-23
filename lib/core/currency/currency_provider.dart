import 'package:flutter/widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gastrobotmanager/core/currency/currency_locale_hints.dart';
import 'package:gastrobotmanager/core/currency/currency_option.dart';
import 'package:gastrobotmanager/core/currency/format_currency_amount.dart';
import 'package:gastrobotmanager/core/currency/supported_currencies.dart';
import 'package:gastrobotmanager/core/l10n/locale_provider.dart';

const _keyCurrencyId = 'app_display_currency_id';

/// Persists display currency label/format; amounts from the API are shown **unchanged**.
class CurrencyProvider extends ChangeNotifier {
  CurrencyProvider(this._prefs, LocaleProvider localeProvider) {
    _selected = _resolveInitial(localeProvider);
  }

  final SharedPreferences _prefs;
  late CurrencyOption _selected;

  CurrencyOption get selected => _selected;

  /// Whole-number amounts from the API (e.g. menu unit prices).
  String formatInt(int amount) =>
      formatAmountAsCurrency(amount.toDouble(), _selected);

  String formatAmount(double amount) =>
      formatAmountAsCurrency(amount, _selected);

  CurrencyOption _resolveInitial(LocaleProvider localeProvider) {
    final saved = _prefs.getString(_keyCurrencyId);
    if (saved != null) {
      final c = currencyById(saved);
      if (c != null) return c;
    }
    final lang = localeProvider.locale?.languageCode ??
        WidgetsBinding.instance.platformDispatcher.locale.languageCode;
    final hinted = defaultCurrencyIdForLanguage(lang);
    final fromHint = hinted != null ? currencyById(hinted) : null;
    return fromHint ?? kSupportedCurrencies.first;
  }

  Future<void> setCurrency(CurrencyOption currency) async {
    _selected = currency;
    await _prefs.setString(_keyCurrencyId, currency.id);
    notifyListeners();
  }
}
