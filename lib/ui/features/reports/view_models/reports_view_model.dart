import 'package:flutter/foundation.dart';

import 'package:dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/domain/models/report.dart';

/// Presentation state for the reports screen.
class ReportsViewModel extends ChangeNotifier {
  ReportsViewModel({required DashboardRepository repository})
      : _repository = repository {
    reports = _repository.seedReports();
    rows = _repository.seedReportRows();
    revenueSeries = _repository.seedRevenueSeries();
    months = _repository.seedMonths();
  }

  final DashboardRepository _repository;

  late List<Report> reports;
  late List<ReportRow> rows;
  late List<double> revenueSeries;
  late List<String> months;

  final List<String> periods = const <String>['Semana', 'Mês', 'Trimestre', 'Ano'];

  int _periodIndex = 1;
  int get periodIndex => _periodIndex;

  void selectPeriod(int index) {
    if (index == _periodIndex) return;
    _periodIndex = index;
    notifyListeners();
  }
}
