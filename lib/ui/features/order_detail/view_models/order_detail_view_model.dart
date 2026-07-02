import 'package:flutter/foundation.dart';

import 'package:dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/domain/models/order.dart';

/// A single step of the order fulfilment timeline.
class OrderStep {
  const OrderStep({required this.label, required this.time, required this.done});

  final String label;
  final String time;
  final bool done;
}

/// Presentation state for a single order's detail screen.
class OrderDetailViewModel extends ChangeNotifier {
  OrderDetailViewModel({required DashboardRepository repository, required String orderId})
      : _order = repository.orderById(orderId);

  final Order _order;
  Order get order => _order;

  /// Timeline steps derived from the current status.
  List<OrderStep> get timeline {
    final cancelled = _order.status == OrderStatus.cancelled;
    final reached = switch (_order.status) {
      OrderStatus.pending => 1,
      OrderStatus.paid => 2,
      OrderStatus.shipped => 3,
      OrderStatus.cancelled => 1,
    };
    final labels = <(String, String)>[
      ('Pedido recebido', _order.date),
      ('Pagamento confirmado', cancelled ? 'Cancelado' : 'Aprovado'),
      ('Em separação', 'Estoque'),
      ('Enviado', 'Transportadora'),
      ('Entregue', 'Previsto'),
    ];
    return <OrderStep>[
      for (var i = 0; i < labels.length; i++)
        OrderStep(label: labels[i].$1, time: labels[i].$2, done: i <= reached && !cancelled || i == 0),
    ];
  }
}
