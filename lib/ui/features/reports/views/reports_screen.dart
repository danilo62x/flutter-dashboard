import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dashboard/core/theme.dart';
import 'package:dashboard/domain/models/report.dart';
import 'package:dashboard/ui/core/widgets/app_widgets.dart';
import 'package:dashboard/ui/features/reports/view_models/reports_view_model.dart';

/// Reports — report cards with sparklines and a comparison summary table.
class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ReportsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Relatórios'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.download_outlined)),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
              children: [
                _PeriodChips(
                  periods: vm.periods,
                  selected: vm.periodIndex,
                  onSelected: vm.selectPeriod,
                ),
                const SizedBox(height: 20),
                _ReportGrid(reports: vm.reports),
                const SizedBox(height: 22),
                SectionHeader(title: 'Resumo comparativo'),
                const SizedBox(height: 12),
                _SummaryTable(rows: vm.rows),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
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

class _ReportGrid extends StatelessWidget {
  const _ReportGrid({required this.reports});

  final List<Report> reports;

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
            for (final report in reports)
              SizedBox(width: cardWidth, child: _ReportCard(report: report)),
          ],
        );
      },
    );
  }
}

class _ReportCard extends StatelessWidget {
  const _ReportCard({required this.report});

  final Report report;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final color = report.isPositive ? AppTheme.positive : AppTheme.negative;

    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: scheme.primaryContainer,
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(iconForKey(report.iconKey),
                    size: 19, color: scheme.onPrimaryContainer),
              ),
              const Spacer(),
              DeltaLabel(delta: report.deltaPercent),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            report.value,
            style: text.titleLarge?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 2),
          Text(
            report.title,
            style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(
            report.subtitle,
            style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          Sparkline(values: report.spark, color: color),
        ],
      ),
    );
  }
}

class _SummaryTable extends StatelessWidget {
  const _SummaryTable({required this.rows});

  final List<ReportRow> rows;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;

    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 4,
                  child: Text('Métrica', style: _head(text, scheme)),
                ),
                Expanded(
                  flex: 3,
                  child: Text('Atual', textAlign: TextAlign.end, style: _head(text, scheme)),
                ),
                Expanded(
                  flex: 3,
                  child: Text('Anterior', textAlign: TextAlign.end, style: _head(text, scheme)),
                ),
                Expanded(
                  flex: 2,
                  child: Text('Var.', textAlign: TextAlign.end, style: _head(text, scheme)),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          for (final row in rows)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Row(
                children: [
                  Expanded(
                    flex: 4,
                    child: Text(
                      row.label,
                      style: text.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(row.current, textAlign: TextAlign.end, style: text.bodyMedium),
                  ),
                  Expanded(
                    flex: 3,
                    child: Text(
                      row.previous,
                      textAlign: TextAlign.end,
                      style: text.bodyMedium?.copyWith(color: scheme.onSurfaceVariant),
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Text(
                      '${row.isPositive ? '+' : ''}${row.deltaPercent}%',
                      textAlign: TextAlign.end,
                      style: text.bodySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: row.isPositive ? AppTheme.positive : AppTheme.negative,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  TextStyle? _head(TextTheme text, ColorScheme scheme) =>
      text.labelMedium?.copyWith(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w700);
}
