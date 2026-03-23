/// Compares venue table ids from different API payloads (trim + case-insensitive UUID-style).
bool sameVenueTableId(String a, String b) {
  final x = a.trim();
  final y = b.trim();
  if (x.isEmpty || y.isEmpty) return false;
  if (x == y) return true;
  return x.toLowerCase() == y.toLowerCase();
}
