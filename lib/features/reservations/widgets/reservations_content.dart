import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/app_breakpoints.dart';
import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/navigation/fade_slide_page_route.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/core/widgets/list_item_entrance.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/reservations/domain/models/confirmed_reservation.dart';
import 'package:gastrobotmanager/features/reservations/providers/confirmed_reservations_provider.dart';
import 'package:gastrobotmanager/features/reservations/providers/reservations_provider.dart';
import 'package:gastrobotmanager/features/reservations/screens/confirmed_reservation_details_screen.dart';
import 'package:gastrobotmanager/features/reservations/screens/reservation_details_screen.dart';
import 'package:gastrobotmanager/features/reservations/widgets/confirmed_reservation_card.dart';
import 'package:gastrobotmanager/features/reservations/widgets/confirmed_reservation_details_content.dart';
import 'package:gastrobotmanager/features/reservations/widgets/kitchen_bar_reservation_request_details_content.dart';
import 'package:gastrobotmanager/features/reservations/widgets/reservation_request_card.dart';
import 'package:gastrobotmanager/features/reservations/widgets/waiter_reservation_request_details_content.dart';
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
  int _selectedTabIndex = 0;
  PendingOrder? _selectedRequest;
  ConfirmedReservation? _selectedConfirmed;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => widget.onStartRefresh(),
    );
  }

  void _onTabChanged(Set<int> selected, ProfileType? profileType) {
    final idx = selected.first;
    setState(() {
      _selectedTabIndex = idx;
      _selectedRequest = null;
      _selectedConfirmed = null;
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
    final requests = provider.requests;
    final totalItems = requests.fold<int>(0, (sum, o) => sum + o.itemCount);

    final confirmedProvider = context.watch<ConfirmedReservationsProvider>();

    final isBar =
        profileType == ProfileType.bar || profileType == ProfileType.waiter;
    final countLabel = profileType == ProfileType.waiter
        ? (_selectedTabIndex == 1
              ? l10n.reservationCountList(confirmedProvider.items.length)
              : l10n.reservationCountList(requests.length))
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

    void onSeeRequestDetails(PendingOrder order) {
      if (useMasterDetail) {
        setState(() {
          _selectedRequest = order;
          _selectedConfirmed = null;
        });
      } else {
        _openRequestDetails(context, order, provider);
      }
    }

    void onSeeConfirmedDetails(ConfirmedReservation reservation) {
      if (useMasterDetail) {
        setState(() {
          _selectedConfirmed = reservation;
          _selectedRequest = null;
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
                  profileType,
                  countLabel,
                  itemCountForCard,
                  onSeeRequestDetails,
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
                    : (_selectedRequest == null
                        ? _buildDetailPlaceholder(theme, l10n)
                        : _buildRequestDetailPane(
                            _selectedRequest!,
                            profileType,
                            provider,
                          )),
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
                      onSelectionChanged: (s) => _onTabChanged(s, profileType),
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
              child: Text(
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
                            crossAxisCount,
                            onSeeConfirmedDetails,
                          )
                        : RefreshIndicator(
                            onRefresh: () => provider.pullRefresh(),
                            child: provider.isLoading && requests.isEmpty
                                ? ListView(
                                    physics:
                                        const AlwaysScrollableScrollPhysics(),
                                    children: [
                                      SizedBox(
                                        height:
                                            MediaQuery.of(context).size.height *
                                            0.3,
                                        child: const Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      ),
                                    ],
                                  )
                                : provider.error != null && requests.isEmpty
                                    ? ListView(
                                        physics: const AlwaysScrollableScrollPhysics(),
                                        children: [
                                          SizedBox(
                                            height:
                                                MediaQuery.of(context)
                                                        .size
                                                        .height *
                                                0.3,
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(24),
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
                                        requests,
                                        crossAxisCount,
                                        itemCountForCard,
                                        profileType,
                                        provider,
                                        onSeeRequestDetails,
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

  Future<void> _openRequestDetails(
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
    ProfileType? profileType,
    String countLabel,
    String Function(PendingOrder) itemCountForCard,
    void Function(PendingOrder) onSeeRequestDetails,
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
          child: Text(
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
                  1,
                  onSeeConfirmedDetails,
                )
              : RefreshIndicator(
                  onRefresh: () => provider.pullRefresh(),
                  child: provider.isLoading && provider.requests.isEmpty
                      ? ListView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          children: [
                            SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.3,
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                          ],
                        )
                      : provider.error != null && provider.requests.isEmpty
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
                              provider.requests,
                              1,
                              itemCountForCard,
                              profileType,
                              provider,
                              onSeeRequestDetails,
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
        style: theme.textTheme.bodyLarge?.copyWith(
          color: AppColors.textMuted,
        ),
      ),
    );
  }

  Widget _buildRequestDetailPane(
    PendingOrder order,
    ProfileType? profileType,
    ReservationsProvider provider,
  ) {
    if (profileType == ProfileType.waiter) {
      return WaiterReservationRequestDetailsContent(
        order: order,
        onCompleted: () {
          setState(() => _selectedRequest = null);
          widget.onStartRefresh();
        },
      );
    }
    return KitchenBarReservationRequestDetailsContent(
      order: order,
      onCompleted: () {
        setState(() => _selectedRequest = null);
        widget.onStartRefresh();
      },
    );
  }

  Widget _buildRequestsList(
    BuildContext context,
    AppLocalizations l10n,
    List<PendingOrder> requests,
    int crossAxisCount,
    String Function(PendingOrder) itemCountForCard,
    ProfileType? profileType,
    ReservationsProvider provider,
    void Function(PendingOrder) onSeeDetails,
  ) {
    const padding = EdgeInsets.symmetric(horizontal: 20, vertical: 8);

    Widget buildCard(int index) {
      final order = requests[index];
      return ListItemEntrance(
        index: index,
        child: ReservationRequestCard(
          order: order,
          l10n: l10n,
          accentColor: widget.accentColor,
          itemCountLabel: itemCountForCard(order),
          showWaiterPendingLayout: profileType == ProfileType.waiter,
          onSeeDetails: () => onSeeDetails(order),
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
        mainAxisExtent: 230,
      ),
      itemCount: requests.length,
      itemBuilder: (context, index) => buildCard(index),
    );
  }

  Widget _buildConfirmedList(
    BuildContext context,
    AppLocalizations l10n,
    ConfirmedReservationsProvider confirmedProvider,
    int crossAxisCount,
    void Function(ConfirmedReservation) onSeeDetails,
  ) {
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

    final items = confirmedProvider.items;

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

    Widget buildCard(int index) {
      final reservation = items[index];
      return ListItemEntrance(
        index: index,
        child: ConfirmedReservationCard(
          reservation: reservation,
          l10n: l10n,
          accentColor: widget.accentColor,
          onSeeDetails: () => onSeeDetails(reservation),
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () => confirmedProvider.pullRefresh(),
      child: crossAxisCount == 1
          ? ListView.separated(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: padding,
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) => buildCard(index),
            )
          : GridView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: padding,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
                mainAxisExtent: 230,
              ),
              itemCount: items.length,
              itemBuilder: (context, index) => buildCard(index),
            ),
    );
  }
}
