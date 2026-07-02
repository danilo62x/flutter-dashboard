import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:dashboard/core/theme.dart';
import 'package:dashboard/domain/models/app_notification.dart';
import 'package:dashboard/ui/core/widgets/app_widgets.dart';
import 'package:dashboard/ui/features/notifications/view_models/notifications_view_model.dart';

/// Notifications — grouped activity feed with tonal icons and timestamps.
class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<NotificationsViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notificações'),
        actions: [
          TextButton(
            onPressed: vm.markAllRead,
            child: const Text('Marcar lidas'),
          ),
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
                _UnreadBanner(unread: vm.unreadCount),
                const SizedBox(height: 20),
                for (final group in vm.groups) ...[
                  Padding(
                    padding: const EdgeInsets.only(left: 4, bottom: 10),
                    child: SectionHeader(title: group),
                  ),
                  AppCard(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      children: [
                        for (var i = 0; i < vm.itemsForGroup(group).length; i++) ...[
                          if (i > 0) const Divider(height: 1, indent: 68, endIndent: 8),
                          _NotificationRow(item: vm.itemsForGroup(group)[i]),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _UnreadBanner extends StatelessWidget {
  const _UnreadBanner({required this.unread});

  final int unread;

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
            child: Icon(Icons.notifications_active_outlined,
                color: scheme.onPrimaryContainer),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  unread > 0 ? '$unread não lidas' : 'Tudo em dia',
                  style: text.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 2),
                Text(
                  'Pedidos, pagamentos e alertas de estoque',
                  style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NotificationRow extends StatelessWidget {
  const _NotificationRow({required this.item});

  final AppNotification item;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final text = Theme.of(context).textTheme;
    final (icon, color) = _visual(item.kind);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(13),
            ),
            child: Icon(icon, color: color, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        item.title,
                        style: text.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    if (item.unread)
                      Container(
                        width: 8,
                        height: 8,
                        margin: const EdgeInsets.only(left: 6, top: 4),
                        decoration: BoxDecoration(
                          color: scheme.primary,
                          shape: BoxShape.circle,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item.message,
                  style: text.bodySmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
                const SizedBox(height: 4),
                Text(
                  item.time,
                  style: text.labelSmall?.copyWith(color: scheme.onSurfaceVariant),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  (IconData, Color) _visual(NotificationKind kind) {
    return switch (kind) {
      NotificationKind.order => (Icons.shopping_bag_outlined, AppTheme.info),
      NotificationKind.payment => (Icons.payments_outlined, AppTheme.positive),
      NotificationKind.alert => (Icons.warning_amber_rounded, AppTheme.warning),
      NotificationKind.customer => (Icons.person_add_alt_1_outlined, const Color(0xFF9333EA)),
      NotificationKind.system => (Icons.settings_suggest_outlined, AppTheme.negative),
    };
  }
}
