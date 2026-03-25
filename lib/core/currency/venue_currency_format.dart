import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import 'package:gastrobotmanager/core/currency/format_currency_amount.dart';
import 'package:gastrobotmanager/core/currency/supported_currencies.dart';

/// Backend ISO 4217 (e.g. `RSD`) → [CurrencyOption.symbol] when listed in
/// [kSupportedCurrencies]; otherwise the trimmed backend string unchanged.
String venueCurrencyDisplayLabel(String? backendCode) {
  final t = backendCode?.trim();
  if (t == null || t.isEmpty) return '';
  return currencyByCode(t)?.symbol ?? t;
}

/// No FX conversion. If [backendCode] matches a row in [kSupportedCurrencies],
/// uses that option’s locale + symbol via ICU; else `decimalPattern` + space + raw code.
String formatVenueAmount(
  double amount,
  String? backendCode, {
  required String localeString,
}) {
  final t = backendCode?.trim();
  if (t == null || t.isEmpty) {
    return NumberFormat.decimalPattern(localeString).format(amount);
  }
  final opt = currencyByCode(t);
  if (opt != null) {
    return formatAmountAsCurrency(amount, opt);
  }
  final numStr = NumberFormat.decimalPattern(localeString).format(amount);
  return '$numStr $t';
}

String formatVenueAmountForDisplay(
  BuildContext context,
  double amount,
  String? backendCode,
) {
  final locale = Localizations.localeOf(context).toString();
  return formatVenueAmount(amount, backendCode, localeString: locale);
}

String formatVenueIntForDisplay(
  BuildContext context,
  int amount,
  String? backendCode,
) {
  return formatVenueAmountForDisplay(context, amount.toDouble(), backendCode);
}
