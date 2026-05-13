/// Domain exception for preparing/queue failures.
class PreparingException implements Exception {
  const PreparingException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => 'PreparingException: $message';
}
