import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';

/// Second screen. Demos back navigation and RouteAware hooks.
class DetailsScreen extends StatelessWidget {
  const DetailsScreen({required this.logger, super.key});

  final AppLogger logger;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text('Details Screen', style: AppTypography.heading2),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'This screen lives at /details and is reached via named routing.',
              style: AppTypography.body,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Back to Home',
              icon: Icons.home,
              onPressed: () => context.go('/'),
            ),
          ],
        ),
      ),
    );
  }
}
