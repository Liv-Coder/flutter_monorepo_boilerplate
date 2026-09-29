/// Centralized Hive box names. Every box in the app must be declared here.
class StorageBoxes {
  const StorageBoxes._();

  static const String settings = 'settings';
  static const String cache = 'cache';
  static const String userData = 'user_data';
}

/// Centralized storage keys. Every key used in the app must be declared here.
class StorageKeys {
  const StorageKeys._();

  static const String themeMode = 'theme_mode';
  static const String locale = 'locale';
  static const String onboardingComplete = 'onboarding_complete';
  static const String authToken = 'auth_token';
  static const String lastSyncAt = 'last_sync_at';
}
