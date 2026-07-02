import 'package:dashboard/data/services/dashboard_api_service.dart';
import 'package:dashboard/domain/models/analytics.dart';
import 'package:dashboard/domain/models/app_notification.dart';
import 'package:dashboard/domain/models/customer.dart';
import 'package:dashboard/domain/models/metric.dart';
import 'package:dashboard/domain/models/order.dart';
import 'package:dashboard/domain/models/report.dart';

/// Single source of truth for the whole app.
///
/// Every `seed*` method returns synchronous demo data so the UI renders
/// instantly (and screenshots are never empty). The `fetch*` methods model the
/// real async path — swap the body for the commented lines to hit a live API
/// through the injected [DashboardApiService].
class DashboardRepository {
  DashboardRepository({required DashboardApiService api}) : _api = api;

  final DashboardApiService _api;

  /// Underlying HTTP service, exposed for real backend wiring.
  DashboardApiService get api => _api;

  // ---------------------------------------------------------------------------
  // KPIs
  // ---------------------------------------------------------------------------

  List<Metric> seedMetrics() => const <Metric>[
        Metric(label: 'Receita', value: 'R\$ 48,2k', deltaPercent: 12, iconKey: 'payments'),
        Metric(label: 'Pedidos', value: '1.284', deltaPercent: 8, iconKey: 'shopping_bag'),
        Metric(label: 'Clientes', value: '312', deltaPercent: 5, iconKey: 'group'),
        Metric(label: 'Conversão', value: '3,4%', deltaPercent: -2, iconKey: 'trending_up'),
      ];

  List<Metric> seedAnalyticsSummary() => const <Metric>[
        Metric(label: 'Receita', value: 'R\$ 128,4k', deltaPercent: 18, iconKey: 'payments'),
        Metric(label: 'Ticket médio', value: 'R\$ 214', deltaPercent: 6, iconKey: 'receipt'),
        Metric(label: 'Sessões', value: '24,9k', deltaPercent: 11, iconKey: 'visibility'),
        Metric(label: 'Conversão', value: '3,4%', deltaPercent: -2, iconKey: 'trending_up'),
      ];

  // ---------------------------------------------------------------------------
  // Orders
  // ---------------------------------------------------------------------------

  List<Order> seedOrders() => <Order>[
        Order(
          id: '1042',
          customer: 'Marina Alves',
          amount: 289.90,
          status: OrderStatus.paid,
          date: '28 jun, 14:32',
          paymentMethod: 'Pix',
          channel: 'Loja online',
          shipping: 19.90,
          discount: 30,
          items: const <OrderItem>[
            OrderItem(name: 'Tênis Runner Pro', quantity: 1, price: 199.90),
            OrderItem(name: 'Meia esportiva (par)', quantity: 2, price: 45.05),
          ],
        ),
        Order(
          id: '1041',
          customer: 'Bruno Costa',
          amount: 132.00,
          status: OrderStatus.pending,
          date: '28 jun, 11:07',
          paymentMethod: 'Boleto',
          channel: 'App',
          shipping: 12.00,
          items: const <OrderItem>[
            OrderItem(name: 'Camiseta Dry-Fit', quantity: 2, price: 60.00),
          ],
        ),
        Order(
          id: '1040',
          customer: 'Carla Dias',
          amount: 74.50,
          status: OrderStatus.shipped,
          date: '27 jun, 19:45',
          paymentMethod: 'Cartão de crédito',
          channel: 'Loja online',
          shipping: 15.50,
          items: const <OrderItem>[
            OrderItem(name: 'Garrafa térmica 750ml', quantity: 1, price: 59.00),
          ],
        ),
        Order(
          id: '1039',
          customer: 'Diego Reis',
          amount: 512.30,
          status: OrderStatus.paid,
          date: '27 jun, 09:12',
          paymentMethod: 'Cartão de crédito',
          channel: 'Loja física',
          shipping: 0,
          discount: 50,
          items: const <OrderItem>[
            OrderItem(name: 'Jaqueta corta-vento', quantity: 1, price: 349.00),
            OrderItem(name: 'Boné trail', quantity: 1, price: 89.00),
            OrderItem(name: 'Kit meias (3)', quantity: 1, price: 124.30),
          ],
        ),
        Order(
          id: '1038',
          customer: 'Elaine Souza',
          amount: 96.00,
          status: OrderStatus.cancelled,
          date: '26 jun, 22:03',
          paymentMethod: 'Pix',
          channel: 'App',
          items: const <OrderItem>[
            OrderItem(name: 'Short de corrida', quantity: 1, price: 96.00),
          ],
        ),
        Order(
          id: '1037',
          customer: 'Felipe Marques',
          amount: 348.70,
          status: OrderStatus.shipped,
          date: '26 jun, 16:40',
          paymentMethod: 'Cartão de crédito',
          channel: 'Loja online',
          shipping: 18.70,
          items: const <OrderItem>[
            OrderItem(name: 'Mochila trekking 30L', quantity: 1, price: 330.00),
          ],
        ),
        Order(
          id: '1036',
          customer: 'Marina Alves',
          amount: 158.40,
          status: OrderStatus.paid,
          date: '25 jun, 10:22',
          paymentMethod: 'Pix',
          channel: 'App',
          items: const <OrderItem>[
            OrderItem(name: 'Legging compressão', quantity: 1, price: 158.40),
          ],
        ),
      ];

