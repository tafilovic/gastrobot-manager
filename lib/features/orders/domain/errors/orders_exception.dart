/// Thrown when pending orders API fails (kitchen, bar, etc.).
class OrdersException implements Exception {
  OrdersException(this.message, {this.statusCode});

  final String message;
  final int? statusCode;

  @override
  String toString() => message;
}
