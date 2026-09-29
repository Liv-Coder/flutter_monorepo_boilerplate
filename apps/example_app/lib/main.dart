import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

import 'app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final logger = AppLogger(
    minLevel: LogLevel.debug,
    printer: const PrettyLogPrinter(),
  );

  logger.info('Starting example_app');

  const env = Environment.dev;
  final dioClient = DioClient(environment: env);
  final store = await KeyValueStore.create();

  logger.info('Environment: ${env.name}');
  logger.info('Base URL: ${env.baseUrl}');

  runApp(
    ExampleApp(
      logger: logger,
      dioClient: dioClient,
      store: store,
    ),
  );
}
