import 'package:gastrobotmanager/core/currency/currency_option.dart';

/// All currencies the user can pick. Add entries here to extend.
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

CurrencyOption? currencyById(String id) {
  for (final c in kSupportedCurrencies) {
    if (c.id == id) return c;
  }
  return null;
}
