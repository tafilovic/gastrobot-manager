/// Domain exception for ready-items (waiter) failures.
class ReadyItemsException implements Exception {
  const ReadyItemsException(this.message);

  final String message;

  @override
  String toString() => 'ReadyItemsException: $message';
}
