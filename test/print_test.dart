import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:dashboard/core/theme.dart';
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

import 'golden_utils.dart';

typedef PageBuilder = Widget Function();

/// Renders every screen at phone resolution in light then dark theme and writes
/// real PNGs to `screenshots/` (dashboard.png, -2..-9 light, -10..-18 dark):
///
///   flutter test test/print_test.dart
void main() {
  final repository = DashboardRepository(api: DashboardApiService());

  final pages = <(String, PageBuilder)>[
    (
      'Overview',
      () => ChangeNotifierProvider(
            create: (_) => DashboardViewModel(repository: repository),
            child: const DashboardScreen(),
          ),
    ),
    (
      'Analytics',
      () => ChangeNotifierProvider(
            create: (_) => AnalyticsViewModel(repository: repository),
            child: const AnalyticsScreen(),
          ),
    ),
    (
      'Orders',
      () => ChangeNotifierProvider(
            create: (_) => OrdersViewModel(repository: repository),
            child: const OrdersScreen(),
          ),
    ),
    (
      'OrderDetail',
      () => ChangeNotifierProvider(
            create: (_) =>
                OrderDetailViewModel(repository: repository, orderId: '1042'),
            child: const OrderDetailScreen(),
          ),
    ),
    (
      'Customers',
      () => ChangeNotifierProvider(
            create: (_) => CustomersViewModel(repository: repository),
            child: const CustomersScreen(),
          ),
    ),
    (
      'CustomerDetail',
      () => ChangeNotifierProvider(
            create: (_) =>
                CustomerDetailViewModel(repository: repository, customerId: 'c1'),
            child: const CustomerDetailScreen(),
          ),
    ),
    (
      'Reports',
      () => ChangeNotifierProvider(
            create: (_) => ReportsViewModel(repository: repository),
            child: const ReportsScreen(),
          ),
    ),
    (
      'Notifications',
      () => ChangeNotifierProvider(
            create: (_) => NotificationsViewModel(repository: repository),
            child: const NotificationsScreen(),
          ),
    ),
    (
      'Settings',
      () => ChangeNotifierProvider(
            create: (_) => SettingsViewModel(),
            child: const SettingsScreen(),
          ),
    ),
  ];

  testWidgets('dashboard screenshots (claro+escuro)', (tester) async {
    await loadGoldenFonts();
    tester.binding.focusManager.highlightStrategy =
        FocusHighlightStrategy.alwaysTouch;
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(390, 844);
    addTearDown(tester.view.reset);

    var idx = 0;
    for (final theme in <ThemeData>[AppTheme.light(), AppTheme.dark()]) {
      for (final page in pages) {
        final key = GlobalKey();
        await tester.pumpWidget(
          RepaintBoundary(
            key: key,
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: theme,
              // Prevent any widget (e.g. a FAB) from taking focus so no focus
              // ring is baked into the screenshot.
              home: ExcludeFocus(child: page.$2()),
            ),
          ),
        );
        await tester.pump(const Duration(milliseconds: 600));
        // Drop any auto-focus (e.g. a FAB) so no focus ring is baked in.
        tester.binding.focusManager.primaryFocus?.unfocus();
        await tester.pump();

        await tester.runAsync(() async {
          final boundary =
              key.currentContext!.findRenderObject()! as RenderRepaintBoundary;
          final image = await boundary.toImage(pixelRatio: 3.0);
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          final suffix = idx == 0 ? '' : '-${idx + 1}';
          final file = File('screenshots/dashboard$suffix.png');
          await file.create(recursive: true);
          await file.writeAsBytes(bytes!.buffer.asUint8List());
        });
        idx++;
      }
    }
  });
}
