/// Order model for display in orders list.
class Order {
  const Order({
    required this.id,
    required this.tableNumber,
    required this.dishCount,
    required this.timeAgo,
  });

  final String id;
  final int tableNumber;
  final int dishCount;
  final String timeAgo;
}
