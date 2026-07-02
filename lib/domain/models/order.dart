/// Fulfilment state of a customer order.
enum OrderStatus { paid, pending, shipped, cancelled }

/// A single line inside an order.
class OrderItem {
  const OrderItem({
    required this.name,
    required this.quantity,
    required this.price,
  });

  final String name;
  final int quantity;

  /// Unit price in BRL.
  final double price;

  double get lineTotal => quantity * price;
}

/// Clean domain model for an order, consumed by the UI layer.
class Order {
  const Order({
    required this.id,
    required this.customer,
    required this.amount,
    required this.status,
    required this.date,
    this.items = const <OrderItem>[],
    this.paymentMethod = 'Cartão de crédito',
    this.channel = 'Loja online',
    this.shipping = 0,
    this.discount = 0,
  });

  /// Human-facing order number, e.g. `1042`.
  final String id;
  final String customer;

  /// Total in BRL.
  final double amount;
  final OrderStatus status;

  /// Short human date label, e.g. `28 jun, 14:32`.
  final String date;
  final List<OrderItem> items;
  final String paymentMethod;
  final String channel;
  final double shipping;
  final double discount;

  double get subtotal =>
      items.fold<double>(0, (sum, item) => sum + item.lineTotal);
}
