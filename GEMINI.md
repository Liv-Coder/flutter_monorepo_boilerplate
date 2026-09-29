# AI Agent Guidelines

> **Gemini CLI users:** this file and `GEMINI.md` are kept in sync.
> Both contain identical rules — `GEMINI.md` exists so the Gemini CLI auto-loads it.
> If you update one, update the other in the same PR.

---

## Before You Start

Before touching any code you **must** read:

1. This file (`AGENTS.md`) **and** `DESIGN.md` — they are the source of truth.
2. The `README.md` of every package you plan to change.
3. Any files directly related to your task (feature module, screen, service).

If something is unclear: **check the docs first, then ask**. Never guess, and never assume a pattern exists that you haven't seen in the codebase.

```
# Minimum read list for any task
AGENTS.md                       <- you are here
DESIGN.md                       <- UI / design system rules
packages/<pkg>/README.md        <- for every package you touch
```

---

## Repo Structure at a Glance

```
flutter_monorepo_boilerplate/
├── apps/
│   └── example_app/            # App-specific code only
├── packages/
│   ├── core/                   # Result<T>, DioClient, Environment, KeyValueStore
│   ├── design_system/          # Tokens, themes, shared widgets
│   ├── logger/                 # AppLogger — the only way to log
│   ├── routing/                # GoRouter setup and route definitions
│   └── storage/                # Hive-backed persistence (HiveStorageService)
├── AGENTS.md                   <- this file
├── GEMINI.md                   <- identical copy for Gemini CLI
├── DESIGN.md                   <- UI & design system rules
└── melos.yaml                  <- monorepo scripts
```

**Rule of thumb:** if two apps could ever need it → it belongs in `packages/`.

---

## Must-Use Packages

This is a Melos-managed monorepo. Shared logic lives in `packages/`. Do **not**
re-implement anything already provided there.

| Need | Package | Key API |
|---|---|---|
| Logging | `logger` | `AppLogger.info/debug/warning/error/fatal` |
| HTTP / networking | `core` | `DioClient` |
| Error handling | `core` | `Result<T>` → `Success<T>` / `Failure<T>` |
| App environment | `core` | `Environment.dev/.staging/.prod` |
| Local storage | `storage` | `HiveStorageService` |
| Navigation | `routing` | GoRouter via `routing` package |
| UI tokens & themes | `design_system` | `AppSpacing`, `AppRadius`, `AppColors`, `AppTypography`, `AppIcons`, `AppFonts` |
| Shared widgets | `design_system` | `AppButton`, `AppCard`, `AppTextField` |

> **If a shared package is missing a feature, extend it there — not in the app.**
> Add to the package in a separate PR, then consume the new API from the app.

### Importing packages

Always import from the public barrel file. Never use deep-link imports.

```dart
// ✅ correct
import 'package:core/core.dart';
import 'package:logger/logger.dart';
import 'package:design_system/design_system.dart';

// ❌ wrong — breaks encapsulation
import 'package:core/src/result.dart';
import 'package:logger/src/app_logger.dart';
```

---

## Logging

Use `AppLogger` from `package:logger/logger.dart`. **Never use `print()`** in
production code.

```dart
// ✅ correct — structured, contextual logging
final logger = AppLogger(minLevel: LogLevel.debug);

logger.info('User signed in — userId: ${user.id}');
logger.warning('Cache miss — fetching from network');
logger.error('Payment failed', exception, stackTrace);

// ❌ wrong
print('User signed in: ${user.id}');
debugPrint('something happened');
```

**Logging rules:**
- Include meaningful context: what happened, where, relevant IDs.
- **Never log** passwords, tokens, PII, or raw HTTP response bodies containing sensitive fields.
- `LogLevel.debug` → development noise. `LogLevel.info` → lifecycle events.
  `LogLevel.error`/`fatal` → unrecoverable states.
- Set `minLevel: LogLevel.info` (or higher) for release builds.

---

## UI & Design System

Full details in `DESIGN.md`. Summary below.

### Colors — always from the theme

```dart
// ✅ correct
final primary = Theme.of(context).colorScheme.primary;
final error   = Theme.of(context).colorScheme.error;
final surface = Theme.of(context).colorScheme.surface;

// ❌ wrong
const color = Color(0xFF6200EE);
const color = Colors.blue;
```

### Typography — always from the theme

