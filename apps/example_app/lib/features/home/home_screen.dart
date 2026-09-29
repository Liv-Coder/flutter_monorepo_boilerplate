import 'package:core/core.dart';
import 'package:design_system/design_system.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:logger/logger.dart';
import 'package:storage/storage.dart';

import '../../router/app_routes.dart';

/// Home screen — branded header, typography preview, icon palette, nav cards.
class HomeScreen extends StatelessWidget {
  const HomeScreen({
    required this.logger,
    required this.dioClient,
    required this.storage,
    super.key,
  });

  final AppLogger logger;
  final DioClient dioClient;
  final HiveStorageService storage;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: cs.surface,
      body: CustomScrollView(
        slivers: <Widget>[
          // ── Branded hero app bar ────────────────────────────────────────
          SliverAppBar(
            expandedHeight: 180,
            pinned: true,
            backgroundColor: cs.primary,
            foregroundColor: cs.onPrimary,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.fromLTRB(
                  AppSpacing.md, 0, AppSpacing.md, AppSpacing.md),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Example App',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: cs.onPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  Text(
                    'Flutter Monorepo Boilerplate',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: cs.onPrimary.withValues(alpha: 0.75),
                        ),
                  ),
                ],
              ),
              background: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[
                      cs.primary,
                      cs.secondary,
                    ],
                  ),
                ),
                child: Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Icon(
                      AppIcons.home,
                      size: 72,
                      color: cs.onPrimary.withValues(alpha: 0.15),
                    ),
                  ),
                ),
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.md),
            sliver: SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                // ── Navigation cards ────────────────────────────────────────
                const _SectionHeader(label: 'Navigate', icon: AppIcons.forward),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: _NavCard(
                        icon: AppIcons.info,
                        label: 'Details',
                        subtitle: 'Named routing demo',
                        color: cs.primaryContainer,
                        onColor: cs.onPrimaryContainer,
                        onTap: () => context.goNamed(ExampleRoutes.details),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _NavCard(
                        icon: AppIcons.settings,
                        label: 'Settings',
                        subtitle: 'Hive CRUD demo',
                        color: cs.secondaryContainer,
                        onColor: cs.onSecondaryContainer,
                        onTap: () => context.goNamed(ExampleRoutes.settings),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppSpacing.lg),

                // ── Typography scale ────────────────────────────────────────
                const _SectionHeader(label: 'Type Scale', icon: AppIcons.edit),
                const SizedBox(height: AppSpacing.sm),
                AppCard(
                  child: Column(
                    children: <Widget>[
                      _TypeRow(
                        label: 'Display',
                        sample: 'Aa',
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      _Divider(),
                      _TypeRow(
                        label: 'Headline',
                        sample: 'Section Header',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      _Divider(),
                      _TypeRow(
                        label: 'Title',
                        sample: 'Card Title',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      _Divider(),
                      _TypeRow(
                        label: 'Body',
                        sample: 'The quick brown fox jumps over the lazy dog.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      _Divider(),
                      _TypeRow(
                        label: 'Label',
                        sample: 'BUTTON LABEL',
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // ── Icon palette ────────────────────────────────────────────
                const _SectionHeader(
                    label: 'Icon Palette', icon: AppIcons.image),
                const SizedBox(height: AppSpacing.sm),
                const AppCard(
                  child: Wrap(
                    spacing: AppSpacing.md,
                    runSpacing: AppSpacing.md,
                    children: <Widget>[
                      _IconDot(icon: AppIcons.home),
                      _IconDot(icon: AppIcons.search),
                      _IconDot(icon: AppIcons.add),
                      _IconDot(icon: AppIcons.edit),
                      _IconDot(icon: AppIcons.delete),
                      _IconDot(icon: AppIcons.save),
                      _IconDot(icon: AppIcons.share),
                      _IconDot(icon: AppIcons.download),
                      _IconDot(icon: AppIcons.upload),
                      _IconDot(icon: AppIcons.success),
                      _IconDot(icon: AppIcons.warning),
                      _IconDot(icon: AppIcons.error),
                      _IconDot(icon: AppIcons.info),
                      _IconDot(icon: AppIcons.mail),
                      _IconDot(icon: AppIcons.notification),
                      _IconDot(icon: AppIcons.user),
                      _IconDot(icon: AppIcons.settings),
                      _IconDot(icon: AppIcons.lock),
                      _IconDot(icon: AppIcons.eye),
                      _IconDot(icon: AppIcons.calendar),
                      _IconDot(icon: AppIcons.clock),
                      _IconDot(icon: AppIcons.filter),
                      _IconDot(icon: AppIcons.refresh),
                      _IconDot(icon: AppIcons.terminal),
                    ],
                  ),
                ),

                const SizedBox(height: AppSpacing.lg),

                // ── Logger demo ─────────────────────────────────────────────
                const _SectionHeader(label: 'Logger', icon: AppIcons.terminal),
                const SizedBox(height: AppSpacing.sm),
                AppButton(
                  label: 'Log a message',
                  icon: AppIcons.terminal,
                  variant: AppButtonVariant.outline,
                  onPressed: () => logger.info('Tapped from HomeScreen'),
                ),

                const SizedBox(height: AppSpacing.xxl),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Private widgets ────────────────────────────────────────────────────────

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
              ),
        ),
      ],
    );
  }
}

class _NavCard extends StatelessWidget {
  const _NavCard({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.color,
    required this.onColor,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final Color color;
  final Color onColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      borderRadius: AppRadius.xlAll,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.xlAll,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon, color: onColor, size: 28),
              const SizedBox(height: AppSpacing.sm),
              Text(
                label,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: onColor,
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                subtitle,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: onColor.withValues(alpha: 0.7),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TypeRow extends StatelessWidget {
  const _TypeRow({
    required this.label,
    required this.sample,
    required this.style,
  });

  final String label;
  final String sample;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            width: 72,
            child: Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: cs.onSurface.withValues(alpha: 0.45),
                  ),
            ),
          ),
          Expanded(
            child: Text(
              sample,
              style: style,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      thickness: 1,
      color: Theme.of(context).colorScheme.outlineVariant,
    );
  }
}

class _IconDot extends StatelessWidget {
  const _IconDot({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: cs.surfaceContainerHighest,
        borderRadius: AppRadius.lgAll,
      ),
      child: Icon(icon, size: 20, color: cs.onSurface),
    );
  }
}
