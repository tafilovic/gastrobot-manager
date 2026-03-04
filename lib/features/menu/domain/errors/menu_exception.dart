/// Domain exception for menu loading/update failures.
class MenuException implements Exception {
  const MenuException(this.message);

  final String message;

  @override
  String toString() => 'MenuException: $message';
}
