import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dashboard/core/theme.dart';
import 'package:dashboard/domain/models/analytics.dart';
import 'package:dashboard/ui/core/widgets/app_widgets.dart';
import 'package:dashboard/ui/features/analytics/view_models/analytics_view_model.dart';

/// Analytics — period filters, summary KPIs and hand-drawn charts.
class AnalyticsScreen extends StatelessWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AnalyticsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.file_download_outlined),
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
              children: [
                _PeriodChips(
                  periods: vm.periods,
                  selected: vm.periodIndex,
                  onSelected: vm.selectPeriod,
                ),
                const SizedBox(height: 20),
                _SummaryGrid(vm: vm),
                const SizedBox(height: 22),
                _RevenueCard(values: vm.revenueSeries, months: vm.months),
                const SizedBox(height: 20),
                _OrdersCard(values: vm.weeklyOrders, days: vm.weekDays),
                const SizedBox(height: 20),
                _ChannelsCard(channels: vm.channels),
                const SizedBox(height: 20),
                _TopProductsCard(products: vm.topProducts),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PeriodChips extends StatelessWidget {
  const _PeriodChips({
    required this.periods,
    required this.selected,
    required this.onSelected,
  });

  final List<String> periods;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: periods.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) => ChoiceChip(
          label: Text(periods[i]),
          selected: selected == i,
          onSelected: (_) => onSelected(i),
        ),
      ),
    );
  }
}

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({required this.vm});

  final AnalyticsViewModel vm;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 680 ? 4 : 2;
        const spacing = 14.0;
        final cardWidth = (width - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final metric in vm.summary)
              SizedBox(width: cardWidth, child: MetricCard(metric: metric)),
          ],
        );
      },
    );
  }
}

class _RevenueCard extends StatelessWidget {
  const _RevenueCard({required this.values, required this.months});

  final List<double> values;
  final List<String> months;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Receita por mês',
                    style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Acumulado de R\$ 128,4k',
                    style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                  ),
                ],
              ),
              const DeltaLabel(delta: 18),
            ],
          ),
          const SizedBox(height: 18),
          LineChart(values: values),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final m in months)
                Expanded(
                  child: Center(
                    child: Text(
                      m,
                      style: text.labelSmall?.copyWith(
                        color: scheme.onSurfaceVariant,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OrdersCard extends StatelessWidget {
  const _OrdersCard({required this.values, required this.days});

  final List<double> values;
  final List<String> days;

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Pedidos por dia',
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 20),
          BarChartBars(values: values, labels: days),
        ],
      ),
    );
  }
}

class _ChannelsCard extends StatelessWidget {
  const _ChannelsCard({required this.channels});

  final List<ChannelShare> channels;

  static const List<Color> _palette = <Color>[
    Color(0xFF0E7C66),
    Color(0xFF1D4ED8),
    Color(0xFF9333EA),
    Color(0xFFB45309),
  ];

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Vendas por canal',
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              DonutChart(
                segments: [
                  for (var i = 0; i < channels.length; i++)
                    DonutSegment(channels[i].share, _palette[i % _palette.length]),
                ],
                centerValue: '100%',
                centerLabel: 'vendas',
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  children: [
                    for (var i = 0; i < channels.length; i++)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Row(
                          children: [
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _palette[i % _palette.length],
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                channels[i].name,
                                style: text.bodyMedium,
                              ),
                            ),
                            Text(
                              '${(channels[i].share * 100).round()}%',
                              style: text.bodyMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: scheme.onSurface,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TopProductsCard extends StatelessWidget {
  const _TopProductsCard({required this.products});

  final List<ProductStat> products;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Produtos mais vendidos',
            style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          for (var i = 0; i < products.length; i++) ...[
            if (i > 0) const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text(
                    products[i].name,
                    style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                  ),
                ),
                Text(
                  '${products[i].units} un · ${products[i].revenue}',
                  style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: products[i].progress,
                minHeight: 8,
                backgroundColor: scheme.surfaceContainerHighest.withValues(alpha: 0.6),
                valueColor: AlwaysStoppedAnimation<Color>(
                  Color.lerp(scheme.primary, AppTheme.info, i / products.length)!,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
