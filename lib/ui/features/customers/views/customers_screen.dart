import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:dashboard/domain/models/customer.dart';
import 'package:dashboard/ui/core/widgets/app_widgets.dart';
import 'package:dashboard/ui/features/customers/view_models/customers_view_model.dart';

/// Customers — searchable list with segment filters and quick stats.
class CustomersScreen extends StatelessWidget {
  const CustomersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CustomersViewModel>();
    final customers = vm.customers;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Clientes'),
        actions: [
          IconButton(onPressed: () {}, icon: const Icon(Icons.person_add_alt_1_outlined)),
          const SizedBox(width: 4),
        ],
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
                      Row(
                        children: [
                          Expanded(
                            child: _MiniStat(
                              icon: Icons.group_outlined,
                              value: '${vm.total}',
                              label: 'Clientes',
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _MiniStat(
                              icon: Icons.workspace_premium_outlined,
                              value: '${vm.vipCount}',
                              label: 'VIP',
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      SearchField(
                        hint: 'Buscar por nome ou cidade',
                        onChanged: vm.setQuery,
                      ),
                      const SizedBox(height: 14),
                      _SegmentFilters(
                        selected: vm.segmentFilter,
                        onSelected: vm.setSegmentFilter,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
                    itemCount: customers.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 10),
                    itemBuilder: (context, i) => AppCard(
                      padding: EdgeInsets.zero,
                      onTap: () => context.push('/customers/${customers[i].id}'),
                      child: CustomerTile(customer: customers[i]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }
}

class _MiniStat extends StatelessWidget {
  const _MiniStat({required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    return AppCard(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: scheme.primaryContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: scheme.onPrimaryContainer),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              Text(
                label,
                style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SegmentFilters extends StatelessWidget {
  const _SegmentFilters({required this.selected, required this.onSelected});

  final CustomerSegment? selected;
  final ValueChanged<CustomerSegment?> onSelected;

  static const List<(String, CustomerSegment?)> _filters =
      <(String, CustomerSegment?)>[
    ('Todos', null),
    ('VIP', CustomerSegment.vip),
    ('Ativos', CustomerSegment.active),
    ('Novos', CustomerSegment.newcomer),
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
          final (label, segment) = _filters[i];
          return ChoiceChip(
            label: Text(label),
            selected: selected == segment,
            onSelected: (_) => onSelected(segment),
          );
        },
      ),
    );
  }
}
