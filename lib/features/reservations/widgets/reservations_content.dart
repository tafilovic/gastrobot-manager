import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:gastrobotmanager/core/layout/constrained_content.dart';
import 'package:gastrobotmanager/core/models/profile_type.dart';
import 'package:gastrobotmanager/core/navigation/fade_slide_page_route.dart';
import 'package:gastrobotmanager/core/theme/app_colors.dart';
import 'package:gastrobotmanager/core/widgets/list_item_entrance.dart';
import 'package:gastrobotmanager/features/orders/domain/models/pending_order.dart';
import 'package:gastrobotmanager/features/auth/providers/auth_provider.dart';
import 'package:gastrobotmanager/features/reservations/providers/confirmed_reservations_provider.dart';
import 'package:gastrobotmanager/features/reservations/providers/reservations_provider.dart';
import 'package:gastrobotmanager/features/reservations/screens/confirmed_reservation_details_screen.dart';
import 'package:gastrobotmanager/features/reservations/screens/reservation_details_screen.dart';
import 'package:gastrobotmanager/features/reservations/widgets/confirmed_reservation_card.dart';
import 'package:gastrobotmanager/features/reservations/widgets/reservation_request_card.dart';
import 'package:gastrobotmanager/l10n/generated/app_localizations.dart';

/// Reservations screen content: title, tabs (Zahtevi / Prihvaćeno), count, list of request cards.
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

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onStartRefresh());
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

    final isBar = profileType == ProfileType.bar || profileType == ProfileType.waiter;
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

    return Scaffold(
      backgroundColor: AppColors.backgroundMuted,
      body: SafeArea(
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
                      onSelectionChanged: (Set<int> selected) {
                        final idx = selected.first;
                        setState(() => _selectedTabIndex = idx);
                        if (context.mounted) {
                          final venueId =
                              context.read<AuthProvider>().currentVenueId;
                          if (idx == 0 && profileType == ProfileType.waiter) {
                            context.read<ReservationsProvider>().pullRefresh();
                          } else if (idx == 1 &&
                              profileType == ProfileType.waiter &&
                              venueId != null) {
                            context
                                .read<ConfirmedReservationsProvider>()
                                .load(venueId);
                          }
                        }
                      },
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
              child: ConstrainedContent(
                padding: EdgeInsets.zero,
                child: _selectedTabIndex == 1
                    ? _buildConfirmedList(
                        context,
                        l10n,
                        confirmedProvider,
                      )
                    : RefreshIndicator(
                      onRefresh: () => provider.pullRefresh(),
                      child: provider.isLoading && requests.isEmpty
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
                          : provider.error != null && requests.isEmpty
                              ? ListView(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  children: [
                                    SizedBox(
                                      height: MediaQuery.of(context).size.height * 0.3,
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(24),
                                          child: Text(
                                            provider.error!,
                                            textAlign: TextAlign.center,
                                            style: const TextStyle(color: AppColors.error),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : ListView.separated(
                                  physics: const AlwaysScrollableScrollPhysics(),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 20,
                                    vertical: 8,
                                  ),
                                  itemCount: requests.length,
                                  separatorBuilder: (_, __) =>
                                      const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final order = requests[index];
                                    return ListItemEntrance(
                                      index: index,
                                      child: ReservationRequestCard(
                                        order: order,
                                        l10n: l10n,
                                        accentColor: widget.accentColor,
                                        itemCountLabel: itemCountForCard(order),
                                        showWaiterPendingLayout:
                                            profileType == ProfileType.waiter,
                                        onSeeDetails: () async {
                                          final completed =
                                              await Navigator.of(context).push<bool>(
                                            FadeSlidePageRoute<bool>(
                                              builder: (_) =>
                                                  ReservationDetailsScreen(
                                                order: order,
                                              ),
                                            ),
                                          );
                                          if (completed == true &&
                                              context.mounted) {
                                            provider.pullRefresh();
                                          }
                                        },
                                      ),
                                    );
                                  },
                                ),
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmedList(
    BuildContext context,
    AppLocalizations l10n,
    ConfirmedReservationsProvider confirmedProvider,
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

    return RefreshIndicator(
      onRefresh: () => confirmedProvider.pullRefresh(),
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final reservation = items[index];
          return ListItemEntrance(
            index: index,
              child: ConfirmedReservationCard(
              reservation: reservation,
              l10n: l10n,
              accentColor: widget.accentColor,
              onSeeDetails: () {
                Navigator.of(context).push<void>(
                  FadeSlidePageRoute<void>(
                    builder: (_) => ConfirmedReservationDetailsScreen(
                      reservation: reservation,
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
