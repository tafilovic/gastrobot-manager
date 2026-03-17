/// Thrown when tables API call fails.
class TablesException implements Exception {
  const TablesException(this.message);

  final String message;

  @override
  String toString() => message;
}
