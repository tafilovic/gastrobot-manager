import 'package:gastrobotmanager/core/currency/currency_option.dart';

/// Maps backend `venue.currency` (ISO 4217) to display symbol and ICU formatting.
/// Add a row when you need a custom symbol or locale for a code from the API.
const List<CurrencyOption> kSupportedCurrencies = [
  CurrencyOption(
    id: 'rsd',
    code: 'RSD',
    displayName: 'Serbian dinar (RSD)',
    formatLocale: 'sr_RS',
    symbol: 'RSD',
  ),
  CurrencyOption(
    id: 'eur',
    code: 'EUR',
    displayName: 'Euro (€)',
    formatLocale: 'de_DE',
    symbol: '€',
  ),
  CurrencyOption(
    id: 'usd',
    code: 'USD',
    displayName: 'US dollar (USD)',
    formatLocale: 'en_US',
    symbol: r'$',
  ),
  CurrencyOption(
    id: 'gbp',
    code: 'GBP',
    displayName: 'Pound sterling (GBP)',
    formatLocale: 'en_GB',
    symbol: '£',
  ),
  CurrencyOption(
    id: 'chf',
    code: 'CHF',
    displayName: 'Swiss franc (CHF)',
    formatLocale: 'de_CH',
    symbol: 'Fr',
  ),
  CurrencyOption(
    id: 'rub',
    code: 'RUB',
    displayName: 'Russian ruble (RUB)',
    formatLocale: 'ru_RU',
    symbol: '₽',
  ),
  CurrencyOption(
    id: 'inr',
    code: 'INR',
    displayName: 'Indian rupee (INR)',
    formatLocale: 'en_IN',
    symbol: '₹',
  ),
  CurrencyOption(
    id: 'npr',
    code: 'NPR',
    displayName: 'Nepalese rupee (NPR)',
    formatLocale: 'ne_NP',
    symbol: 'रू',
  ),
];

/// ISO 4217 from API (e.g. `venue.currency`: `"RSD"`).
CurrencyOption? currencyByCode(String? code) {
  if (code == null || code.isEmpty) return null;
  final upper = code.toUpperCase();
  for (final c in kSupportedCurrencies) {
    if (c.code == upper) return c;
  }
  final lower = code.toLowerCase();
  for (final c in kSupportedCurrencies) {
    if (c.id == lower) return c;
  }
  return null;
}
