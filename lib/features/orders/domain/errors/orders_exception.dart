/// Thrown when pending orders API fails (kitchen, bar, etc.).
class OrdersException implements Exception {
  OrdersException(this.message);

  final String message;

  @override
  String toString() => message;
}
