import 'package:hive_ce/hive.dart';

import 'models/app_settings.dart';

/// Central registration for all Hive type adapters.
/// Add adapter registrations here as new typed models are introduced.
Future<void> registerStorageAdapters() async {
  if (!Hive.isAdapterRegistered(0)) {
    Hive.registerAdapter(AppSettingsAdapter());
  }
}
