/// Category of a notification, mapped to an icon/color in the UI layer.
enum NotificationKind { order, payment, alert, system, customer }

/// Clean domain model for an in-app notification / activity event.
class AppNotification {
  const AppNotification({
    required this.title,
    required this.message,
    required this.time,
    required this.kind,
    required this.group,
    this.unread = false,
  });

  final String title;
  final String message;

  /// Short relative label, e.g. `há 5 min`.
  final String time;
  final NotificationKind kind;

  /// Section label, e.g. `Hoje`, `Ontem`, `Esta semana`.
  final String group;
  final bool unread;
}
