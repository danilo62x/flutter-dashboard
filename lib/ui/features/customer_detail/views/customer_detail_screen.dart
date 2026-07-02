import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:dashboard/domain/models/customer.dart';
import 'package:dashboard/domain/models/order.dart';
import 'package:dashboard/ui/core/widgets/app_widgets.dart';
import 'package:dashboard/ui/features/customer_detail/view_models/customer_detail_view_model.dart';

/// Customer profile — contact data, lifetime metrics and order history.
class CustomerDetailScreen extends StatelessWidget {
  const CustomerDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CustomerDetailViewModel>();
    final customer = vm.customer;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perfil do cliente'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.edit_outlined)),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                _ProfileHeader(customer: customer),
                const SizedBox(height: 20),
                _MetricsRow(customer: customer),
                const SizedBox(height: 22),
                SectionHeader(title: 'Contato'),
                const SizedBox(height: 12),
                _ContactCard(customer: customer),
                const SizedBox(height: 22),
                SectionHeader(title: 'Histórico de pedidos'),
                const SizedBox(height: 12),
                _HistoryCard(orders: vm.orders),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return AppCard(
      child: Column(
        children: [
          InitialsAvatar(
            name: customer.name,
            radius: 36,
            background: scheme.primary,
            foreground: scheme.onPrimary,
          ),
          const SizedBox(height: 14),
          Text(
            customer.name,
            style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            customer.since,
            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          SegmentChip(segment: customer.segment),
        ],
      ),
    );
  }
}

class _MetricsRow extends StatelessWidget {
  const _MetricsRow({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatBox(value: '${customer.orders}', label: 'Pedidos'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(value: brl(customer.totalSpent), label: 'Total gasto'),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatBox(value: brl(customer.averageTicket), label: 'Ticket médio'),
        ),
      ],
    );
  }
}

class _StatBox extends StatelessWidget {
  const _StatBox({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      child: Column(
        children: [
          FittedBox(
            child: Text(
              value,
              style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
        ],
      ),
    );
  }
}

class _ContactCard extends StatelessWidget {
  const _ContactCard({required this.customer});

  final Customer customer;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        children: [
          _ContactTile(icon: Icons.email_outlined, label: customer.email),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _ContactTile(icon: Icons.phone_outlined, label: customer.phone),
          const Divider(height: 1, indent: 16, endIndent: 16),
          _ContactTile(icon: Icons.location_on_outlined, label: customer.city),
        ],
      ),
    );
  }
}

class _ContactTile extends StatelessWidget {
  const _ContactTile({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return ListTile(
      leading: Icon(icon, color: scheme.onSurfaceVariant),
      title: Text(label, style: text.bodyMedium),
      trailing: Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  const _HistoryCard({required this.orders});

  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    if (orders.isEmpty) {
      return AppCard(
        padding: const EdgeInsets.symmetric(vertical: 28),
        child: Column(
          children: [
            Icon(Icons.inbox_outlined, size: 40, color: scheme.onSurfaceVariant),
            const SizedBox(height: 10),
            Text(
              'Nenhum pedido ainda',
              style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
            ),
          ],
        ),
      );
    }

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Column(
        children: [
          for (var i = 0; i < orders.length; i++) ...[
            if (i > 0) const Divider(indent: 16, endIndent: 16),
            OrderTile(
              order: orders[i],
              showChevron: true,
              onTap: () => context.push('/orders/${orders[i].id}'),
            ),
          ],
        ],
      ),
    );
  }
}
