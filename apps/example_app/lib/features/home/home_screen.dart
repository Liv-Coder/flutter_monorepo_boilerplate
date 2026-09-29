import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:storage/storage.dart';

import '../../router/app_routes.dart';

/// Demonstrates navigating between routes and reading storage.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.logger,
    required this.dioClient,
    required this.storage,
    super.key,
  });

  final AppLogger logger;
  final DioClient dioClient;
  final HiveStorageService storage;

  @override
  Widget build(BuildContext context) {
    final savedName = storage.getString(
      StorageBoxes.settings,
      StorageKeys.themeMode,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Example App')),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text('Monorepo Demo', style: AppTypography.heading2),
            const SizedBox(height: AppSpacing.lg),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Storage snapshot', style: AppTypography.label),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    savedName == null
                        ? 'No theme mode saved yet.'
                        : 'Saved theme mode: $savedName',
                    style: AppTypography.bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Open Details',
              icon: Icons.info_outline,
              onPressed: () => context.goNamed(ExampleRoutes.details),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: 'Open Settings',
              variant: AppButtonVariant.secondary,
              icon: Icons.settings,
              onPressed: () => context.goNamed(ExampleRoutes.settings),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: 'Log a Message',
              variant: AppButtonVariant.outline,
              icon: Icons.terminal,
              onPressed: () => logger.info('Button tapped'),
            ),
          ],
        ),
      ),
    );
  }
}
