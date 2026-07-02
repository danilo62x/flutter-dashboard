import 'package:flutter/foundation.dart';

import 'package:dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/domain/models/analytics.dart';
import 'package:dashboard/domain/models/metric.dart';

/// Presentation state for the analytics screen.
class AnalyticsViewModel extends ChangeNotifier {
  AnalyticsViewModel({required DashboardRepository repository})
      : _repository = repository {
    summary = _repository.seedAnalyticsSummary();
    revenueSeries = _repository.seedRevenueSeries();
    months = _repository.seedMonths();
    weeklyOrders = _repository.seedWeeklyOrders();
    weekDays = _repository.seedWeekDays();
    channels = _repository.seedChannels();
    topProducts = _repository.seedTopProducts();
  }

  final DashboardRepository _repository;

  late List<Metric> summary;
  late List<double> revenueSeries;
  late List<String> months;
  late List<double> weeklyOrders;
  late List<String> weekDays;
  late List<ChannelShare> channels;
  late List<ProductStat> topProducts;

  final List<String> periods = const <String>['7 dias', '30 dias', '90 dias', '12 meses'];

  int _periodIndex = 1;
  int get periodIndex => _periodIndex;

  void selectPeriod(int index) {
    if (index == _periodIndex) return;
    _periodIndex = index;
    notifyListeners();
  }
}
