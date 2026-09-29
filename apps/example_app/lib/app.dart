import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'features/home/home_screen.dart';

/// Root application widget. Wires design system, logger, and core services.
class ExampleApp extends StatelessWidget {
  const ExampleApp({
    required this.logger,
    required this.dioClient,
    required this.store,
    super.key,
  });

  final AppLogger logger;
  final DioClient dioClient;
  final KeyValueStore store;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monorepo Example',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      home: HomeScreen(
        logger: logger,
        dioClient: dioClient,
        store: store,
      ),
    );
  }
}
