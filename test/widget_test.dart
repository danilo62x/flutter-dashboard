import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

import 'package:dashboard/data/repositories/dashboard_repository.dart';
import 'package:dashboard/data/services/dashboard_api_service.dart';
import 'package:dashboard/ui/features/dashboard/view_models/dashboard_view_model.dart';
import 'package:dashboard/ui/features/dashboard/views/dashboard_screen.dart';
import 'package:dashboard/ui/features/orders/view_models/orders_view_model.dart';
import 'package:dashboard/ui/features/orders/views/orders_screen.dart';

DashboardRepository _repo() =>
    DashboardRepository(api: DashboardApiService());

void main() {
  testWidgets('renders overview header and seeded content', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(500, 1200);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => DashboardViewModel(repository: _repo()),
          child: const DashboardScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Olá, Ana'), findsOneWidget);
    expect(find.text('Receita'), findsOneWidget);
    expect(find.text('Últimos pedidos'), findsOneWidget);
  });

  testWidgets('orders screen filters by search query', (tester) async {
    tester.view.devicePixelRatio = 1.0;
    tester.view.physicalSize = const Size(500, 1400);
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider(
          create: (_) => OrdersViewModel(repository: _repo()),
          child: const OrdersScreen(),
        ),
      ),
    );
    await tester.pump();

    expect(find.text('Bruno Costa'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'Marina');
    await tester.pump();

    expect(find.text('Bruno Costa'), findsNothing);
    expect(find.text('Marina Alves'), findsWidgets);
  });
}
