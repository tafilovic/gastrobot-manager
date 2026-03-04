/// Thrown when kitchen orders API fails.
class KitchenOrdersException implements Exception {
  KitchenOrdersException(this.message);
  final String message;
  @override
  String toString() => message;
}
