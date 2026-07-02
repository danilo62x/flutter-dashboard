import 'dart:convert';

import 'package:http/http.dart' as http;

import 'package:dashboard/data/models/customer_api_model.dart';
import 'package:dashboard/data/models/metric_api_model.dart';
import 'package:dashboard/data/models/order_api_model.dart';

/// Stateless service wrapping the dashboard HTTP endpoints.
///
/// Demonstrates the `http` skill (GET requests + manual JSON decoding). The
/// repository seeds synchronous demo data for the UI/screenshots and only calls
/// these methods when wired to a live backend.
class DashboardApiService {
  DashboardApiService({
    http.Client? client,
    this.baseUrl = 'https://api.example.com',
  }) : _client = client ?? http.Client();

  final http.Client _client;
  final String baseUrl;

  Future<List<MetricApiModel>> fetchMetrics() async {
    final response = await _client.get(Uri.parse('$baseUrl/dashboard/metrics'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load metrics (${response.statusCode})');
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => MetricApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<OrderApiModel>> fetchOrders() async {
    final response = await _client.get(Uri.parse('$baseUrl/dashboard/orders'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load orders (${response.statusCode})');
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => OrderApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<CustomerApiModel>> fetchCustomers() async {
    final response = await _client.get(Uri.parse('$baseUrl/dashboard/customers'));
    if (response.statusCode != 200) {
      throw Exception('Failed to load customers (${response.statusCode})');
    }
    final list = jsonDecode(response.body) as List<dynamic>;
    return list
        .map((e) => CustomerApiModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}
