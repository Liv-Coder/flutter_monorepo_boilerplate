# Design System & UI Architecture

This document is the source of truth for all UI and design decisions in this
Flutter monorepo. AI agents, contributors, and reviewers should consult it
before writing or reviewing any widget code.

> See also: `AGENTS.md` for the full agent startup checklist, architecture
> rules, logging, and error-handling guidelines.

---

## 1. The Design System Package

Everything UI-related starts in `packages/design_system`. Import it once:

```dart
import 'package:design_system/design_system.dart';
```

The package exports:

| Export | Purpose |
|---|---|
| `AppTheme.light()` / `AppTheme.dark()` | Material 3 `ThemeData` — wire into `MaterialApp` |
| `AppColors` | Raw color constants (use via theme, not directly) |
| `AppTypography` | `TextStyle` constants (use via `textTheme`, not directly) |
| `AppSpacing` | Spacing scale (xs→xxxl) |
| `AppRadius` | Corner radius scale + pre-built `BorderRadius` values |
| `AppButton` | Primary action button |
| `AppCard` | Surface card with consistent elevation and rounding |
| `AppTextField` | Styled text input |

---

## 2. Colors

Colors are **only** read from `Theme.of(context).colorScheme`. The raw
`AppColors` constants exist to build the theme — do not reference them in
feature code.

```dart
// ✅ correct — adapts to light/dark mode automatically
final primaryColor = Theme.of(context).colorScheme.primary;
final onPrimary    = Theme.of(context).colorScheme.onPrimary;
final errorColor   = Theme.of(context).colorScheme.error;
final bgColor      = Theme.of(context).colorScheme.surface;

// ❌ wrong — hardcoded, breaks dark mode
const color = Color(0xFF6750A4);
const color = Colors.blue;
import 'package:design_system/design_system.dart';
final color = AppColors.primary; // only valid inside design_system itself
```

### Color role quick-reference

| Role | Token |
|---|---|
| Brand / interactive | `colorScheme.primary` |
| On primary (icon/text over primary) | `colorScheme.onPrimary` |
| Secondary accent | `colorScheme.secondary` |
| Destructive / error | `colorScheme.error` |
| Card / sheet background | `colorScheme.surfaceContainerHighest` |
| Scaffold background | `colorScheme.surface` |
| Muted / disabled text | `colorScheme.onSurface.withOpacity(0.38)` |

---

## 3. Typography

Text styles come from `Theme.of(context).textTheme`. The mapping follows
Material 3 type scale:

```dart
// ✅ correct
Text('Screen title', style: Theme.of(context).textTheme.titleLarge)
Text('Body copy',    style: Theme.of(context).textTheme.bodyMedium)
Text('Caption',      style: Theme.of(context).textTheme.labelSmall)

// ❌ wrong — hardcoded, bypasses scale
Text('Title', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
```

### Type scale quick-reference

| Token | Typical use |
|---|---|
| `displayLarge` | Hero numbers, marketing headlines |
| `headlineMedium` | Page / section headings |
| `titleLarge` | App bar titles, card headers |
| `bodyLarge` | Primary reading content |
| `bodyMedium` | Secondary / supporting text |
| `labelLarge` | Button labels |
| `labelSmall` | Captions, badges, metadata |

---

## 4. Spacing

Use `AppSpacing` constants everywhere. No magic numbers.

| Token | Value |
|---|---|
| `AppSpacing.xs` | 4 |
| `AppSpacing.sm` | 8 |
| `AppSpacing.md` | 16 |
| `AppSpacing.lg` | 24 |
| `AppSpacing.xl` | 32 |
| `AppSpacing.xxl` | 48 |
| `AppSpacing.xxxl` | 64 |

```dart
// ✅ correct
const SizedBox(height: AppSpacing.md)
Padding(padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg))
Column(children: [...], mainAxisSpacing: AppSpacing.sm)

// ❌ wrong
const SizedBox(height: 16)
Padding(padding: const EdgeInsets.all(24))
```

---

## 5. Corner Radii

Use `AppRadius` constants. Pre-built `BorderRadius` values are also available.

