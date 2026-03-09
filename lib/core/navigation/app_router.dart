import 'package:go_router/go_router.dart';

import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/auth/screens/login_screen.dart';
import 'package:gastrobotmanager/features/home/screens/main_shell.dart';
import 'package:gastrobotmanager/features/menu/screens/menu_screen.dart';
import 'package:gastrobotmanager/features/orders/domain/models/active_order_filters.dart';
import 'package:gastrobotmanager/features/orders/domain/models/history_order_filters.dart';
import 'package:gastrobotmanager/features/orders/screens/active_order_details_screen.dart';
import 'package:gastrobotmanager/features/orders/screens/filter_active_orders_screen.dart';
import 'package:gastrobotmanager/features/orders/screens/filter_history_orders_screen.dart';
import 'package:gastrobotmanager/features/orders/screens/history_order_details_screen.dart';
import 'package:gastrobotmanager/features/orders/screens/orders_screen.dart';
import 'package:gastrobotmanager/features/orders/screens/order_details_screen.dart';
import 'package:gastrobotmanager/features/orders/screens/time_estimation_screen.dart';
import 'package:gastrobotmanager/features/preparing/screens/preparing_screen.dart';
import 'package:gastrobotmanager/features/profile/screens/profile_screen.dart';
import 'package:gastrobotmanager/features/ready_items/screens/ready_items_screen.dart';
import 'package:gastrobotmanager/features/reservations/screens/reservations_screen.dart';

/// Centralized route names to avoid string duplication.
abstract class AppRouteNames {
  static const login = 'login';

  // Shell and top-level branches
  static const shell = 'shell';
  static const ready = 'ready';
  static const orders = 'orders';
  static const preparing = 'preparing';
  static const reservations = 'reservations';
  static const menu = 'menu';
  static const drinks = 'drinks';
  static const profile = 'profile';

  // Orders details / filters
  static const activeOrderDetails = 'active-order-details';
  static const historyOrderDetails = 'history-order-details';
  static const orderDetails = 'order-details';
  static const timeEstimation = 'time-estimation';
  static const filterActiveOrders = 'filter-active-orders';
  static const filterHistoryOrders = 'filter-history-orders';

  // Reservations details (placeholder for future expansion)
  static const reservationDetails = 'reservation-details';
}

/// Centralized app router factory.
///
/// The router is auth-aware:
/// - While [auth.isRestoring] is true, no redirects are performed.
/// - When not logged in, any route except `/login` is redirected to `/login`.
/// - After login, navigation continues to the originally requested route if any.
class AppRouter {
  AppRouter._();

  static String? _pendingLocation;

  static GoRouter create(AuthProvider auth) {
    return GoRouter(
      initialLocation: '/orders',
      refreshListenable: auth,
      debugLogDiagnostics: false,
      routes: [
        GoRoute(
          path: '/login',
          name: AppRouteNames.login,
          builder: (context, state) => const LoginScreen(),
        ),
        StatefulShellRoute.indexedStack(
          builder: (context, state, navigationShell) {
            return MainShell(navigationShell: navigationShell);
          },
          branches: [
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/ready',
                  name: AppRouteNames.ready,
                  builder: (context, state) => const ReadyItemsScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/orders',
                  name: AppRouteNames.orders,
                  builder: (context, state) => const OrdersScreen(),
                  routes: [
                    GoRoute(
                      path: 'active',
                      name: AppRouteNames.activeOrderDetails,
                      builder: (context, state) {
                        final extra = state.extra;
                        if (extra is! ActiveOrderDetailsScreen) {
                          throw ArgumentError(
                            'ActiveOrderDetailsScreen must be provided via GoRouterState.extra',
                          );
                        }
                        return extra;
                      },
                    ),
                    GoRoute(
                      path: 'history',
                      name: AppRouteNames.historyOrderDetails,
                      builder: (context, state) {
                        final extra = state.extra;
                        if (extra is! HistoryOrderDetailsScreen) {
                          throw ArgumentError(
                            'HistoryOrderDetailsScreen must be provided via GoRouterState.extra',
                          );
                        }
                        return extra;
                      },
                    ),
                    GoRoute(
                      path: 'time-estimation',
                      name: AppRouteNames.timeEstimation,
                      builder: (context, state) {
                        final extra = state.extra;
                        if (extra is! TimeEstimationScreen) {
                          throw ArgumentError(
                            'TimeEstimationScreen must be provided via GoRouterState.extra',
                          );
                        }
                        return extra;
                      },
                    ),
                    GoRoute(
                      path: 'details',
                      name: AppRouteNames.orderDetails,
                      builder: (context, state) {
                        final extra = state.extra;
                        if (extra is! OrderDetailsScreen) {
                          throw ArgumentError(
                            'OrderDetailsScreen must be provided via GoRouterState.extra',
                          );
                        }
                        return extra;
                      },
                    ),
                    GoRoute(
                      path: 'filter/active',
                      name: AppRouteNames.filterActiveOrders,
                      builder: (context, state) {
                        final initialFilters = state.extra;
                        return FilterActiveOrdersScreen(
                          initialFilters: initialFilters is ActiveOrderFilters
                              ? initialFilters
                              : null,
                        );
                      },
                    ),
                    GoRoute(
                      path: 'filter/history',
                      name: AppRouteNames.filterHistoryOrders,
                      builder: (context, state) {
                        final initialFilters = state.extra;
                        return FilterHistoryOrdersScreen(
                          initialFilters: initialFilters is HistoryOrderFilters
                              ? initialFilters
                              : null,
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/preparing',
                  name: AppRouteNames.preparing,
                  builder: (context, state) => const PreparingScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/reservations',
                  name: AppRouteNames.reservations,
                  builder: (context, state) => const ReservationsScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/menu',
                  name: AppRouteNames.menu,
                  builder: (context, state) => const MenuScreen(),
                ),
                GoRoute(
                  path: '/drinks',
                  name: AppRouteNames.drinks,
                  builder: (context, state) => const MenuScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: '/profile',
                  name: AppRouteNames.profile,
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
      redirect: (context, state) {
        final restoring = auth.isRestoring;
        if (restoring) {
          return null;
        }

        final loggedIn = auth.isLoggedIn;
        final isLoggingIn = state.matchedLocation == '/login';

        if (!loggedIn) {
          if (isLoggingIn) {
            return null;
          }
          // Remember the target for after successful login.
          final location = state.uri.toString();
          if (location != '/login') {
            _pendingLocation = location;
          }
          return '/login';
        }

        // Logged in: prevent returning to login and honor pending deep links.
        if (isLoggingIn) {
          final target = _pendingLocation;
          _pendingLocation = null;
          return target ?? '/orders';
        }

        return null;
      },
    );
  }
}

