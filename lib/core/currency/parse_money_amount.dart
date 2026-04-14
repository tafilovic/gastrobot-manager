import 'package:decimal/decimal.dart';

/// Parses menu/order price fields into a major-unit [Decimal] (e.g. `199.99`).
///
/// Avoids parsing via [double] first so string values stay exact.
Decimal parseMoneyAmount(dynamic raw) {
  if (raw == null) return Decimal.zero;
  if (raw is Decimal) return raw;
  if (raw is int) return Decimal.fromInt(raw);
  if (raw is BigInt) return Decimal.parse(raw.toString());
  if (raw is num) {
    return Decimal.parse(raw.toString());
  }
  final s = raw.toString().trim();
  if (s.isEmpty) return Decimal.zero;
  return Decimal.tryParse(s) ?? Decimal.zero;
}
