import 'package:dashboard/domain/models/customer.dart';

/// Raw API model for a customer with manual JSON (de)serialization.
class CustomerApiModel {
  const CustomerApiModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.city,
    required this.orders,
    required this.totalSpent,
    required this.segment,
  });

  final String id;
  final String name;
  final String email;
  final String phone;
  final String city;
  final int orders;
  final double totalSpent;
  final String segment;

  factory CustomerApiModel.fromJson(Map<String, dynamic> json) =>
      CustomerApiModel(
        id: (json['id'] ?? '') as String,
        name: (json['name'] ?? '') as String,
        email: (json['email'] ?? '') as String,
        phone: (json['phone'] ?? '') as String,
        city: (json['city'] ?? '') as String,
        orders: (json['orders'] as num?)?.toInt() ?? 0,
        totalSpent: (json['total_spent'] as num?)?.toDouble() ?? 0,
        segment: (json['segment'] ?? 'active') as String,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'name': name,
        'email': email,
        'phone': phone,
        'city': city,
        'orders': orders,
        'total_spent': totalSpent,
        'segment': segment,
      };

  /// Transform the transport model into the clean domain model.
  Customer toDomain() => Customer(
        id: id,
        name: name,
        email: email,
        phone: phone,
        city: city,
        orders: orders,
        totalSpent: totalSpent,
        segment: _segmentFromString(segment),
        since: 'Cliente',
      );

  static CustomerSegment _segmentFromString(String value) {
    switch (value.toLowerCase()) {
      case 'vip':
        return CustomerSegment.vip;
      case 'new':
      case 'newcomer':
        return CustomerSegment.newcomer;
      case 'active':
      default:
        return CustomerSegment.active;
    }
  }
}
