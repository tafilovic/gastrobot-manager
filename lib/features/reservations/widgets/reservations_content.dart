import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/utils/calendar_day_bounds.dart';
import 'package:gastrobotmanager/core/layout/app_breakpoints.dart';
import 'package:gastrobotmanager/core/navigation/app_router.dart';
import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/navigation/fade_slide_page_route.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/core/widgets/list_item_entrance.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/pending_reservation.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/active_reservations_filters.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/reservations/providers/confirmed_reservations_provider.dart';
import 'package:gastrobotmanager/features/reservations/providers/reservations_provider.dart';
import 'package:gastrobotmanager/features/reservations/screens/confirmed_reservation_details_screen.dart';
import 'package:gastrobotmanager/features/reservations/screens/reservation_details_screen.dart';
import 'package:gastrobotmanager/features/reservations/screens/waiter_reservation_details_screen.dart';
import 'package:gastrobotmanager/features/reservations/widgets/confirmed_reservation_card.dart';
import 'package:gastrobotmanager/features/reservations/widgets/confirmed_reservation_details_content.dart';
import 'package:gastrobotmanager/features/reservations/widgets/kitchen_bar_reservation_request_details_content.dart';
import 'package:gastrobotmanager/features/reservations/widgets/reservation_request_card.dart';
import 'package:gastrobotmanager/features/reservations/widgets/waiter_reservation_request_details_content.dart';
import 'package:gastrobotmanager/features/tables/utils/venue_table_id_match.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Reservations screen content: title, tabs (Zahtevi / Prihvaćeno), count, list of request cards.
/// On wide screens (>= 900px): master-detail layout. On mobile: push to full screen.
class ReservationsContent extends StatefulWidget {
  const ReservationsContent({
    super.key,
    required this.accentColor,
    required this.onStartRefresh,
  });

  final Color accentColor;
  final VoidCallback onStartRefresh;

  @override
  State<ReservationsContent> createState() => _ReservationsContentState();
}

