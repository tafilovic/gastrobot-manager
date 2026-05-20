/// Normalizes reservation number for API search (trim, strip leading `#`).
String? trimReservationNumber(String? raw) {
  final value = raw?.trim();
  if (value == null || value.isEmpty) return null;
  return value.startsWith('#') ? value.substring(1).trim() : value;
}