| Token | Value |
|---|---|
| `AppRadius.sm` | 4 |
| `AppRadius.md` | 8 |
| `AppRadius.lg` | 12 |
| `AppRadius.xl` | 16 |
| `AppRadius.full` | 999 (pill / fully circular) |

```dart
// ✅ correct — use pre-built BorderRadius
Container(
  decoration: BoxDecoration(borderRadius: AppRadius.lgAll),
)

// ✅ also correct — construct from scalar
BorderRadius.circular(AppRadius.md)

// ❌ wrong
BorderRadius.circular(12)
BorderRadius.all(Radius.circular(8))  // inline magic number
```

---

## 6. Shared Components

Before building a new widget, check whether one already exists in
`packages/design_system/lib/src/components/`.

| Widget | Purpose |
|---|---|
| `AppButton` | Primary / secondary CTA button |
| `AppCard` | Standard card with shadow and rounded corners |
| `AppTextField` | Styled, validated text input |

If a shared component doesn't cover your use case, **extend it in the package**
rather than creating an app-specific copy.

```dart
// ✅ correct — uses shared component
AppButton(
  label: 'Continue',
  onPressed: _onContinue,
)

// ❌ wrong — duplicate implementation in the app
ElevatedButton(
  style: ElevatedButton.styleFrom(
    backgroundColor: const Color(0xFF6750A4),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
  ),
  onPressed: _onContinue,
  child: const Text('Continue'),
)
```

---

## 7. Theming your App

Wire `AppTheme` into `MaterialApp` at app startup. Do not build a custom
`ThemeData` inline in the app.

```dart
// ✅ correct — apps/example_app/lib/app.dart
import 'package:design_system/design_system.dart';

MaterialApp.router(
  theme: AppTheme.light(),
  darkTheme: AppTheme.dark(),
  themeMode: ThemeMode.system,
  routerConfig: appRouter,
)

// ❌ wrong — inline theme definition in the app
MaterialApp(
  theme: ThemeData(
    primaryColor: Colors.purple,
    fontFamily: 'Roboto',
  ),
)
```

---

## 8. Responsive Layouts

Every screen must be usable on mobile, tablet, and (where applicable) desktop.

```dart
// Screen-level: use MediaQuery for broad breakpoints
class MyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    return width >= 840
        ? const _DesktopLayout()
        : width >= 600
            ? const _TabletLayout()
            : const _MobileLayout();
  }
}

// Widget-level: use LayoutBuilder when adapting to parent, not screen
LayoutBuilder(
  builder: (context, constraints) {
    final crossAxisCount = (constraints.maxWidth / 200).floor().clamp(1, 4);
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
      ),
      ...
    );
  },
)
```

**Breakpoints (reference):**

| Range | Form factor |
|---|---|
| < 600 px | Mobile (phone portrait) |
| 600–839 px | Tablet (phone landscape / small tablet) |
| 840+ px | Desktop / large tablet |

---

## 9. What Is Prohibited

| Prohibited | Use instead |
|---|---|
| `Color(0xFFxxxxxx)` in feature code | `Theme.of(context).colorScheme.*` |
| `Colors.*` (e.g. `Colors.blue`) | `Theme.of(context).colorScheme.*` |
| `TextStyle(fontSize: ...)` in feature code | `Theme.of(context).textTheme.*` |
| Magic spacing numbers (`16`, `24`) | `AppSpacing.*` |
| Magic radius numbers (`8`, `12`) | `AppRadius.*` |
| `print()` / `debugPrint()` | `AppLogger` from `package:logger` |
| App-specific copies of shared widgets | Extend the shared widget in `design_system` |
| Inline `ThemeData` in `MaterialApp` | `AppTheme.light()` / `AppTheme.dark()` |

---

## 10. Adding to the Design System

When you need a new token, component, or theme extension:

1. Add it to the correct file in `packages/design_system/lib/src/`.
2. Export it from `packages/design_system/lib/design_system.dart`.
3. Write a widget test in `packages/design_system/test/`.
4. Update this `DESIGN.md` if the addition introduces a new usage pattern.
