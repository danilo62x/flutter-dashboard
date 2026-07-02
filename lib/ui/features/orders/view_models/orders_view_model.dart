import 'package:flutter/foundation.dart';

import 'package:dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/domain/models/order.dart';

/// Presentation state for the orders list (search + status filter).
class OrdersViewModel extends ChangeNotifier {
  OrdersViewModel({required DashboardRepository repository})
      : _repository = repository {
    _all = _repository.seedOrders();
  }

  final DashboardRepository _repository;

  late List<Order> _all;

  /// `null` means "all statuses".
  OrderStatus? _statusFilter;
  OrderStatus? get statusFilter => _statusFilter;

  String _query = '';
  String get query => _query;

  List<Order> get orders {
    return _all.where((o) {
      final matchesStatus = _statusFilter == null || o.status == _statusFilter;
      final matchesQuery = _query.isEmpty ||
          o.customer.toLowerCase().contains(_query.toLowerCase()) ||
          o.id.contains(_query);
      return matchesStatus && matchesQuery;
    }).toList();
  }

  int get total => _all.length;

  double get totalPaid => _all
      .where((o) => o.status == OrderStatus.paid)
      .fold<double>(0, (sum, o) => sum + o.amount);

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setStatusFilter(OrderStatus? status) {
    _statusFilter = status;
    notifyListeners();
  }
}
