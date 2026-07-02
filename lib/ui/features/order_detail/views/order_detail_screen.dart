import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dashboard/domain/models/order.dart';
import 'package:dashboard/ui/core/widgets/app_widgets.dart';
import 'package:dashboard/ui/features/order_detail/view_models/order_detail_view_model.dart';

/// Order detail — status timeline, customer, items and totals.
class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OrderDetailViewModel>();
    final order = vm.order;

    return Scaffold(
      appBar: AppBar(title: Text('Pedido #${order.id}')),
      bottomNavigationBar: _CheckoutBar(total: order.amount),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 900),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                _StatusBanner(status: order.status, date: order.date),
                const SizedBox(height: 20),
                SectionHeader(title: 'Acompanhamento'),
                const SizedBox(height: 12),
                AppCard(child: _Timeline(steps: vm.timeline)),
                const SizedBox(height: 22),
                SectionHeader(title: 'Cliente'),
                const SizedBox(height: 12),
                _CustomerCard(order: order),
                const SizedBox(height: 22),
                SectionHeader(title: 'Itens (${order.items.length})'),
                const SizedBox(height: 12),
                _ItemsCard(order: order),
                const SizedBox(height: 22),
                SectionHeader(title: 'Resumo'),
                const SizedBox(height: 12),
                _TotalsCard(order: order),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.status, required this.date});

  final OrderStatus status;
  final String date;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return AppCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(Icons.receipt_long_rounded, color: scheme.onPrimaryContainer),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Realizado em $date',
                  style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                Text(
                  'Situação atual',
                  style: text.labelMedium?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
          StatusChip(status: status),
        ],
      ),
    );
  }
}

class _Timeline extends StatelessWidget {
  const _Timeline({required this.steps});

  final List<OrderStep> steps;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Column(
      children: [
        for (var i = 0; i < steps.length; i++)
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  children: [
                    Container(
                      width: 22,
                      height: 22,
                      decoration: BoxDecoration(
                        color: steps[i].done ? scheme.primary : scheme.surfaceContainerHighest,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        steps[i].done ? Icons.check_rounded : Icons.circle_outlined,
                        size: 14,
                        color: steps[i].done ? scheme.onPrimary : scheme.onSurfaceVariant,
                      ),
                    ),
                    if (i != steps.length - 1)
                      Expanded(
                        child: Container(
                          width: 2,
                          color: steps[i].done
                              ? scheme.primary.withValues(alpha: 0.4)
                              : scheme.outlineVariant.withValues(alpha: 0.5),
                        ),
                      ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(bottom: i == steps.length - 1 ? 0 : 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          steps[i].label,
                          style: text.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: steps[i].done ? scheme.onSurface : scheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          steps[i].time,
                          style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _CustomerCard extends StatelessWidget {
  const _CustomerCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return AppCard(
      child: Column(
        children: [
          Row(
            children: [
              InitialsAvatar(name: order.customer, radius: 24),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.customer,
                      style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.channel,
                      style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right_rounded, color: scheme.onSurfaceVariant),
            ],
          ),
          const Divider(height: 24),
          _InfoRow(icon: Icons.credit_card_outlined, label: 'Pagamento', value: order.paymentMethod),
          const SizedBox(height: 10),
          _InfoRow(icon: Icons.local_shipping_outlined, label: 'Envio', value: order.channel),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: scheme.onSurfaceVariant),
        const SizedBox(width: 10),
        Text(label, style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
        const Spacer(),
        Text(value, style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _ItemsCard extends StatelessWidget {
  const _ItemsCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return AppCard(
      child: Column(
        children: [
          for (var i = 0; i < order.items.length; i++) ...[
            if (i > 0) const Divider(height: 24),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: scheme.secondaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.inventory_2_outlined,
                      size: 20, color: scheme.onSecondaryContainer),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.items[i].name,
                        style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${order.items[i].quantity} × ${brl(order.items[i].price)}',
                        style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                      ),
                    ],
                  ),
                ),
                Text(
                  brl(order.items[i].lineTotal),
                  style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _TotalsCard extends StatelessWidget {
  const _TotalsCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return AppCard(
      child: Column(
        children: [
          _totalRow(context, 'Subtotal', brl(order.subtotal)),
          const SizedBox(height: 8),
          _totalRow(context, 'Frete', brl(order.shipping)),
          if (order.discount > 0) ...[
            const SizedBox(height: 8),
            _totalRow(context, 'Desconto', '- ${brl(order.discount)}'),
          ],
          const Divider(height: 24),
          Row(
            children: [
              Text(
                'Total',
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const Spacer(),
              Text(
                brl(order.amount),
                style: text.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: scheme.primary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _totalRow(BuildContext context, String label, String value) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return Row(
      children: [
        Text(label, style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
        const Spacer(),
        Text(value, style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _CheckoutBar extends StatelessWidget {
  const _CheckoutBar({required this.total});

  final double total;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(20, 8, 20, 12),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Total', style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
              Text(
                brl(total),
                style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.local_shipping_outlined),
              label: const Text('Atualizar status'),
            ),
          ),
        ],
      ),
    );
  }
}
