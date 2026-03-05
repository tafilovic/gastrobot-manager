import 'package:flutter/material.dart';
import 'package:gastrobotmanager/features/auth/domain/repositories/session_storage.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'app.dart';
import 'features/auth/data/auth_remote.dart';
import 'features/auth/data/shared_preferences_session_storage.dart';
import 'features/auth/domain/repositories/auth_api.dart';
import 'features/auth/providers/auth_provider.dart';
import 'features/auth/services/auth_service.dart';
import 'features/orders/data/kitchen_pending_remote.dart';
import 'features/orders/data/order_items_remote.dart';
import 'features/orders/domain/repositories/kitchen_pending_api.dart';
import 'features/orders/domain/repositories/order_items_api.dart';
import 'features/orders/providers/kitchen_orders_provider.dart';
import 'features/menu/data/venue_menus_remote.dart';
import 'features/menu/domain/repositories/menus_api.dart';
import 'features/menu/providers/menu_provider.dart';
import 'features/preparing/data/kitchen_queue_remote.dart';
import 'features/preparing/domain/repositories/kitchen_queue_api.dart';
import 'features/preparing/providers/kitchen_queue_provider.dart';
import 'features/profile/data/profile_remote.dart';
import 'features/profile/domain/repositories/profile_api.dart';
import 'features/profile/providers/profile_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Defer SharedPreferences until after first frame so native splash doesn't hang
  runApp(const _AppLoader());
}

class _AppLoader extends StatelessWidget {
  const _AppLoader();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<SharedPreferences>(
      future: SharedPreferences.getInstance(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const MaterialApp(
            home: Scaffold(
              body: Center(child: CircularProgressIndicator()),
            ),
          );
        }
        final prefs = snapshot.data!;
        return MultiProvider(
          providers: [
            Provider<SessionStorage>(
              create: (_) => SharedPreferencesSessionStorage(prefs),
            ),
            Provider<AuthApi>(
              create: (_) => AuthRemote(),
            ),
            Provider<ProfileApi>(
              create: (_) => ProfileRemote(),
            ),
            Provider<AuthService>(
              create: (c) => AuthService(c.read<SessionStorage>(), c.read<AuthApi>()),
            ),
            ChangeNotifierProvider<AuthProvider>(
              create: (c) => AuthProvider(c.read<AuthService>()),
            ),
            ChangeNotifierProvider<ProfileProvider>(
              create: (c) => ProfileProvider(c.read<AuthProvider>(), c.read<ProfileApi>()),
            ),
            Provider<KitchenPendingApi>(
              create: (_) => KitchenPendingRemote(),
            ),
            Provider<OrderItemsApi>(
              create: (_) => OrderItemsRemote(),
            ),
            ChangeNotifierProvider<KitchenOrdersProvider>(
              create: (c) => KitchenOrdersProvider(c.read<AuthProvider>(), c.read<KitchenPendingApi>()),
            ),
            Provider<MenusApi>(
              create: (_) => VenueMenusRemote(),
            ),
            ChangeNotifierProvider<MenuProvider>(
              create: (c) => MenuProvider(c.read<AuthProvider>(), c.read<MenusApi>()),
            ),
            Provider<KitchenQueueApi>(
              create: (_) => KitchenQueueRemote(),
            ),
            ChangeNotifierProvider<KitchenQueueProvider>(
              create: (c) => KitchenQueueProvider(c.read<AuthProvider>(), c.read<KitchenQueueApi>()),
            ),
          ],
          child: const GastroBotApp(),
        );
      },
    );
  }
}
