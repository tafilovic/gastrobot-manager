/// Thrown when tables API call fails.
class ZonesException implements Exception {
  const ZonesException(this.message);

  final String message;

  @override
  String toString() => message;
}
