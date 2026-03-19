class RegionsException implements Exception {
  RegionsException(this.message);

  final String message;

  @override
  String toString() => 'RegionsException: $message';
}
