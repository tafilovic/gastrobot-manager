import 'package:flutter_test/flutter_test.dart';
import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/domain/repositories/reservations_api.dart';
import 'package:gastrobotmanager/features/reservations/providers/reservations_provider.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthProvider extends Mock implements AuthProvider {}

class MockReservationsApi extends Mock implements ReservationsApi {}

void main() {
  late MockAuthProvider auth;
  late MockReservationsApi api;
  late ReservationsProvider provider;

  setUpAll(() {
    registerFallbackValue(ProfileType.waiter);
  });

  final order = PendingOrder(
    orderId: 'r1',
    orderNumber: 'RES-1',
    tableNumber: '5',
    orderType: 'reservation',
    targetTime: '2025-06-01T18:00:00.000Z',
    items: const [],
  );

  setUp(() {
    auth = MockAuthProvider();
    api = MockReservationsApi();
    provider = ReservationsProvider(auth, api);
    when(() => auth.profileType).thenReturn(ProfileType.waiter);
    when(() => api.getRequests(any(), any())).thenAnswer((_) async => [order]);
  });

  test('loadOnce for waiter loads via getRequests', () async {
    await provider.loadOnce('venue-x');

    expect(provider.requests.length, 1);
    expect(provider.requests.first.orderId, 'r1');
    verify(() => api.getRequests('venue-x', ProfileType.waiter)).called(1);
  });
}
