import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Reusable page transitions for consistent navigation animations.
class AppTransitions {
  const AppTransitions._();

  /// Fade + slight horizontal slide. Use for secondary screens.
  static CustomTransitionPage<T> slideFade<T>({
    required LocalKey key,
    required Widget child,
    Duration duration = const Duration(milliseconds: 250),
  }) {
    return CustomTransitionPage<T>(
      key: key,
      child: child,
      transitionDuration: duration,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved =
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.05, 0),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}
