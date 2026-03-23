import 'package:intl/intl.dart';

import 'package:gastrobotmanager/core/currency/currency_option.dart';

/// Formats [amount] with no conversion.
/// Uses [CurrencyOption.formatLocale] for grouping/decimals and prefix vs suffix;
/// [CurrencyOption.symbol] is passed to ICU as the displayed currency glyph.
String formatAmountAsCurrency(double amount, CurrencyOption currency) {
  final nf = NumberFormat.currency(
    locale: currency.formatLocale,
    name: currency.code,
    symbol: currency.symbol,
  );
  return nf.format(amount);
}
