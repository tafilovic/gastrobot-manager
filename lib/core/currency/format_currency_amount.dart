import 'package:intl/intl.dart';

import 'package:gastrobotmanager/core/currency/currency_option.dart';

/// Formats [amount] with no conversion.
/// Uses [CurrencyOption.formatLocale] for grouping/decimals and prefix vs suffix;
/// [CurrencyOption.symbol] is passed to ICU as the displayed currency glyph.
/// Ensures a normal space between the symbol and the number when ICU omits it.
String formatAmountAsCurrency(double amount, CurrencyOption currency) {
  final nf = NumberFormat.currency(
    locale: currency.formatLocale,
    name: currency.code,
    symbol: currency.symbol,
  );
  return _withSpaceBetweenSymbolAndNumber(
    nf.format(amount),
    currency.symbol,
  );
}

String _withSpaceBetweenSymbolAndNumber(String formatted, String symbol) {
  if (symbol.isEmpty) return formatted;
  final esc = RegExp.escape(symbol);
  // Prefix: symbol immediately followed by a digit → symbol + space
  var s = formatted.replaceAllMapped(
    RegExp('($esc)([0-9])'),
    (m) => '${m[1]} ${m[2]}',
  );
  // Suffix: digit immediately followed by symbol → space before symbol
  s = s.replaceAllMapped(
    RegExp('([0-9])($esc)'),
    (m) => '${m[1]} ${m[2]}',
  );
  return s;
}
