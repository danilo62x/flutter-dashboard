import 'package:dashboard/domain/models/order.dart';

/// Raw API model for an order with manual JSON (de)serialization.
class OrderApiModel {
  const OrderApiModel({
    required this.id,
    required this.customerName,
    required this.total,
    required this.status,
    required this.date,
  });

  final String id;
  final String customerName;
  final double total;
  final String status;
  final String date;

  factory OrderApiModel.fromJson(Map<String, dynamic> json) => OrderApiModel(
        id: (json['id'] ?? '') as String,
        customerName: (json['customer_name'] ?? json['customer'] ?? '') as String,
        total: (json['total'] as num?)?.toDouble() ?? 0,
        status: (json['status'] ?? 'pending') as String,
        date: (json['date'] ?? '') as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'customer_name': customerName,
        'total': total,
        'status': status,
        'date': date,
      };

  /// Transform the transport model into the clean domain model.
  Order toDomain() => Order(
        id: id,
        customer: customerName,
        amount: total,
        status: _statusFromString(status),
        date: date,
      );

  static OrderStatus _statusFromString(String value) {
    switch (value.toLowerCase()) {
      case 'paid':
        return OrderStatus.paid;
      case 'shipped':
        return OrderStatus.shipped;
      case 'cancelled':
        return OrderStatus.cancelled;
      case 'pending':
      default:
        return OrderStatus.pending;
    }
  }
}
