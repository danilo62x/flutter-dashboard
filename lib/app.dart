import 'package:flutter/material.dart';

import 'package:dashboard/core/router.dart';
import 'package:dashboard/core/theme.dart';

/// Root widget. Wires the Material 3 theme with declarative routing (go_router).
class DashboardApp extends StatelessWidget {
  const DashboardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Dashboard Template',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: appRouter,
    );
  }
}
