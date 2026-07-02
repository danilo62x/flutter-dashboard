/// Commercial segment used to group customers.
enum CustomerSegment { vip, active, newcomer }

/// Clean domain model for a customer, consumed by the UI layer.
class Customer {
  const Customer({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.orders,
    required this.totalSpent,
    required this.segment,
    required this.since,
    this.lastOrder = '',
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String city;

  /// Number of completed orders.
  final int orders;

  /// Lifetime value in BRL.
  final double totalSpent;
  final CustomerSegment segment;

  /// Short label, e.g. `Cliente desde 2023`.
  final String since;

  /// Short label for the most recent order date.
  final String lastOrder;

  /// Average ticket in BRL.
  double get averageTicket => orders == 0 ? 0 : totalSpent / orders;
}
