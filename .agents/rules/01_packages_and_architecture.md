---
trigger: always_on
description: "Must-use packages, import rules, and architecture constraints for the Flutter monorepo."
---

# Flutter Monorepo — Packages & Architecture

## Must-use packages

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

**If a package doesn't have what you need — extend it there, not in the app.**

## Import rules

```dart
// ✅ correct — public barrel only
import 'package:core/core.dart';
import 'package:logger/logger.dart';
import 'package:design_system/design_system.dart';

// ❌ wrong — deep-link import, breaks encapsulation
import 'package:core/src/result.dart';
import 'package:logger/src/app_logger.dart';
```

## Architecture constraints

- **Feature-first structure** inside `apps/` and `packages/`.
- `apps/` holds only: DI setup, routing entry, flavors, assets — nothing reusable.
- `packages/` holds all reusable logic. Packages **never** import from `apps/`.
- **No cross-feature imports.** Features talk through shared packages or public APIs.

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

## Adding a new package

1. Create `packages/<name>/` with `pubspec.yaml`, `lib/<name>.dart`, `test/`.
2. Register it in the root `pubspec.yaml` workspace section.
3. Run `melos bootstrap`.
4. Add a `README.md` covering purpose and public API.
