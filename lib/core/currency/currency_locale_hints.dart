/// Suggested **first** display currency (format + symbol) when the user has not chosen one yet.
/// Keys are [Locale.languageCode] values only — independent of [kSupportedCurrencies].
/// Add a row when you add an app language; add a currency in [supported_currencies.dart] separately.
const Map<String, String> kDefaultCurrencyIdByLanguageCode = {
  'sr': 'rsd',
  'hr': 'eur',
  'de': 'eur',
  'en': 'eur',
  'it': 'eur',
  'fr': 'eur',
  'es': 'eur',
  'ru': 'rub',
  'hi': 'inr',
  'ne': 'npr',
};

String? defaultCurrencyIdForLanguage(String languageCode) {
  return kDefaultCurrencyIdByLanguageCode[languageCode];
}
