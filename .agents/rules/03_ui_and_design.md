---
trigger: glob
globs: ["**/*.dart"]
description: "UI, theming, spacing, typography, and responsive layout rules for all Dart files. Full details in DESIGN.md."
---

# Flutter Monorepo — UI & Design System

Full details: `DESIGN.md`. This file is the quick-enforcement reference.

## Colors — Theme.of(context).colorScheme only

```dart
// ✅ correct — adapts to light/dark automatically
final primary = Theme.of(context).colorScheme.primary;
final error   = Theme.of(context).colorScheme.error;
final surface = Theme.of(context).colorScheme.surface;

// ❌ forbidden
const color = Color(0xFF6200EE);
const color = Colors.blue;
```

## Typography — Theme.of(context).textTheme only

```dart
// ✅ correct
Text('Title', style: Theme.of(context).textTheme.titleLarge)
Text('Body',  style: Theme.of(context).textTheme.bodyMedium)

// ❌ forbidden
Text('Title', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
```

## Spacing — AppSpacing tokens

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
SizedBox(height: AppSpacing.md)
Padding(padding: EdgeInsets.all(AppSpacing.sm))

// ❌ forbidden
SizedBox(height: 16)
```

## Radii — AppRadius tokens

```dart
// ✅ correct
BorderRadius.circular(AppRadius.lg)   // 12
AppRadius.mdAll                        // pre-built BorderRadius, md=8

// ❌ forbidden
BorderRadius.circular(12)
```

## Shared components

```dart
import 'package:design_system/design_system.dart';

// ✅ correct
AppButton(label: 'Save', onPressed: _save)
AppCard(child: content)
AppTextField(label: 'Email', controller: _controller)

// ❌ wrong — duplicate in app layer
ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.blue), ...)
```

Need a variant? **Extend the shared component in `design_system`**, not here.

## App theme wiring

```dart
// ✅ correct — in apps/<name>/lib/app.dart
MaterialApp.router(
  theme: AppTheme.light(),
  darkTheme: AppTheme.dark(),
  themeMode: ThemeMode.system,
  routerConfig: appRouter,
)

// ❌ wrong — inline ThemeData in the app
MaterialApp(theme: ThemeData(primaryColor: Colors.purple))
```

## Responsive layouts

```dart
// Screen-level — MediaQuery
final isTablet = MediaQuery.sizeOf(context).width >= 600;

// Widget-level — LayoutBuilder
LayoutBuilder(
  builder: (context, constraints) => constraints.maxWidth >= 600
      ? const TwoColumnLayout()
      : const SingleColumnLayout(),
)
```

**Breakpoints:** `< 600` mobile · `600–839` tablet · `840+` desktop
