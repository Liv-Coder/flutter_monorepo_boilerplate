import 'package:core/core.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:storage/storage.dart';

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
  final storage = await HiveStorageService.init();

  logger.info('Storage initialized — boxes: settings, cache, user_data');
  logger.info('Environment: ${env.name} — baseUrl: ${env.baseUrl}');

  runApp(
    ExampleApp(
      logger: logger,
      dioClient: dioClient,
      storage: storage,
    ),
  );
}
