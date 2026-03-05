import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';

/// Contract for fetching pending orders per role (kitchen, bar, etc.).
/// Caller sorts by [PendingOrder.targetTime] ascending for oldest-first.
abstract class PendingOrdersApi {
  Future<List<PendingOrder>> getPendingOrders(
    String venueId,
    ProfileType profileType,
  );
}