```dart
// ✅ correct
Text('Hello', style: Theme.of(context).textTheme.bodyLarge)
Text('Title', style: Theme.of(context).textTheme.titleLarge)

// ❌ wrong
Text('Hello', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w400))
```

### Spacing & radii — always use tokens

```dart
import 'package:design_system/design_system.dart';

// ✅ correct
SizedBox(height: AppSpacing.md)                      // 16
SizedBox(width: AppSpacing.lg)                       // 24
Padding(padding: EdgeInsets.all(AppSpacing.sm))      // 8
BorderRadius.circular(AppRadius.lg)                  // 12
BorderRadius.circular(AppRadius.full)                // pill

// ❌ wrong
SizedBox(height: 16)
BorderRadius.circular(12)
```

### Responsive layouts

```dart
// Screen-level breakpoints
final width = MediaQuery.sizeOf(context).width;
final isTablet = width >= 600;

// Widget-level adaptation
LayoutBuilder(
  builder: (context, constraints) {
    return constraints.maxWidth >= 600
        ? const TwoColumnLayout()
        : const SingleColumnLayout();
  },
)
```

### Shared widgets — use, don't reinvent

```dart
import 'package:design_system/design_system.dart';

// ✅ correct
AppButton(label: 'Save', onPressed: _save);
AppCard(child: content);
AppTextField(label: 'Email', controller: _controller);

// ❌ wrong — reinventing in the app layer
ElevatedButton(
  style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
  onPressed: _save,
  child: const Text('Save'),
)
```

---

## Error Handling

Use `Result<T>` from `package:core/core.dart` at service/repository boundaries.
Do not throw exceptions across feature boundaries.

```dart
// ✅ correct — caller decides how to handle
Future<Result<User>> fetchUser(String id) async {
  try {
    final data = await _api.getUser(id);
    return Success(User.fromJson(data));
  } catch (e, st) {
    _logger.error('fetchUser failed', e, st);
    return Failure(e);
  }
}

// Caller pattern-matches cleanly
final result = await fetchUser(id);
switch (result) {
  case Success(:final value): showUser(value);
  case Failure(:final error): showError(error);
}

// ❌ wrong — throws across boundaries; caller must guess what to catch
Future<User> fetchUser(String id) async =>
    User.fromJson(await _api.getUser(id));
```

---

## Architecture & Imports

- **Feature-first structure** inside both `apps/` and `packages/`.
- `apps/` holds only app-specific wiring: DI setup, routing entry points, flavors, assets.
- `packages/` holds all reusable logic. Packages **never** depend on `apps/`.
- **No cross-feature imports.** Features communicate through shared packages or public APIs only.
- After any `pubspec.yaml` change: run `melos bootstrap`, not `flutter pub get`.

```
apps/example_app/lib/
├── features/
│   ├── home/
│   │   ├── home_screen.dart
│   │   └── home_cubit.dart
│   └── profile/
│       └── profile_screen.dart
└── app.dart
```

---

## Testing

- Every feature or package change needs a corresponding test.
- Widget tests: `flutter_test` in `test/`, mirroring `lib/`.
- Pure Dart packages: `package:test`.
- Run `melos run test` before opening a PR.

```dart
// packages/core/test/result_test.dart
void main() {
  test('Success holds value', () {
    const r = Success(42);
    expect(r.value, 42);
  });

  test('Failure holds error', () {
    const r = Failure<int>('oops');
    expect(r.error, 'oops');
  });
}
```

---

## Before You Commit

Run all three and fix any failures:

```sh
melos run format   # dart format --set-exit-if-changed
melos run analyze  # flutter analyze
melos run test     # flutter test across all packages
```

Commit message format: `type(scope): short description`

```
feat(core): add timeout retry interceptor
fix(design_system): correct AppCard elevation token
chore(routing): update GoRouter to v14
test(logger): add coverage for LogLevel filtering
```

---

## Adding a New Package

1. Create `packages/<name>/` with `pubspec.yaml`, `lib/<name>.dart`, and `test/`.
2. Register it in the **root** `pubspec.yaml` workspace section.
3. Run `melos bootstrap`.
4. Add a `README.md` explaining the package's purpose and public API.

> New packages must never depend on `apps/`. They may depend on other `packages/`.

---

## Doc Maintenance

If a rule changes, update **both** `AGENTS.md` and `GEMINI.md` in the same PR.
Update `DESIGN.md` too if the change affects UI or design-system rules.
