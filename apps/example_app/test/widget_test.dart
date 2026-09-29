import 'dart:io';

import 'package:core/core.dart';
import 'package:example_app/app.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:storage/storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late HiveStorageService storage;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('example_widget_test_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => tempDir.path,
    );
  });

  setUp(() async {
    storage = await HiveStorageService.init();
  });

  tearDown(() async {
    await storage.close();
  });

  tearDownAll(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  testWidgets('ExampleApp renders home screen through the router',
      (tester) async {
    final lines = <String>[];
    final logger = AppLogger(output: lines.add);
    final dioClient = DioClient(environment: Environment.dev);

    await tester.pumpWidget(
      ExampleApp(
        logger: logger,
        dioClient: dioClient,
        storage: storage,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Monorepo Demo'), findsOneWidget);
    expect(find.text('Open Details'), findsOneWidget);
    expect(find.text('Open Settings'), findsOneWidget);
  });
}
