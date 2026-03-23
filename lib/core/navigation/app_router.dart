import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/models/profile_type.dart';
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
import 'package:gastrobotmanager/features/reservations/domain/models/active_reservations_filters.dart';
import 'package:gastrobotmanager/features/reservations/screens/active_reservations_filter_screen.dart';
import 'package:gastrobotmanager/features/reservations/screens/reservations_screen.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_model.dart';
import 'package:gastrobotmanager/features/tables/domain/models/table_orders_filters.dart';
import 'package:gastrobotmanager/features/tables/screens/filter_table_orders_screen.dart';
import 'package:gastrobotmanager/features/tables/screens/table_order_screen.dart';
import 'package:gastrobotmanager/features/tables/screens/table_overview_screen.dart';
import 'package:gastrobotmanager/features/tables/screens/tables_screen.dart';

/// Centralized route names and path constants.
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
  static const tables = 'tables';
  static const profile = 'profile';

  // Orders details / filters
  static const activeOrderDetails = 'active-order-details';
  static const historyOrderDetails = 'history-order-details';
  static const orderDetails = 'order-details';
  static const timeEstimation = 'time-estimation';
  static const filterActiveOrders = 'filter-active-orders';
  static const filterHistoryOrders = 'filter-history-orders';

  // Reservations details / filters
  static const reservationDetails = 'reservation-details';
  static const filterActiveReservations = 'filter-active-reservations';

  // Tables sub-routes
  static const tableOrder = 'table-order';
  static const tableOverview = 'table-overview';
  static const filterTableOrders = 'filter-table-orders';

  // Path constants
  static const pathLogin = '/login';
  static const pathReady = '/ready';
  static const pathOrders = '/orders';
  static const pathPreparing = '/preparing';
  static const pathReservations = '/reservations';
  static const pathMenu = '/menu';
  static const pathDrinks = '/drinks';
  static const pathTables = '/tables';
  static const pathTablesFilterTableOrders = '/tables/overview/filter-orders';
  static const pathProfile = '/profile';

  // Orders sub-routes (full paths for context.push)
  static const pathOrdersActive = '/orders/active';
  static const pathOrdersHistory = '/orders/history';
  static const pathOrdersDetails = '/orders/details';
  static const pathOrdersFilterActive = '/orders/filter/active';
  static const pathOrdersFilterHistory = '/orders/filter/history';
  static const pathReservationsFilterActive = '/reservations/filter/active';
}

/// Centralized app router factory.
///
/// The router is auth-aware:
/// - While [auth.isRestoring] is true, no redirects are performed.
/// - When not logged in, any route except `/login` is redirected to `/login`.
/// - After login, navigates to the initial page (orders or ready by role).
class AppRouter {
  AppRouter._();

  static bool _didInitialWaiterRedirect = false;

  static GoRouter create(AuthProvider auth) {
    return GoRouter(
      initialLocation: AppRouteNames.pathOrders,
      refreshListenable: auth,
      debugLogDiagnostics: false,
      routes: [
        GoRoute(
          path: '/',
          redirect: (context, state) {
            final auth = context.read<AuthProvider>();
            if (!auth.isLoggedIn) return AppRouteNames.pathLogin;
            return auth.profileType == ProfileType.waiter
                ? AppRouteNames.pathReady
                : AppRouteNames.pathOrders;
          },
        ),
        GoRoute(
          path: AppRouteNames.pathLogin,
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
                  path: AppRouteNames.pathReady,
                  name: AppRouteNames.ready,
                  builder: (context, state) => const ReadyItemsScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRouteNames.pathOrders,
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
                  path: AppRouteNames.pathPreparing,
                  name: AppRouteNames.preparing,
                  builder: (context, state) => const PreparingScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRouteNames.pathReservations,
                  name: AppRouteNames.reservations,
                  builder: (context, state) => const ReservationsScreen(),
                  routes: [
                    GoRoute(
                      path: 'filter/active',
                      name: AppRouteNames.filterActiveReservations,
                      builder: (context, state) {
                        final initialFilters = state.extra;
                        return ActiveReservationsFilterScreen(
                          initialFilters: initialFilters
                              is ActiveReservationsFilters
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
                  path: AppRouteNames.pathTables,
                  name: AppRouteNames.tables,
                  builder: (context, state) => const TablesScreen(),
                  routes: [
                    GoRoute(
                      path: 'order',
                      name: AppRouteNames.tableOrder,
                      builder: (context, state) {
                        final extra = state.extra;
                        if (extra is! TableModel) {
                          throw ArgumentError(
                            'TableOrderScreen requires TableModel in '
                            'GoRouterState.extra',
                          );
                        }
                        return TableOrderScreen(orderForTable: extra);
                      },
                    ),
                    GoRoute(
                      path: 'overview',
                      name: AppRouteNames.tableOverview,
                      builder: (context, state) {
                        final extra = state.extra;
                        if (extra is! TableModel) {
                          throw ArgumentError(
                            'TableOverviewScreen requires TableModel in '
                            'GoRouterState.extra',
                          );
                        }
                        return TableOverviewScreen(table: extra);
                      },
                      routes: [
                        GoRoute(
                          path: 'filter-orders',
                          name: AppRouteNames.filterTableOrders,
                          builder: (context, state) {
                            final extra = state.extra;
                            return FilterTableOrdersScreen(
                              initialFilters: extra is TableOrdersFilters
                                  ? extra
                                  : null,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRouteNames.pathMenu,
                  name: AppRouteNames.menu,
                  builder: (context, state) => const MenuScreen(),
                ),
                GoRoute(
                  path: AppRouteNames.pathDrinks,
                  name: AppRouteNames.drinks,
                  builder: (context, state) => const MenuScreen(),
                ),
              ],
            ),
            StatefulShellBranch(
              routes: [
                GoRoute(
                  path: AppRouteNames.pathProfile,
                  name: AppRouteNames.profile,
                  builder: (context, state) => const ProfileScreen(),
                ),
              ],
            ),
          ],
        ),
      ],
      redirect: (context, state) => _redirect(auth, state),
    );
  }

  static String? _redirect(AuthProvider auth, GoRouterState state) {
    if (auth.isRestoring) return null;

    final loggedIn = auth.isLoggedIn;
    final isOnLogin = state.matchedLocation == AppRouteNames.pathLogin;

    if (!loggedIn) {
      _didInitialWaiterRedirect = false;
      if (isOnLogin) return null;
      return AppRouteNames.pathLogin;
    }

    if (isOnLogin) {
      final defaultHome = auth.profileType == ProfileType.waiter
          ? AppRouteNames.pathReady
          : AppRouteNames.pathOrders;
      return defaultHome;
    }

    // One-time post-restore redirect: waiter lands on /orders at cold start.
    final profileType = auth.profileType;
    if (!_didInitialWaiterRedirect &&
        profileType == ProfileType.waiter &&
        state.matchedLocation == AppRouteNames.pathOrders) {
      _didInitialWaiterRedirect = true;
      return AppRouteNames.pathReady;
    }

    return null;
  }
}
