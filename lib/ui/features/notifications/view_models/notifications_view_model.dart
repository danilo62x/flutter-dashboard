import 'package:flutter/foundation.dart';

import 'package:dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/domain/models/app_notification.dart';

/// Presentation state for the notifications screen.
class NotificationsViewModel extends ChangeNotifier {
  NotificationsViewModel({required DashboardRepository repository})
      : _repository = repository {
    _items = _repository.seedNotifications();
  }

  final DashboardRepository _repository;

  late List<AppNotification> _items;
  List<AppNotification> get items => List<AppNotification>.unmodifiable(_items);

  int get unreadCount => _items.where((n) => n.unread).length;

  /// Ordered section labels present in the list.
  List<String> get groups {
    final seen = <String>[];
    for (final n in _items) {
      if (!seen.contains(n.group)) seen.add(n.group);
    }
    return seen;
  }

  List<AppNotification> itemsForGroup(String group) =>
      _items.where((n) => n.group == group).toList();

  void markAllRead() {
    _items = <AppNotification>[
      for (final n in _items)
        AppNotification(
          title: n.title,
          message: n.message,
          time: n.time,
          kind: n.kind,
          group: n.group,
        ),
    ];
    notifyListeners();
  }
}
