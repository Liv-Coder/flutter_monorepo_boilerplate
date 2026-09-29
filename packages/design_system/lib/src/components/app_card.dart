import 'package:flutter/material.dart';

import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

/// Surface container with consistent elevation and padding.
class AppCard extends StatelessWidget {
  const AppCard({
    required this.child,
    this.padding,
    this.onTap,
    super.key,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: const RoundedRectangleBorder(borderRadius: AppRadius.lgAll),
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.lgAll,
        child: Padding(
          padding: padding ?? const EdgeInsets.all(AppSpacing.md),
          child: child,
        ),
      ),
    );
  }
}
