import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:storage/storage.dart';

/// Third screen. Demos Hive CRUD through the centralized service.
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    required this.logger,
    required this.storage,
    super.key,
  });

  final AppLogger logger;
  final HiveStorageService storage;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  String? _themeMode;
  int _launchCount = 0;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.storage.getString(
      StorageBoxes.settings,
      StorageKeys.themeMode,
    );
    _launchCount = widget.storage.getInt(
          StorageBoxes.settings,
          StorageKeys.lastSyncAt,
        ) ??
        0;
  }

  Future<void> _setTheme(String mode) async {
    await widget.storage.setString(
      StorageBoxes.settings,
      StorageKeys.themeMode,
      mode,
    );
    widget.logger.info('Theme set to $mode');
    setState(() => _themeMode = mode);
  }

  Future<void> _incrementCounter() async {
    final next = _launchCount + 1;
    await widget.storage.setInt(
      StorageBoxes.settings,
      StorageKeys.lastSyncAt,
      next,
    );
    setState(() => _launchCount = next);
  }

  Future<void> _clearAll() async {
    await widget.storage.clear(StorageBoxes.settings);
    widget.logger.info('Settings box cleared');
    setState(() {
      _themeMode = null;
      _launchCount = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
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
            const Text('Hive CRUD Demo', style: AppTypography.heading3),
            const SizedBox(height: AppSpacing.md),
            AppCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('themeMode: ${_themeMode ?? 'unset'}',
                      style: AppTypography.body),
                  const SizedBox(height: AppSpacing.sm),
                  Text('counter: $_launchCount', style: AppTypography.body),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            AppButton(
              label: 'Set theme: light',
              onPressed: () => _setTheme('light'),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: 'Set theme: dark',
              variant: AppButtonVariant.secondary,
              onPressed: () => _setTheme('dark'),
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: 'Increment counter',
              variant: AppButtonVariant.outline,
              onPressed: _incrementCounter,
            ),
            const SizedBox(height: AppSpacing.sm),
            AppButton(
              label: 'Clear settings box',
              variant: AppButtonVariant.danger,
              onPressed: _clearAll,
            ),
          ],
        ),
      ),
    );
  }
}
