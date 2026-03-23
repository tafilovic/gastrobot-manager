/// POST /v1/venues/:venueId/orders body.
class CreateVenueOrderRequest {
  const CreateVenueOrderRequest({
    required this.tableId,
    required this.userId,
    required this.orderItems,
  });

  final String tableId;
  final String userId;
  final List<CreateVenueOrderLine> orderItems;

  Map<String, dynamic> toJson() => {
    'tableId': tableId,
    'userId': userId,
    'orderItems': orderItems.map((e) => e.toJson()).toList(),
  };
}

class CreateVenueOrderLine {
  const CreateVenueOrderLine({
    required this.menuItemId,
    required this.quantity,
    this.additionalInfo = '',
  });

  final String menuItemId;
  final int quantity;
  final String additionalInfo;

  Map<String, dynamic> toJson() => {
    'menuItemId': menuItemId,
    'quantity': quantity,
    'additionalInfo': additionalInfo,
  };
}
