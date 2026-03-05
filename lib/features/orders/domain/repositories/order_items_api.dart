/// Contract for accepting/rejecting order items (kitchen flow).
abstract class OrderItemsApi {
  /// Accepts a single order item.
  /// PATCH /venues/{venueId}/orders/{orderId}/order-items/{itemId}/accept
  /// [estimatedPrepTimeMinutes] optional; when set, sent in body for "confirm time" flow.
  Future<void> acceptOrderItem(
    String venueId,
    String orderId,
    String itemId, {
    int? estimatedPrepTimeMinutes,
  });

  /// Rejects a single order item.
  /// PATCH /venues/{venueId}/orders/{orderId}/order-items/{itemId}/reject
  /// [rejectionReason] is optional; body is prepared for future use, not sent for now.
  Future<void> rejectOrderItem(
    String venueId,
    String orderId,
    String itemId, {
    String? rejectionReason,
  });
}
