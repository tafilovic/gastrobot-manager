/// Display currency: amounts are **not** converted; [formatLocale] drives [NumberFormat.currency] (symbol position, separators).
class CurrencyOption {
  const CurrencyOption({
    required this.id,
    required this.code,
    required this.displayName,
    required this.formatLocale,
    required this.symbol,
  });

  /// Stable id for persistence (e.g. `eur`).
  final String id;

  /// ISO 4217 code passed to [NumberFormat.currency].
  final String code;

  /// Short label in the picker (English; not tied to app language).
  final String displayName;

  /// Glyph(s) used when formatting amounts (ICU prefix/suffix per [formatLocale]) and in the picker.
  final String symbol;

  /// ICU locale for formatting (grouping, decimal separator, symbol prefix/suffix).
  final String formatLocale;
}
