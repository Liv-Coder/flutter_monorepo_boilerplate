import 'package:flutter/material.dart';

import '../tokens/app_radius.dart';
import '../tokens/app_spacing.dart';

/// Button variants. One widget, four states, zero duplication.
enum AppButtonVariant { primary, secondary, outline, danger }

/// Primary action widget for the design system.
class AppButton extends StatelessWidget {
  const AppButton({
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    super.key,
  });

  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final bool isLoading;

  /// Optional icon. Pass a value from AppIcons, e.g. `AppIcons.save`.
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    final (bg, fg, side) = switch (variant) {
      AppButtonVariant.primary => (
          scheme.primary,
          Colors.white,
          BorderSide.none
        ),
      AppButtonVariant.secondary => (
          scheme.secondary,
          Colors.white,
          BorderSide.none
        ),
      AppButtonVariant.outline => (
          Colors.transparent,
          scheme.primary,
          BorderSide(color: scheme.primary)
        ),
      AppButtonVariant.danger => (scheme.error, Colors.white, BorderSide.none),
    };

    return SizedBox(
      height: 48,
      child: FilledButton.icon(
        onPressed: isLoading ? null : onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: bg,
          foregroundColor: fg,
          side: side,
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.mdAll),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.lg,
            vertical: AppSpacing.sm,
          ),
        ),
        icon: isLoading
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : (icon != null ? Icon(icon, size: 18) : const SizedBox.shrink()),
        label: Text(label),
      ),
    );
  }
}
