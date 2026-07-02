import 'package:flutter/foundation.dart';

import 'package:dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/domain/models/customer.dart';
import 'package:dashboard/domain/models/order.dart';

/// Presentation state for a single customer's profile screen.
class CustomerDetailViewModel extends ChangeNotifier {
  CustomerDetailViewModel({
    required DashboardRepository repository,
    required String customerId,
  }) : _customer = repository.customerById(customerId) {
    _orders = repository.ordersForCustomer(_customer.name);
  }

  final Customer _customer;
  Customer get customer => _customer;

  late List<Order> _orders;
  List<Order> get orders => List<Order>.unmodifiable(_orders);
}
