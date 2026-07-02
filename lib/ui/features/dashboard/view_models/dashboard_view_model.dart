import 'package:flutter/foundation.dart';

import 'package:dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/domain/models/metric.dart';
import 'package:dashboard/domain/models/order.dart';

/// Presentation state for the overview screen (MVVM).
///
/// The lists are seeded synchronously in the constructor so the first frame
/// already has content. Call [refresh] to model the real async fetch path.
class DashboardViewModel extends ChangeNotifier {
  DashboardViewModel({required DashboardRepository repository})
      : _repository = repository {
    _metrics = _repository.seedMetrics();
    _orders = _repository.seedOrders().take(4).toList();
    weeklySales = _repository.seedWeeklyOrders();
    weekDays = _repository.seedWeekDays();
    revenueSeries = _repository.seedRevenueSeries().sublist(6);
  }

  final DashboardRepository _repository;

  late List<Metric> _metrics;
  List<Metric> get metrics => List<Metric>.unmodifiable(_metrics);

  late List<Order> _orders;
  List<Order> get orders => List<Order>.unmodifiable(_orders);

  late List<double> weeklySales;
  late List<String> weekDays;
  late List<double> revenueSeries;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final String greetingName = 'Ana';
  final String subtitle = 'Resumo de hoje';

  Future<void> refresh() async {
    _isLoading = true;
    notifyListeners();
    try {
      _metrics = await _repository.fetchMetrics();
      _orders = (await _repository.fetchOrders()).take(4).toList();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
