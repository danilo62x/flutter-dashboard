import 'package:flutter/foundation.dart';

import 'package:dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/domain/models/customer.dart';

/// Presentation state for the customers list (search + segment filter).
class CustomersViewModel extends ChangeNotifier {
  CustomersViewModel({required DashboardRepository repository})
      : _repository = repository {
    _all = _repository.seedCustomers();
  }

  final DashboardRepository _repository;

  late List<Customer> _all;

  /// `null` means "all segments".
  CustomerSegment? _segmentFilter;
  CustomerSegment? get segmentFilter => _segmentFilter;

  String _query = '';
  String get query => _query;

  List<Customer> get customers {
    return _all.where((c) {
      final matchesSegment = _segmentFilter == null || c.segment == _segmentFilter;
      final matchesQuery = _query.isEmpty ||
          c.name.toLowerCase().contains(_query.toLowerCase()) ||
          c.city.toLowerCase().contains(_query.toLowerCase());
      return matchesSegment && matchesQuery;
    }).toList();
  }

  int get total => _all.length;
  int get vipCount => _all.where((c) => c.segment == CustomerSegment.vip).length;

  void setQuery(String value) {
    _query = value;
    notifyListeners();
  }

  void setSegmentFilter(CustomerSegment? segment) {
    _segmentFilter = segment;
    notifyListeners();
  }
}
