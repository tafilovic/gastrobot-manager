/// Waiter-only actions on a single order (pay, etc.).
abstract class WaiterOrderActionsApi {
  /// PATCH …/venues/:venueId/waiter/orders/:orderId/pay
  Future<void> markOrderAsPaid(String venueId, String orderId);
}
