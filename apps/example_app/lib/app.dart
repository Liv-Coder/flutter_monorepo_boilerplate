import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:storage/storage.dart';

import 'router/app_routes.dart';

/// Root application widget. Wires services and the GoRouter config.
class ExampleApp extends StatefulWidget {
  const ExampleApp({
    required this.logger,
    required this.dioClient,
    required this.storage,
    super.key,
  });

  final AppLogger logger;
  final DioClient dioClient;
  final HiveStorageService storage;

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  late final _router = buildRouter(
    logger: widget.logger,
    dioClient: widget.dioClient,
    storage: widget.storage,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Monorepo Example',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      routerConfig: _router,
    );
  }
}
