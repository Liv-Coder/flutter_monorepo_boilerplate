import 'package:hive_ce/hive.dart';

part 'app_settings.g.dart';

/// Example typed model persisted to Hive. Replace or extend as needed.
@HiveType(typeId: 0)
class AppSettings extends HiveObject {
  AppSettings({
    required this.themeMode,
    required this.locale,
    this.onboardingComplete = false,
  });

  @HiveField(0)
  final String themeMode;

  @HiveField(1)
  final String locale;

  @HiveField(2)
  final bool onboardingComplete;

  AppSettings copyWith({
    String? themeMode,
    String? locale,
    bool? onboardingComplete,
  }) {
    return AppSettings(
      themeMode: themeMode ?? this.themeMode,
      locale: locale ?? this.locale,
      onboardingComplete: onboardingComplete ?? this.onboardingComplete,
    );
  }
}
