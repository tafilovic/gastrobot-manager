/// Domain exception for preparing/queue failures.
class PreparingException implements Exception {
  const PreparingException(this.message);

  final String message;

  @override
  String toString() => 'PreparingException: $message';
}
