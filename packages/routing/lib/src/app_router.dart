import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'route_observer.dart';

/// Centralized GoRouter factory.
/// Apps call [AppRouter.create] with their own route list.
class AppRouter {
  const AppRouter._();

  /// Build a configured [GoRouter] with the global observer and a default
  /// 404 page.
  static GoRouter create({
    required List<RouteBase> routes,
    String initialLocation = '/',
    Widget Function(BuildContext context, GoRouterState state)? errorBuilder,
  }) {
    return GoRouter(
      initialLocation: initialLocation,
      observers: <NavigatorObserver>[appRouteObserver],
      routes: routes,
      errorBuilder: errorBuilder ??
          (context, state) => Scaffold(
                appBar: AppBar(title: const Text('Not found')),
                body: Center(child: Text('No route for ${state.uri}')),
              ),
    );
  }
}
