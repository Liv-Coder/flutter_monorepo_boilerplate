import 'package:core/core.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:routing/routing.dart';
import 'package:storage/storage.dart';

import '../features/details/details_screen.dart';
import '../features/home/home_screen.dart';
import '../features/settings/settings_screen.dart';

/// Route name and path constants for this app.
class ExampleRoutes {
  const ExampleRoutes._();

  static const String home = 'home';
  static const String homePath = '/';

  static const String details = 'details';
  static const String detailsPath = '/details';

  static const String settings = 'settings';
  static const String settingsPath = '/settings';
}

/// Builds the app's GoRouter with all screens wired.
GoRouter buildRouter({
  required AppLogger logger,
  required DioClient dioClient,
  required HiveStorageService storage,
}) {
  return AppRouter.create(
    initialLocation: ExampleRoutes.homePath,
    routes: <RouteBase>[
      GoRoute(
        path: ExampleRoutes.homePath,
        name: ExampleRoutes.home,
        builder: (context, state) => HomeScreen(
          logger: logger,
          dioClient: dioClient,
          storage: storage,
        ),
        routes: <RouteBase>[
          GoRoute(
            path: 'details',
            name: ExampleRoutes.details,
            builder: (context, state) => DetailsScreen(logger: logger),
          ),
          GoRoute(
            path: 'settings',
            name: ExampleRoutes.settings,
            builder: (context, state) => SettingsScreen(
              logger: logger,
              storage: storage,
            ),
          ),
        ],
      ),
    ],
  );
}