class _ReservationsContentState extends State<ReservationsContent> {
  static const double _loadMoreThresholdPx = 280;
  int _selectedTabIndex = 0;
  PendingReservation? _selectedWaiterRequest;
  PendingOrder? _selectedKitchenBarRequest;
  ConfirmedReservation? _selectedConfirmed;
  ActiveReservationsFilters? _activeReservationsFilters;
  final ScrollController _waiterRequestsScrollController = ScrollController();
  final ScrollController _confirmedScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _waiterRequestsScrollController.addListener(_onWaiterRequestsScroll);
    _confirmedScrollController.addListener(_onConfirmedScroll);
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.onStartRefresh(),
    );
  }

  @override
  void dispose() {
    _waiterRequestsScrollController
      ..removeListener(_onWaiterRequestsScroll)
      ..dispose();
    _confirmedScrollController
      ..removeListener(_onConfirmedScroll)
      ..dispose();
    super.dispose();
  }

  void _onWaiterRequestsScroll() {
    if (_selectedTabIndex != 0) return;
    final auth = context.read<AuthProvider>();
    if (auth.profileType != ProfileType.waiter) return;
    final c = _waiterRequestsScrollController;
    if (!c.hasClients) return;
    if (_isNearListEnd(c)) {
      context.read<ReservationsProvider>().loadMoreWaiterRequests();
    }
  }

  void _onConfirmedScroll() {
    if (_selectedTabIndex != 1) return;
    final auth = context.read<AuthProvider>();
    if (auth.profileType != ProfileType.waiter) return;
    final c = _confirmedScrollController;
    if (!c.hasClients) return;
    if (_isNearListEnd(c)) {
      context.read<ConfirmedReservationsProvider>().loadMore();
    }
  }

  bool _isNearListEnd(ScrollController c) {
    return c.position.pixels >= c.position.maxScrollExtent - _loadMoreThresholdPx;
  }

  void _onTabChanged(Set<int> selected, ProfileType? profileType) {
    final idx = selected.first;
    setState(() {
      _selectedTabIndex = idx;
      _selectedWaiterRequest = null;
      _selectedKitchenBarRequest = null;
      _selectedConfirmed = null;
      if (idx != 1) _activeReservationsFilters = null;
    });
    if (context.mounted) {
      final venueId = context.read<AuthProvider>().currentVenueId;
      if (idx == 0 && profileType == ProfileType.waiter) {
        context.read<ReservationsProvider>().pullRefresh();
      } else if (idx == 1 &&
          profileType == ProfileType.waiter &&
          venueId != null) {
        context.read<ConfirmedReservationsProvider>().load(venueId);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final provider = context.watch<ReservationsProvider>();
    final profileType = context.watch<AuthProvider>().profileType;
    final waiterRequests = provider.waiterRequests;
    final kitchenRequests = provider.kitchenBarRequests;
    final totalItems =
        kitchenRequests.fold<int>(0, (sum, o) => sum + o.itemCount);

    final confirmedProvider = context.watch<ConfirmedReservationsProvider>();
    final filteredConfirmed = _applyReservationFilters(
      confirmedProvider.items,
      _activeReservationsFilters,
    );

    final isBar =
        profileType == ProfileType.bar || profileType == ProfileType.waiter;
    final countLabel = profileType == ProfileType.waiter
        ? (_selectedTabIndex == 1
              ? l10n.reservationCountList(filteredConfirmed.length)
              : l10n.reservationCountList(waiterRequests.length))
        : (isBar
              ? l10n.reservationCountDrinks(totalItems)
              : l10n.reservationCountDishes(totalItems));

    String itemCountForCard(PendingOrder order) {
      return isBar
          ? l10n.orderDrinksCount(order.itemCount)
          : l10n.orderDishCount(order.itemCount);
    }

    final width = MediaQuery.sizeOf(context).width;
    final useMasterDetail = width >= AppBreakpoints.expanded;

    void onSeeWaiterReservation(PendingReservation reservation) {
      if (useMasterDetail) {
        setState(() {
          _selectedWaiterRequest = reservation;
          _selectedKitchenBarRequest = null;
          _selectedConfirmed = null;
        });
      } else {
        _openWaiterReservationDetails(context, reservation, provider);
      }
    }

    void onSeeKitchenRequest(PendingOrder order) {
      if (useMasterDetail) {
        setState(() {
          _selectedKitchenBarRequest = order;
          _selectedWaiterRequest = null;
          _selectedConfirmed = null;
        });
      } else {
        _openKitchenReservationDetails(context, order, provider);
      }
    }

    void onSeeConfirmedDetails(ConfirmedReservation reservation) {
      if (useMasterDetail) {
        setState(() {
          _selectedConfirmed = reservation;
          _selectedWaiterRequest = null;
          _selectedKitchenBarRequest = null;
        });
      } else {
        Navigator.of(context).push<void>(
          FadeSlidePageRoute<void>(
            builder: (_) =>
                ConfirmedReservationDetailsScreen(reservation: reservation),
          ),
        );
      }
    }

    if (useMasterDetail) {
      return Scaffold(
        backgroundColor: AppColors.backgroundMuted,
        body: SafeArea(
          child: ConstrainedContent(
            maxWidth: AppBreakpoints.contentMaxWidthMasterDetail,
            padding: EdgeInsets.zero,
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: _buildListPane(
                    context,
                    theme,
                    l10n,
                    provider,
                    confirmedProvider,
                    filteredConfirmed,
                    profileType,
                    countLabel,
                    itemCountForCard,
                    onSeeWaiterReservation,
                    onSeeKitchenRequest,
                    onSeeConfirmedDetails,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: _selectedTabIndex == 1
                      ? (_selectedConfirmed == null
                            ? _buildDetailPlaceholder(theme, l10n)
                            : ConfirmedReservationDetailsContent(
                                reservation: _selectedConfirmed!,
                                onCompleted: () {
                                  setState(() => _selectedConfirmed = null);
                                  widget.onStartRefresh();
                                },
                              ))
                      : _buildRequestDetailPaneForSelection(
                          theme,
                          l10n,
                          profileType,
                          provider,
                        ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.backgroundMuted,
      body: SafeArea(
        child: ConstrainedContent(
          maxWidth: AppBreakpoints.contentMaxWidthWide,
          padding: EdgeInsets.zero,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
                child: Text(
                  l10n.reservationsRequestsTitle,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Expanded(
                      child: SegmentedButton<int>(
                        segments: [
                          ButtonSegment<int>(
                            value: 0,
                            label: Text(l10n.reservationsTabRequests),
                          ),
                          ButtonSegment<int>(
                            value: 1,
                            label: Text(l10n.reservationsTabAccepted),
                          ),
                        ],
                        selected: {_selectedTabIndex},
                        onSelectionChanged: (s) =>
                            _onTabChanged(s, profileType),
                        style: ButtonStyle(
                          backgroundColor: WidgetStateProperty.resolveWith((
                            states,
                          ) {
                            if (states.contains(WidgetState.selected)) {
                              return widget.accentColor;
                            }
                            return AppColors.surface;
                          }),
                          foregroundColor: WidgetStateProperty.resolveWith((
                            states,
                          ) {
                            if (states.contains(WidgetState.selected)) {
                              return AppColors.onPrimary;
                            }
                            return AppColors.textPrimary;
                          }),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child:
                    _selectedTabIndex == 1 && profileType == ProfileType.waiter
                    ? Row(
                        children: [
                          Text(
                            countLabel,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const Spacer(),
                          TextButton.icon(
                            onPressed: _openReservationFilters,
                            icon: Icon(
                              Icons.filter_list,
                              size: 18,
                              color: widget.accentColor,
                            ),
                            label: Text(
                              l10n.reservationsFilters,
                              style: TextStyle(
                                color: widget.accentColor,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      )
                    : Text(
                        countLabel,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, _) {
                    final crossAxisCount =
                        width >= AppBreakpoints.contentMaxWidthWide
                        ? 3
                        : width >= AppBreakpoints.expanded
                        ? 2
                        : 1;
                    final baseMaxWidth = crossAxisCount > 1
                        ? AppBreakpoints.contentMaxWidthWide
                        : AppBreakpoints.contentMaxWidth;
                    final maxWidth = crossAxisCount > 1
                        ? baseMaxWidth * 1.4
                        : baseMaxWidth;

                    return ConstrainedContent(
                      maxWidth: maxWidth,
                      padding: EdgeInsets.zero,
                      child: _selectedTabIndex == 1
                          ? _buildConfirmedList(
                              context,
                              l10n,
                              confirmedProvider,
                              filteredConfirmed,
                              crossAxisCount,
                              onSeeConfirmedDetails,
                              highlightSelection: useMasterDetail,
                            )
                          : RefreshIndicator(
                              onRefresh: () => provider.pullRefresh(),
                              child: provider.isLoading &&
                                      _pendingRequestsEmpty(provider, profileType)
                                  ? ListView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      children: [
                                        SizedBox(
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.3,
                                          child: const Center(
                                            child: CircularProgressIndicator(),
                                          ),
                                        ),
                                      ],
                                    )
                                  : provider.error != null &&
                                          _pendingRequestsEmpty(
                                            provider,
                                            profileType,
                                          )
                                  ? ListView(
                                      physics:
                                          const AlwaysScrollableScrollPhysics(),
                                      children: [
                                        SizedBox(
                                          height:
                                              MediaQuery.of(
                                                context,
                                              ).size.height *
                                              0.3,
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.all(24),
                                              child: Text(
                                                provider.error!,
                                                textAlign: TextAlign.center,
                                                style: const TextStyle(
                                                  color: AppColors.error,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  : _buildRequestsList(
                                      context,
                                      l10n,
                                      crossAxisCount,
                                      itemCountForCard,
                                      profileType,
                                      provider,
                                      onSeeWaiterReservation,
                                      onSeeKitchenRequest,
                                      highlightSelection: useMasterDetail,
                                    ),
                            ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _openReservationFilters() async {
    final result = await context.push<ActiveReservationsFilters>(
      AppRouteNames.pathReservationsFilterActive,
      extra: _activeReservationsFilters,
    );
    if (result != null && mounted) {
      setState(() => _activeReservationsFilters = result);
    }
  }

  List<ConfirmedReservation> _applyReservationFilters(
    List<ConfirmedReservation> items,
    ActiveReservationsFilters? filters,
  ) {
    if (filters == null || filters.isEmpty) return items;
    return items.where((r) {
      if (filters.dateFrom != null) {
        final day = CalendarDayBounds.startOfDay(r.reservationStart);
        final from = CalendarDayBounds.startOfDay(filters.dateFrom!);
        if (day.isBefore(from)) return false;
      }
      if (filters.dateTo != null) {
        final day = CalendarDayBounds.startOfDay(r.reservationStart);
        final to = CalendarDayBounds.startOfDay(filters.dateTo!);
        if (day.isAfter(to)) return false;
      }
      if (filters.peopleCounts.isNotEmpty) {
        if (!filters.peopleCounts.contains(r.peopleCount)) return false;
      }
      if (filters.regions.isNotEmpty) {
        final regionLower = r.regionTitle?.toLowerCase() ?? '';
        final matches = filters.regions.any((reg) {
          if (reg == ActiveReservationsFilters.regionIndoors) {
            return _regionIndoorsKeywords.any((k) => regionLower.contains(k));
          }
          if (reg == ActiveReservationsFilters.regionGarden) {
            return _regionGardenKeywords.any((k) => regionLower.contains(k));
          }
          return false;
        });
        if (!matches) return false;
      }
      if (filters.reservationContents.isNotEmpty) {
        final hasFood = r.foodItems.isNotEmpty;
        final hasDrink = r.drinkItems.isNotEmpty;
        final matches = filters.reservationContents.every((c) {
          if (c == ActiveReservationsFilters.contentFood) return hasFood;
          if (c == ActiveReservationsFilters.contentDrink) return hasDrink;
          return false;
        });
        if (!matches) return false;
      }
      if (filters.tableIds.isNotEmpty) {
        final hasMatch = filters.tableIds.any(
          (fid) => r.tables.any((t) => sameVenueTableId(fid, t.id)),
        );
        if (!hasMatch) return false;
      }
      return true;
    }).toList();
  }

  static const _regionIndoorsKeywords = [
    'unutrašnjost',
    'indoors',
    'innen',
    'interior',
    'interno',
    'в помещении',
  ];
  static const _regionGardenKeywords = [
    'bašta',
    'garden',
    'garten',
    'jardín',
    'giardino',
    'сад',
  ];

  bool _pendingRequestsEmpty(
    ReservationsProvider provider,
    ProfileType? profileType,
  ) {
    if (profileType == ProfileType.waiter) {
      return provider.waiterRequests.isEmpty;
    }
    return provider.kitchenBarRequests.isEmpty;
  }

  Future<void> _openWaiterReservationDetails(
    BuildContext context,
    PendingReservation reservation,
    ReservationsProvider provider,
  ) async {
    final completed = await Navigator.of(context).push<bool>(
      FadeSlidePageRoute<bool>(
        builder: (_) =>
            WaiterReservationDetailsScreen(reservation: reservation),
      ),
    );
    if (completed == true && context.mounted) {
      provider.pullRefresh();
    }
  }

  Future<void> _openKitchenReservationDetails(
    BuildContext context,
    PendingOrder order,
    ReservationsProvider provider,
  ) async {
    final completed = await Navigator.of(context).push<bool>(
      FadeSlidePageRoute<bool>(
        builder: (_) => ReservationDetailsScreen(order: order),
      ),
    );
    if (completed == true && context.mounted) {
      provider.pullRefresh();
    }
  }

  Widget _buildListPane(
    BuildContext context,
    ThemeData theme,
    AppLocalizations l10n,
    ReservationsProvider provider,
    ConfirmedReservationsProvider confirmedProvider,
    List<ConfirmedReservation> filteredConfirmed,
    ProfileType? profileType,
    String countLabel,
    String Function(PendingOrder) itemCountForCard,
    void Function(PendingReservation) onSeeWaiterReservation,
    void Function(PendingOrder) onSeeKitchenRequest,
    void Function(ConfirmedReservation) onSeeConfirmedDetails,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
          child: Text(
            l10n.reservationsRequestsTitle,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            children: [
              Expanded(
                child: SegmentedButton<int>(
                  segments: [
                    ButtonSegment<int>(
                      value: 0,
                      label: Text(l10n.reservationsTabRequests),
                    ),
                    ButtonSegment<int>(
                      value: 1,
                      label: Text(l10n.reservationsTabAccepted),
                    ),
                  ],
                  selected: {_selectedTabIndex},
                  onSelectionChanged: (s) => _onTabChanged(s, profileType),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return widget.accentColor;
                      }
                      return AppColors.surface;
                    }),
                    foregroundColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.selected)) {
                        return AppColors.onPrimary;
                      }
                      return AppColors.textPrimary;
                    }),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
          child: _selectedTabIndex == 1 && profileType == ProfileType.waiter
              ? Row(
                  children: [
                    Text(
                      countLabel,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const Spacer(),
                    TextButton.icon(
                      onPressed: _openReservationFilters,
                      icon: Icon(
                        Icons.filter_list,
                        size: 18,
                        color: widget.accentColor,
                      ),
                      label: Text(
                        l10n.reservationsFilters,
                        style: TextStyle(
                          color: widget.accentColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                )
              : Text(
                  countLabel,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
        ),
        Expanded(
          child: _selectedTabIndex == 1
              ? _buildConfirmedList(
                  context,
                  l10n,
                  confirmedProvider,
                  filteredConfirmed,
                  1,
                  onSeeConfirmedDetails,
                  highlightSelection: true,
                )
              : RefreshIndicator(
                  onRefresh: () => provider.pullRefresh(),
                  child: provider.isLoading &&
                          _pendingRequestsEmpty(provider, profileType)
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ],
                        )
                      : provider.error != null &&
                              _pendingRequestsEmpty(provider, profileType)
                          ? ListView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              children: [
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * 0.3,
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.all(24),
                                      child: Text(
                                        provider.error!,
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(
                                          color: AppColors.error,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          : _buildRequestsList(
                              context,
                              l10n,
                              1,
                              itemCountForCard,
                              profileType,
                              provider,
                              onSeeWaiterReservation,
                              onSeeKitchenRequest,
                              highlightSelection: true,
                            ),
                ),
        ),
      ],
    );
  }

  Widget _buildDetailPlaceholder(ThemeData theme, AppLocalizations l10n) {
    return Center(
      child: Text(
        l10n.orderSeeDetails,
        style: theme.textTheme.bodyLarge?.copyWith(color: AppColors.textMuted),
      ),
    );
  }

  bool _isSameSelectedWaiter(
    PendingReservation? selected,
    PendingReservation reservation,
  ) {
    if (selected == null) return false;
    return selected.id == reservation.id;
  }

  bool _isSameSelectedKitchen(PendingOrder? selected, PendingOrder order) {
    if (selected == null) return false;
    if (selected.orderId.isNotEmpty && order.orderId.isNotEmpty) {
      return selected.orderId == order.orderId;
    }
    return selected.orderNumber == order.orderNumber &&
        selected.targetTime == order.targetTime;
  }

  bool _isSameSelectedConfirmed(
    ConfirmedReservation? selected,
    ConfirmedReservation reservation,
  ) {
    if (selected == null) return false;
    return selected.id == reservation.id;
  }

  Widget _buildRequestDetailPaneForSelection(
    ThemeData theme,
    AppLocalizations l10n,
    ProfileType? profileType,
    ReservationsProvider provider,
  ) {
    if (profileType == ProfileType.waiter) {
      if (_selectedWaiterRequest == null) {
        return _buildDetailPlaceholder(theme, l10n);
      }
      return WaiterReservationRequestDetailsContent(
        reservation: _selectedWaiterRequest!,
        onCompleted: () {
          setState(() => _selectedWaiterRequest = null);
          widget.onStartRefresh();
        },
      );
    }
    if (_selectedKitchenBarRequest == null) {
      return _buildDetailPlaceholder(theme, l10n);
    }
    return KitchenBarReservationRequestDetailsContent(
      order: _selectedKitchenBarRequest!,
      onCompleted: () {
        setState(() => _selectedKitchenBarRequest = null);
        widget.onStartRefresh();
      },
    );
  }

  Widget _buildRequestsList(
    BuildContext context,
    AppLocalizations l10n,
    int crossAxisCount,
    String Function(PendingOrder) itemCountForCard,
    ProfileType? profileType,
    ReservationsProvider provider,
    void Function(PendingReservation) onSeeWaiterReservation,
    void Function(PendingOrder) onSeeKitchenRequest, {
    required bool highlightSelection,
  }) {
    const padding = EdgeInsets.symmetric(horizontal: 20, vertical: 8);

    if (profileType == ProfileType.waiter) {
      final requests = provider.waiterRequests;
      final showLoader = provider.isLoadingMoreWaiter;
      final totalCount = requests.length + (showLoader ? 1 : 0);
      Widget buildCard(int index) {
        if (index >= requests.length) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 16),
            child: Center(child: CircularProgressIndicator()),
          );
        }
        final reservation = requests[index];
        return ListItemEntrance(
          index: index,
          child: ReservationRequestCard(
            waiterReservation: reservation,
            l10n: l10n,
            accentColor: widget.accentColor,
            itemCountLabel: '',
            showWaiterPendingLayout: true,
            isSelected: highlightSelection &&
                _isSameSelectedWaiter(_selectedWaiterRequest, reservation),
            onSeeDetails: () => onSeeWaiterReservation(reservation),
          ),
        );
      }

      if (crossAxisCount == 1) {
        return ListView.separated(
          controller: _waiterRequestsScrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          padding: padding,
          itemCount: totalCount,
          separatorBuilder: (_, _) => const SizedBox(height: 12),
          itemBuilder: (context, index) => buildCard(index),
        );
      }

      return GridView.builder(
        controller: _waiterRequestsScrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          mainAxisExtent: 200,
        ),
        itemCount: totalCount,
        itemBuilder: (context, index) => buildCard(index),
      );
    }

    final requests = provider.kitchenBarRequests;
    Widget buildCard(int index) {
      final order = requests[index];
      return ListItemEntrance(
        index: index,
        child: ReservationRequestCard(
          order: order,
          l10n: l10n,
          accentColor: widget.accentColor,
          itemCountLabel: itemCountForCard(order),
          showWaiterPendingLayout: false,
          isSelected: highlightSelection &&
              _isSameSelectedKitchen(_selectedKitchenBarRequest, order),
          onSeeDetails: () => onSeeKitchenRequest(order),
        ),
      );
    }

    if (crossAxisCount == 1) {
      return ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: padding,
        itemCount: requests.length,
        separatorBuilder: (_, _) => const SizedBox(height: 12),
        itemBuilder: (context, index) => buildCard(index),
      );
    }

    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: padding,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 200,
      ),
      itemCount: requests.length,
      itemBuilder: (context, index) => buildCard(index),
    );
  }

  Widget _buildConfirmedList(
    BuildContext context,
    AppLocalizations l10n,
    ConfirmedReservationsProvider confirmedProvider,
    List<ConfirmedReservation> items,
    int crossAxisCount,
    void Function(ConfirmedReservation) onSeeDetails, {
    required bool highlightSelection,
  }) {
    if (confirmedProvider.isLoading && confirmedProvider.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: const Center(child: CircularProgressIndicator()),
          ),
        ],
      );
    }

    if (confirmedProvider.error != null && confirmedProvider.items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  confirmedProvider.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            ),
          ),
        ],
      );
    }

    if (items.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.3,
            child: Center(
              child: Text(
                l10n.reservationsTabAccepted,
                style: const TextStyle(color: AppColors.textMuted),
              ),
            ),
          ),
        ],
      );
    }

    const padding = EdgeInsets.symmetric(horizontal: 20, vertical: 8);
    final showLoader = confirmedProvider.isLoadingMore;
    final totalCount = items.length + (showLoader ? 1 : 0);

    Widget buildCard(int index) {
      if (index >= items.length) {
        return const Padding(
          padding: EdgeInsets.symmetric(vertical: 16),
          child: Center(child: CircularProgressIndicator()),
        );
      }
      final reservation = items[index];
      return ListItemEntrance(
        index: index,
        child: ConfirmedReservationCard(
          reservation: reservation,
          l10n: l10n,
          accentColor: widget.accentColor,
          isSelected: highlightSelection &&
              _isSameSelectedConfirmed(_selectedConfirmed, reservation),
          onSeeDetails: () => onSeeDetails(reservation),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => confirmedProvider.pullRefresh(),
      child: crossAxisCount == 1
          ? ListView.separated(
              controller: _confirmedScrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: padding,
              itemCount: totalCount,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => buildCard(index),
            )
          : GridView.builder(
              controller: _confirmedScrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              padding: padding,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 200,
              ),
              itemCount: totalCount,
              itemBuilder: (context, index) => buildCard(index),
            ),
    );
  }
}
