import 'package:flutter/widgets.dart';

/// Global route observer for widgets that need to be aware of route changes.
/// Add to `GoRouter.observers` via `AppRouter.create`.
final RouteObserver<ModalRoute<void>> appRouteObserver =
    RouteObserver<ModalRoute<void>>();