  Order orderById(String id) => seedOrders().firstWhere(
        (o) => o.id == id,
        orElse: () => seedOrders().first,
      );

  // ---------------------------------------------------------------------------
  // Customers
  // ---------------------------------------------------------------------------

  List<Customer> seedCustomers() => const <Customer>[
        Customer(
          id: 'c1',
          name: 'Marina Alves',
          email: 'marina.alves@email.com',
          phone: '(11) 98812-4530',
          city: 'São Paulo, SP',
          orders: 24,
          totalSpent: 6480.50,
          segment: CustomerSegment.vip,
          since: 'Cliente desde 2021',
          lastOrder: '28 jun',
        ),
        Customer(
          id: 'c2',
          name: 'Bruno Costa',
          email: 'bruno.costa@email.com',
          phone: '(21) 99741-2201',
          city: 'Rio de Janeiro, RJ',
          orders: 8,
          totalSpent: 1290.00,
          segment: CustomerSegment.active,
          since: 'Cliente desde 2023',
          lastOrder: '28 jun',
        ),
        Customer(
          id: 'c3',
          name: 'Carla Dias',
          email: 'carla.dias@email.com',
          phone: '(31) 98120-7788',
          city: 'Belo Horizonte, MG',
          orders: 3,
          totalSpent: 420.90,
          segment: CustomerSegment.newcomer,
          since: 'Cliente desde 2026',
          lastOrder: '27 jun',
        ),
        Customer(
          id: 'c4',
          name: 'Diego Reis',
          email: 'diego.reis@email.com',
          phone: '(41) 99503-1140',
          city: 'Curitiba, PR',
          orders: 17,
          totalSpent: 5120.30,
          segment: CustomerSegment.vip,
          since: 'Cliente desde 2022',
          lastOrder: '27 jun',
        ),
        Customer(
          id: 'c5',
          name: 'Elaine Souza',
          email: 'elaine.souza@email.com',
          phone: '(51) 98330-6612',
          city: 'Porto Alegre, RS',
          orders: 6,
          totalSpent: 980.00,
          segment: CustomerSegment.active,
          since: 'Cliente desde 2024',
          lastOrder: '26 jun',
        ),
        Customer(
          id: 'c6',
          name: 'Felipe Marques',
          email: 'felipe.marques@email.com',
          phone: '(19) 99188-4409',
          city: 'Campinas, SP',
          orders: 2,
          totalSpent: 512.70,
          segment: CustomerSegment.newcomer,
          since: 'Cliente desde 2026',
          lastOrder: '26 jun',
        ),
        Customer(
          id: 'c7',
          name: 'Gabriela Nunes',
          email: 'gabriela.nunes@email.com',
          phone: '(85) 98045-3321',
          city: 'Fortaleza, CE',
          orders: 11,
          totalSpent: 2340.10,
          segment: CustomerSegment.active,
          since: 'Cliente desde 2023',
          lastOrder: '24 jun',
        ),
      ];

  Customer customerById(String id) => seedCustomers().firstWhere(
        (c) => c.id == id,
        orElse: () => seedCustomers().first,
      );

  /// Orders that belong to a given customer (matched by name for demo data).
  List<Order> ordersForCustomer(String customerName) =>
      seedOrders().where((o) => o.customer == customerName).toList();

  // ---------------------------------------------------------------------------
  // Reports
  // ---------------------------------------------------------------------------

  List<Report> seedReports() => const <Report>[
        Report(
          title: 'Faturamento',
          value: 'R\$ 128,4k',
          subtitle: 'Últimos 30 dias',
          deltaPercent: 18,
          iconKey: 'payments',
          spark: <double>[0.35, 0.5, 0.42, 0.68, 0.6, 0.82, 0.95],
        ),
        Report(
          title: 'Novos clientes',
          value: '486',
          subtitle: 'Últimos 30 dias',
          deltaPercent: 9,
          iconKey: 'group',
          spark: <double>[0.4, 0.38, 0.55, 0.5, 0.62, 0.7, 0.75],
        ),
        Report(
          title: 'Taxa de reembolso',
          value: '1,8%',
          subtitle: 'Últimos 30 dias',
          deltaPercent: -3,
          iconKey: 'refund',
          spark: <double>[0.7, 0.62, 0.65, 0.5, 0.48, 0.42, 0.35],
        ),
        Report(
          title: 'Itens vendidos',
          value: '3.912',
          subtitle: 'Últimos 30 dias',
          deltaPercent: 14,
          iconKey: 'inventory',
          spark: <double>[0.3, 0.45, 0.5, 0.55, 0.7, 0.78, 0.9],
        ),
      ];

