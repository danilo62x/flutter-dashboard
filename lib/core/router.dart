import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/data/services/dashboard_api_service.dart';
import 'package:dashboard/ui/features/analytics/view_models/analytics_view_model.dart';
import 'package:dashboard/ui/features/analytics/views/analytics_screen.dart';
import 'package:dashboard/ui/features/customer_detail/view_models/customer_detail_view_model.dart';
import 'package:dashboard/ui/features/customer_detail/views/customer_detail_screen.dart';
import 'package:dashboard/ui/features/customers/view_models/customers_view_model.dart';
import 'package:dashboard/ui/features/customers/views/customers_screen.dart';
import 'package:dashboard/ui/features/dashboard/view_models/dashboard_view_model.dart';
import 'package:dashboard/ui/features/dashboard/views/dashboard_screen.dart';
import 'package:dashboard/ui/features/notifications/view_models/notifications_view_model.dart';
import 'package:dashboard/ui/features/notifications/views/notifications_screen.dart';
import 'package:dashboard/ui/features/order_detail/view_models/order_detail_view_model.dart';
import 'package:dashboard/ui/features/order_detail/views/order_detail_screen.dart';
import 'package:dashboard/ui/features/orders/view_models/orders_view_model.dart';
import 'package:dashboard/ui/features/orders/views/orders_screen.dart';
import 'package:dashboard/ui/features/reports/view_models/reports_view_model.dart';
import 'package:dashboard/ui/features/reports/views/reports_screen.dart';
import 'package:dashboard/ui/features/settings/view_models/settings_view_model.dart';
import 'package:dashboard/ui/features/settings/views/settings_screen.dart';

/// App-wide repository (composition root). In a bigger app register this in a
/// DI container such as `get_it` or a top-level `MultiProvider`.
final DashboardRepository _repository =
    DashboardRepository(api: DashboardApiService());

/// Declarative navigation with go_router. The five primary tabs use
/// `context.go`; detail screens are `context.push`ed on top.
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: <RouteBase>[
    GoRoute(
      path: '/',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => DashboardViewModel(repository: _repository),
        child: const DashboardScreen(),
      ),
      routes: <RouteBase>[
        GoRoute(
          path: 'analytics',
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => AnalyticsViewModel(repository: _repository),
            child: const AnalyticsScreen(),
          ),
        ),
        GoRoute(
          path: 'notifications',
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => NotificationsViewModel(repository: _repository),
            child: const NotificationsScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => OrdersViewModel(repository: _repository),
        child: const OrdersScreen(),
      ),
      routes: <RouteBase>[
        GoRoute(
          path: ':id',
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => OrderDetailViewModel(
              repository: _repository,
              orderId: state.pathParameters['id'] ?? '',
            ),
            child: const OrderDetailScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/customers',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => CustomersViewModel(repository: _repository),
        child: const CustomersScreen(),
      ),
      routes: <RouteBase>[
        GoRoute(
          path: ':id',
          builder: (context, state) => ChangeNotifierProvider(
            create: (_) => CustomerDetailViewModel(
              repository: _repository,
              customerId: state.pathParameters['id'] ?? '',
            ),
            child: const CustomerDetailScreen(),
          ),
        ),
      ],
    ),
    GoRoute(
      path: '/reports',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => ReportsViewModel(repository: _repository),
        child: const ReportsScreen(),
      ),
    ),
    GoRoute(
      path: '/settings',
      builder: (context, state) => ChangeNotifierProvider(
        create: (_) => SettingsViewModel(),
        child: const SettingsScreen(),
      ),
    ),
  ],
);
