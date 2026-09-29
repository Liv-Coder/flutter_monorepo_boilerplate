import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

/// Demonstrates consuming design system components and core services.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
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
    return Scaffold(
      appBar: AppBar(title: const Text('Example App')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Monorepo Demo', style: AppTypography.heading2),
            const SizedBox(height: AppSpacing.lg),
            const AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Design System', style: AppTypography.label),
                  SizedBox(height: AppSpacing.sm),
                  Text(
                    'Buttons, cards, and text fields from the shared package.',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Log a Message',
              icon: Icons.terminal,
              onPressed: () {
                logger.info('Button tapped at ${DateTime.now()}');
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: 'Save to Store',
              variant: AppButtonVariant.secondary,
              icon: Icons.save,
              onPressed: () async {
                await store.setString('last_action', 'save');
                final saved = store.getString('last_action');
                logger.info('Stored value: $saved');
              },
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: 'Check Network',
              variant: AppButtonVariant.outline,
              icon: Icons.wifi,
              onPressed: () {
                logger.info('Base URL: ${Environment.dev.baseUrl}');
                logger
                    .info('Dio client ready: ${dioClient.raw.options.baseUrl}');
              },
            ),
          ],
        ),
      ),
    );
  }
}