  List<ReportRow> seedReportRows() => const <ReportRow>[
        ReportRow(label: 'Receita', current: 'R\$ 128,4k', previous: 'R\$ 108,9k', deltaPercent: 18),
        ReportRow(label: 'Pedidos', current: '1.284', previous: '1.190', deltaPercent: 8),
        ReportRow(label: 'Ticket médio', current: 'R\$ 214', previous: 'R\$ 202', deltaPercent: 6),
        ReportRow(label: 'Reembolsos', current: 'R\$ 2,3k', previous: 'R\$ 2,4k', deltaPercent: -3),
        ReportRow(label: 'Conversão', current: '3,4%', previous: '3,5%', deltaPercent: -2),
      ];

  // ---------------------------------------------------------------------------
  // Notifications
  // ---------------------------------------------------------------------------

  List<AppNotification> seedNotifications() => const <AppNotification>[
        AppNotification(
          title: 'Novo pedido #1042',
          message: 'Marina Alves finalizou uma compra de R\$ 289,90.',
          time: 'há 5 min',
          kind: NotificationKind.order,
          group: 'Hoje',
          unread: true,
        ),
        AppNotification(
          title: 'Pagamento confirmado',
          message: 'O pagamento do pedido #1039 foi aprovado.',
          time: 'há 42 min',
          kind: NotificationKind.payment,
          group: 'Hoje',
          unread: true,
        ),
        AppNotification(
          title: 'Estoque baixo',
          message: 'Tênis Runner Pro está com apenas 4 unidades.',
          time: 'há 2 h',
          kind: NotificationKind.alert,
          group: 'Hoje',
          unread: true,
        ),
        AppNotification(
          title: 'Novo cliente',
          message: 'Felipe Marques criou uma conta.',
          time: 'ontem, 18:20',
          kind: NotificationKind.customer,
          group: 'Ontem',
        ),
        AppNotification(
          title: 'Pedido enviado',
          message: 'O pedido #1037 saiu para entrega.',
          time: 'ontem, 16:40',
          kind: NotificationKind.order,
          group: 'Ontem',
        ),
        AppNotification(
          title: 'Backup concluído',
          message: 'Seus dados foram sincronizados com sucesso.',
          time: 'seg, 03:00',
          kind: NotificationKind.system,
          group: 'Esta semana',
        ),
        AppNotification(
          title: 'Relatório semanal pronto',
          message: 'O resumo de vendas da semana já está disponível.',
          time: 'seg, 08:15',
          kind: NotificationKind.system,
          group: 'Esta semana',
        ),
      ];

  // ---------------------------------------------------------------------------
  // Analytics
  // ---------------------------------------------------------------------------

  /// Normalized monthly revenue points (0..1) for the line chart.
  List<double> seedRevenueSeries() => const <double>[
        0.42, 0.5, 0.46, 0.62, 0.55, 0.7, 0.66, 0.82, 0.78, 0.9, 0.85, 1.0,
      ];

  List<String> seedMonths() => const <String>[
        'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
        'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez',
      ];

  /// Normalized weekly order volume (0..1) for the bar chart.
  List<double> seedWeeklyOrders() =>
      const <double>[0.55, 0.72, 0.48, 0.9, 0.64, 1.0, 0.58];

  List<String> seedWeekDays() =>
      const <String>['Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb', 'Dom'];

  List<ChannelShare> seedChannels() => const <ChannelShare>[
        ChannelShare(name: 'Loja online', share: 0.52, iconKey: 'storefront'),
        ChannelShare(name: 'Aplicativo', share: 0.28, iconKey: 'smartphone'),
        ChannelShare(name: 'Loja física', share: 0.14, iconKey: 'store'),
        ChannelShare(name: 'Marketplace', share: 0.06, iconKey: 'public'),
      ];

  List<ProductStat> seedTopProducts() => const <ProductStat>[
        ProductStat(name: 'Tênis Runner Pro', units: 428, revenue: 'R\$ 85,4k', progress: 1.0),
        ProductStat(name: 'Camiseta Dry-Fit', units: 356, revenue: 'R\$ 42,1k', progress: 0.82),
        ProductStat(name: 'Mochila Trekking 30L', units: 214, revenue: 'R\$ 38,9k', progress: 0.68),
        ProductStat(name: 'Garrafa térmica 750ml', units: 190, revenue: 'R\$ 12,3k', progress: 0.45),
      ];

  // ---------------------------------------------------------------------------
  // Async paths (real backend). The UI uses the seeds above; these stay here to
  // demonstrate the repository -> service -> http flow.
  // ---------------------------------------------------------------------------

  Future<List<Metric>> fetchMetrics() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return seedMetrics();

    // Real backend:
    // final models = await _api.fetchMetrics();
    // return models.map((m) => m.toDomain()).toList();
  }

  Future<List<Order>> fetchOrders() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return seedOrders();

    // Real backend:
    // final models = await _api.fetchOrders();
    // return models.map((o) => o.toDomain()).toList();
  }

  Future<List<Customer>> fetchCustomers() async {
    await Future<void>.delayed(const Duration(milliseconds: 600));
    return seedCustomers();

    // Real backend:
    // final models = await _api.fetchCustomers();
    // return models.map((c) => c.toDomain()).toList();
  }
}
