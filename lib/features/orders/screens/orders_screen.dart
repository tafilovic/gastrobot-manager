import 'package:flutter/material.dart';

import '../models/order.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static const _dummyOrders = [
    Order(id: 'P207U', tableNumber: 15, dishCount: 3, timeAgo: 'Pre 1 minut'),
    Order(id: 'P208N', tableNumber: 13, dishCount: 2, timeAgo: 'Pre 1 minut'),
    Order(id: 'P209N', tableNumber: 15, dishCount: 4, timeAgo: 'Pre 30 sekundi'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 24, 20, 8),
              child: Text(
                'Porudžbine',
                style: theme.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF333333),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                '${_dummyOrders.length} porudžbine',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF757575),
                ),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                itemCount: _dummyOrders.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final order = _dummyOrders[index];
                  return _OrderCard(
                    order: order,
                    accentColor: accentColor,
                    onSeeDetails: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({
    required this.order,
    required this.accentColor,
    required this.onSeeDetails,
  });

  final Order order;
  final Color accentColor;
  final VoidCallback onSeeDetails;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  order.timeAgo,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF333333),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.table_restaurant, size: 18, color: Colors.grey[600]),
                const SizedBox(width: 8),
                Text(
                  'Sto broj ${order.tableNumber}',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF333333),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '#${order.id}',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: accentColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Broj jela: ${order.dishCount}',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF333333),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: onSeeDetails,
                style: OutlinedButton.styleFrom(
                  foregroundColor: accentColor,
                  side: BorderSide(color: accentColor),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
                child: const Text('VIDI DETALJE'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
