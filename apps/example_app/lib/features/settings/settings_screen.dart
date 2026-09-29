import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:storage/storage.dart';

/// Settings screen — demonstrates Hive persistence, theme mode toggling,
/// and local state management with a polished, grouped UI.
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
  int _counter = 0;

  @override
  void initState() {
    super.initState();
    _themeMode = widget.storage.getString(
      StorageBoxes.settings,
      StorageKeys.themeMode,
    );
    _counter = widget.storage.getInt(
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
    widget.logger.info('Theme mode updated: $mode');
    setState(() => _themeMode = mode);
  }

  Future<void> _incrementCounter() async {
    final next = _counter + 1;
    await widget.storage.setInt(
      StorageBoxes.settings,
      StorageKeys.lastSyncAt,
      next,
    );
    widget.logger.info('Counter incremented to $next');
    setState(() => _counter = next);
  }

  Future<void> _clearAll() async {
    await widget.storage.clear(StorageBoxes.settings);
    widget.logger.info('Settings storage cleared');
    setState(() {
      _themeMode = null;
      _counter = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.surface,
      appBar: AppBar(
        title: Text(
          'Settings',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
        ),
        leading: IconButton(
          icon: const Icon(AppIcons.back),
          onPressed: () => context.pop(),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: <Widget>[
          // ── Appearance Section ──────────────────────────────────────
          const _SectionHeader(
            label: 'Appearance',
            icon: AppIcons.eye,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Theme Mode',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Choose how the application appears on your device.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.65),
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _ThemeOptionTile(
                        icon: AppIcons.eye,
                        label: 'Light',
                        isSelected: _themeMode == 'light',
                        onTap: () => _setTheme('light'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _ThemeOptionTile(
                        icon: AppIcons.lock,
                        label: 'Dark',
                        isSelected: _themeMode == 'dark',
                        onTap: () => _setTheme('dark'),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _ThemeOptionTile(
                        icon: AppIcons.refresh,
                        label: 'System',
                        isSelected:
                            _themeMode == null || _themeMode == 'system',
                        onTap: () => _setTheme('system'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Hive Storage Section ────────────────────────────────────
          const _SectionHeader(
            label: 'Storage & State',
            icon: AppIcons.save,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Hive Persistence',
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          'Box: ${StorageBoxes.settings}',
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: cs.onSurface.withValues(alpha: 0.55),
                                  ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.xs,
                      ),
                      decoration: BoxDecoration(
                        color: cs.primaryContainer,
                        borderRadius: AppRadius.fullAll,
                      ),
                      child: Text(
                        '$_counter',
                        style:
                            Theme.of(context).textTheme.titleMedium?.copyWith(
                                  color: cs.onPrimaryContainer,
                                  fontWeight: FontWeight.w700,
                                ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: 'Increment counter',
                  icon: AppIcons.add,
                  variant: AppButtonVariant.outline,
                  onPressed: _incrementCounter,
                ),
              ],
            ),
          ),

          const SizedBox(height: AppSpacing.lg),

          // ── Danger Zone ─────────────────────────────────────────────
          const _SectionHeader(
            label: 'Maintenance',
            icon: AppIcons.warning,
          ),
          const SizedBox(height: AppSpacing.sm),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Reset Local Box',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: cs.error,
                      ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  'Clears all key-value entries in the settings Hive box.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: cs.onSurface.withValues(alpha: 0.65),
                      ),
                ),
                const SizedBox(height: AppSpacing.md),
                AppButton(
                  label: 'Clear settings box',
                  icon: AppIcons.delete,
                  variant: AppButtonVariant.danger,
                  onPressed: _clearAll,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private components ──────────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      children: <Widget>[
        Icon(icon, size: 16, color: cs.primary),
        const SizedBox(width: AppSpacing.xs),
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: cs.primary,
                letterSpacing: 1.2,
                fontWeight: FontWeight.w600,
              ),
        ),
      ],
    );
  }
}

class _ThemeOptionTile extends StatelessWidget {
  const _ThemeOptionTile({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    final background =
        isSelected ? cs.primaryContainer : cs.surfaceContainerHighest;
    final contentColor =
        isSelected ? cs.onPrimaryContainer : cs.onSurfaceVariant;
    final borderColor = isSelected ? cs.primary : Colors.transparent;

    return Material(
      color: background,
      borderRadius: AppRadius.mdAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.mdAll,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: AppSpacing.md,
            horizontal: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            borderRadius: AppRadius.mdAll,
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: Column(
            children: <Widget>[
              Icon(icon, color: contentColor, size: 22),
              const SizedBox(height: AppSpacing.xs),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: contentColor,
                      fontWeight:
                          isSelected ? FontWeight.w700 : FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
