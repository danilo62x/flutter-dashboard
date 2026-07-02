import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:dashboard/domain/models/order.dart';
import 'package:dashboard/ui/core/widgets/app_widgets.dart';
import 'package:dashboard/ui/features/orders/view_models/orders_view_model.dart';

/// Orders — searchable, status-filterable list of every order.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrdersViewModel>();
    final orders = vm.orders;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.tune_rounded)),
          const SizedBox(width: 4),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {},
        icon: const Icon(Icons.add_rounded),
        label: const Text('Novo'),
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 12),
                  child: Column(
                    children: [
                      SearchField(
                        hint: 'Buscar por cliente ou número',
                        onChanged: vm.setQuery,
                      ),
                      const SizedBox(height: 14),
                      _StatusFilters(
                        selected: vm.statusFilter,
                        onSelected: vm.setStatusFilter,
                      ),
                      const SizedBox(height: 14),
                      _OrdersSummary(count: orders.length, paid: vm.totalPaid),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 96),
                    itemCount: orders.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => AppCard(
                      padding: EdgeInsets.zero,
                      onTap: () => context.push('/orders/${orders[i].id}'),
                      child: OrderTile(order: orders[i], showChevron: true),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 1),
    );
  }
}

class _StatusFilters extends StatelessWidget {
  const _StatusFilters({required this.selected, required this.onSelected});

  final OrderStatus? selected;
  final ValueChanged<OrderStatus?> onSelected;

  static const List<(String, OrderStatus?)> _filters = <(String, OrderStatus?)>[
    ('Todos', null),
    ('Pago', OrderStatus.paid),
    ('Pendente', OrderStatus.pending),
    ('Enviado', OrderStatus.shipped),
    ('Cancelado', OrderStatus.cancelled),
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _filters.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final (label, status) = _filters[i];
          return ChoiceChip(
            label: Text(label),
            selected: selected == status,
            onSelected: (_) => onSelected(status),
          );
        },
      ),
    );
  }
}

class _OrdersSummary extends StatelessWidget {
  const _OrdersSummary({required this.count, required this.paid});

  final int count;
  final double paid;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(
          '$count pedidos',
          style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const Spacer(),
        Icon(Icons.check_circle_outline_rounded, size: 16, color: scheme.primary),
        const SizedBox(width: 4),
        Text(
          '${brl(paid)} recebidos',
          style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
        ),
      ],
    );
  }
}
