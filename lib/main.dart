import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gastrobotmanager/app.dart';
import 'package:gastrobotmanager/core/api/api_config.dart';
import 'package:gastrobotmanager/core/api/auth_interceptor.dart';
import 'package:gastrobotmanager/core/api/token_store.dart';
import 'package:gastrobotmanager/core/l10n/locale_provider.dart';
import 'package:gastrobotmanager/features/auth/data/auth_remote.dart';
import 'package:gastrobotmanager/features/auth/data/shared_preferences_session_storage.dart';
import 'package:gastrobotmanager/features/auth/domain/repositories/session_storage.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/auth/services/auth_service.dart';
import 'package:gastrobotmanager/features/menu/data/venue_menus_remote.dart';
import 'package:gastrobotmanager/features/menu/domain/repositories/menus_api.dart';
import 'package:gastrobotmanager/features/menu/providers/menu_provider.dart';
import 'package:gastrobotmanager/features/orders/data/order_items_remote.dart';
import 'package:gastrobotmanager/features/orders/data/pending_orders_remote.dart';
import 'package:gastrobotmanager/features/orders/domain/repositories/order_items_api.dart';
import 'package:gastrobotmanager/features/orders/domain/repositories/pending_orders_api.dart';
import 'package:gastrobotmanager/features/orders/providers/orders_provider.dart';
import 'package:gastrobotmanager/features/preparing/data/queue_remote.dart';
import 'package:gastrobotmanager/features/preparing/domain/repositories/queue_api.dart';
import 'package:gastrobotmanager/features/preparing/providers/queue_provider.dart';
import 'package:gastrobotmanager/features/profile/data/profile_remote.dart';
import 'package:gastrobotmanager/features/profile/domain/repositories/profile_api.dart';
import 'package:gastrobotmanager/features/profile/providers/profile_provider.dart';
import 'package:gastrobotmanager/features/reservations/data/reservations_remote.dart';
import 'package:gastrobotmanager/features/reservations/domain/repositories/reservations_api.dart';
import 'package:gastrobotmanager/features/reservations/providers/reservations_provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const _AppLoader());
}

/// Waits for [SharedPreferences] then hands off to [_GastroBotProviders].
class _AppLoader extends StatefulWidget {
  const _AppLoader();

  @override
  State<_AppLoader> createState() => _AppLoaderState();
}

class _AppLoaderState extends State<_AppLoader> {
  SharedPreferences? _prefs;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      if (mounted) setState(() => _prefs = prefs);
    });
  }

  @override
  Widget build(BuildContext context) {
    final prefs = _prefs;
    if (prefs == null) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }
    return _GastroBotProviders(prefs: prefs);
  }
}

/// Creates all dependencies exactly once (in [initState]) and wires them into
/// a [MultiProvider] tree. The authenticated [Dio] instance is shared by all
/// Remote classes; the [AuthInterceptor] handles token injection and refresh
/// transparently, so no provider needs to deal with tokens directly.
class _GastroBotProviders extends StatefulWidget {
  const _GastroBotProviders({required this.prefs});

  final SharedPreferences prefs;

  @override
  State<_GastroBotProviders> createState() => _GastroBotProvidersState();
}

class _GastroBotProvidersState extends State<_GastroBotProviders> {
  late final TokenStore _tokenStore;
  late final AuthProvider _authProvider;
  late final Dio _authenticatedDio;

  @override
  void initState() {
    super.initState();

    _tokenStore = TokenStore();

    final sessionStorage = SharedPreferencesSessionStorage(widget.prefs);
    final authService = AuthService(sessionStorage, AuthRemote());
    _authProvider = AuthProvider(authService, _tokenStore);

    _authenticatedDio = Dio(BaseOptions(baseUrl: ApiConfig.baseUrl))
      ..interceptors.add(
        AuthInterceptor(
          tokenStore: _tokenStore,
          onTokensRefreshed: (a, r) => _authProvider.updateTokens(a, r),
          onLogout: () => _authProvider.logout(),
        ),
      );
  }

  @override
  void dispose() {
    _authProvider.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Auth
        Provider<SessionStorage>(
          create: (_) => SharedPreferencesSessionStorage(widget.prefs),
        ),
        ChangeNotifierProvider<AuthProvider>.value(value: _authProvider),

        // Locale
        ChangeNotifierProvider<LocaleProvider>(
          create: (_) => LocaleProvider(widget.prefs),
        ),

        // Profile
        Provider<ProfileApi>(
          create: (_) => ProfileRemote(_authenticatedDio),
        ),
        ChangeNotifierProvider<ProfileProvider>(
          create: (c) => ProfileProvider(
            c.read<AuthProvider>(),
            c.read<ProfileApi>(),
          ),
        ),

        // Orders
        Provider<PendingOrdersApi>(
          create: (_) => PendingOrdersRemote(_authenticatedDio),
        ),
        Provider<OrderItemsApi>(
          create: (_) => OrderItemsRemote(_authenticatedDio),
        ),
        ChangeNotifierProvider<OrdersProvider>(
          create: (c) => OrdersProvider(
            c.read<AuthProvider>(),
            c.read<PendingOrdersApi>(),
          ),
        ),

        // Menu
        Provider<MenusApi>(
          create: (_) => VenueMenusRemote(_authenticatedDio),
        ),
        ChangeNotifierProvider<MenuProvider>(
          create: (c) => MenuProvider(
            c.read<AuthProvider>(),
            c.read<MenusApi>(),
          ),
        ),

        // Preparing (queue for kitchen + bar)
        Provider<QueueApi>(
          create: (_) => QueueRemote(_authenticatedDio),
        ),
        ChangeNotifierProvider<QueueProvider>(
          create: (c) => QueueProvider(
            c.read<AuthProvider>(),
            c.read<QueueApi>(),
          ),
        ),

        // Reservations (requests by role: kitchen / bar / waiter)
        Provider<ReservationsApi>(
          create: (_) => ReservationsRemote(_authenticatedDio),
        ),
        ChangeNotifierProvider<ReservationsProvider>(
          create: (c) => ReservationsProvider(
            c.read<AuthProvider>(),
            c.read<ReservationsApi>(),
          ),
        ),
      ],
      child: const GastroBotApp(),
    );
  }
}
