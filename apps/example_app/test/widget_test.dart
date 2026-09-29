import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:example_app/app.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ExampleApp renders HomeScreen with design system',
      (tester) async {
    SharedPreferences.setMockInitialValues({});

    final lines = <String>[];
    final logger = AppLogger(output: lines.add);
    final dioClient = DioClient(environment: Environment.dev);
    final store = await KeyValueStore.create();

    await tester.pumpWidget(
      ExampleApp(
        logger: logger,
        dioClient: dioClient,
        store: store,
      ),
    );

    expect(find.text('Monorepo Demo'), findsOneWidget);
    expect(find.byType(AppButton), findsWidgets);
    expect(find.byType(AppCard), findsOneWidget);
  });
}
