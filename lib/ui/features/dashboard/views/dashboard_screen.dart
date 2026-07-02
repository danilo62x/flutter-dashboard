import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:dashboard/domain/models/metric.dart';
import 'package:dashboard/domain/models/order.dart';
import 'package:dashboard/ui/core/widgets/app_widgets.dart';
import 'package:dashboard/ui/features/dashboard/view_models/dashboard_view_model.dart';

/// Overview — KPIs, weekly sales, revenue trend and the latest orders.
class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<DashboardViewModel>();

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _Header(name: vm.greetingName, subtitle: vm.subtitle),
                  const SizedBox(height: 24),
                  _MetricsGrid(metrics: vm.metrics),
                  const SizedBox(height: 20),
                  _WideRow(
                    left: _WeeklySalesCard(values: vm.weeklySales, days: vm.weekDays),
                    right: _RevenueTrendCard(values: vm.revenueSeries),
                  ),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'Últimos pedidos',
                    action: 'Ver todos',
                    onAction: () => context.go('/orders'),
                  ),
                  const SizedBox(height: 12),
                  _OrdersCard(orders: vm.orders),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}

/// Stacks two cards on phones, places them side by side on wide screens.
class _WideRow extends StatelessWidget {
  const _WideRow({required this.left, required this.right});

  final Widget left;
  final Widget right;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 720) {
          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: left),
              const SizedBox(width: 20),
              Expanded(child: right),
            ],
          );
        }
        return Column(children: [left, const SizedBox(height: 20), right]);
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.name, required this.subtitle});

  final String name;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Olá, $name',
                style: text.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
        IconBadgeButton(
          icon: Icons.notifications_outlined,
          showDot: true,
          onTap: () => context.push('/notifications'),
        ),
        const SizedBox(width: 12),
        CircleAvatar(
          radius: 24,
          backgroundColor: scheme.primary,
          child: Text(
            'AS',
            style: text.titleMedium?.copyWith(
              color: scheme.onPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}

class _MetricsGrid extends StatelessWidget {
  const _MetricsGrid({required this.metrics});

  final List<Metric> metrics;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1000
            ? 4
            : width >= 680
                ? 3
                : 2;
        const spacing = 14.0;
        final cardWidth = (width - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final metric in metrics)
              SizedBox(width: cardWidth, child: MetricCard(metric: metric)),
          ],
        );
      },
    );
  }
}

class _WeeklySalesCard extends StatelessWidget {
  const _WeeklySalesCard({required this.values, required this.days});

  final List<double> values;
  final List<String> days;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return AppCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Vendas na semana',
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              Text(
                'R\$ 12,9k',
                style: text.titleMedium?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          BarChartBars(values: values, labels: days),
        ],
      ),
    );
  }
}

class _RevenueTrendCard extends StatelessWidget {
  const _RevenueTrendCard({required this.values});

  final List<double> values;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;

    return AppCard(
      padding: const EdgeInsets.fromLTRB(18, 18, 18, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Receita (6 meses)',
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const DeltaLabel(delta: 18),
            ],
          ),
          const SizedBox(height: 16),
          LineChart(values: values, height: 132),
        ],
      ),
    );
  }
}

class _OrdersCard extends StatelessWidget {
  const _OrdersCard({required this.orders});

  final List<Order> orders;

  @override
  Widget build(BuildContext context) {
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
