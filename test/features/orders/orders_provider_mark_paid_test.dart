import 'package:flutter_test/flutter_test.dart';
import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/orders/domain/repositories/pending_orders_api.dart';
import 'package:gastrobotmanager/features/orders/domain/repositories/waiter_order_actions_api.dart';
import 'package:gastrobotmanager/features/orders/domain/errors/orders_exception.dart';
import 'package:gastrobotmanager/features/orders/providers/orders_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

class MockPendingOrdersApi extends Mock implements PendingOrdersApi {}

class MockWaiterOrderActionsApi extends Mock implements WaiterOrderActionsApi {}

void main() {
  late MockAuthProvider auth;
  late MockPendingOrdersApi pendingApi;
  late MockWaiterOrderActionsApi payApi;
  late OrdersProvider provider;

  final order = PendingOrder(
    orderId: 'o1',
    orderNumber: 'A-12',
    tableNumber: '3',
    orderType: 'walk_in',
    targetTime: '2025-01-15T12:00:00.000Z',
    items: const [],
  );

  setUp(() {
    auth = MockAuthProvider();
    pendingApi = MockPendingOrdersApi();
    payApi = MockWaiterOrderActionsApi();
    provider = OrdersProvider(
      auth,
      pendingApi,
      waiterOrderActionsApi: payApi,
    );
    when(() => auth.profileType).thenReturn(ProfileType.waiter);
    when(() => pendingApi.getPendingOrders(any(), any()))
        .thenAnswer((_) async => [order]);
    when(() => payApi.getPaidOrders(any())).thenAnswer((_) async => []);
  });

  group('OrdersProvider.loadWaiterPaidOrders', () {
    test('stores paid orders from API', () async {
      final paid = PendingOrder(
        orderId: 'p1',
        orderNumber: 'Z-9',
        tableNumber: '1',
        orderType: 'walk_in',
        targetTime: '2025-02-01T10:00:00.000Z',
        items: const [],
      );
      when(() => payApi.getPaidOrders('venue-1'))
          .thenAnswer((_) async => [paid]);

      await provider.loadWaiterPaidOrders('venue-1');

      expect(provider.waiterHistoryOrders.length, 1);
      expect(provider.waiterHistoryOrders.first.orderId, 'p1');
      expect(provider.paidOrdersError, isNull);
    });
  });

  group('OrdersProvider.markWaiterOrderAsPaid', () {
    test('on success removes from orders and reloads paid list from API', () async {
      when(() => payApi.markOrderAsPaid('venue-1', 'o1'))
          .thenAnswer((_) async {});
      when(() => payApi.getPaidOrders('venue-1'))
          .thenAnswer((_) async => [order]);

      await provider.loadOnce('venue-1');
      expect(provider.orders.length, 1);

      final ok = await provider.markWaiterOrderAsPaid('venue-1', order);

      expect(ok, isTrue);
      expect(provider.orders, isEmpty);
      expect(provider.waiterHistoryOrders.length, 1);
      expect(provider.waiterHistoryOrders.first.orderId, 'o1');
      verify(() => payApi.markOrderAsPaid('venue-1', 'o1')).called(1);
      verify(() => payApi.getPaidOrders('venue-1')).called(1);
    });

    test('on failure keeps orders and sets markPaidError', () async {
      when(() => payApi.markOrderAsPaid('venue-1', 'o1'))
          .thenThrow(OrdersException('Payment failed'));

      await provider.loadOnce('venue-1');

      final ok = await provider.markWaiterOrderAsPaid('venue-1', order);

      expect(ok, isFalse);
      expect(provider.orders.length, 1);
      expect(provider.waiterHistoryOrders, isEmpty);
      expect(provider.markPaidError, 'Payment failed');
    });
  });
}
