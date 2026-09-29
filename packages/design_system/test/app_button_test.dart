import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('AppButton renders label and fires onPressed', (tester) async {
    var tapped = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: Scaffold(
          body: AppButton(
            label: 'Tap me',
            onPressed: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Tap me'), findsOneWidget);
    await tester.tap(find.byType(AppButton));
    expect(tapped, isTrue);
  });

  testWidgets('AppButton shows spinner when loading', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: AppButton(
            label: 'Loading',
            onPressed: null,
            isLoading: true,
          ),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
