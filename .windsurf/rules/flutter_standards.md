# Flutter Monorepo — Agent & Contributor Rules

> This file is the compact form of `AGENTS.md` and `DESIGN.md`.
> For full details and code examples, read those files first.

---

## Before You Start

Read `AGENTS.md`, `DESIGN.md`, and the README for every package you touch.
If something is unclear — check the docs, then ask. Never guess.

---

## Must-Use Packages

| Need | Package | Key API |
|---|---|---|
| Logging | `logger` | `AppLogger.info/debug/warning/error/fatal` |
| HTTP | `core` | `DioClient` |
| Error handling | `core` | `Result<T>`, `Success`, `Failure` |
| Environment | `core` | `Environment.dev/.staging/.prod` |
| Local storage | `storage` | `HiveStorageService` |
| Navigation | `routing` | GoRouter via `routing` package |
| UI tokens | `design_system` | `AppSpacing`, `AppRadius`, `AppColors` |
| Shared widgets | `design_system` | `AppButton`, `AppCard`, `AppTextField` |

- Import only from the public barrel: `package:foo/foo.dart`
- Never use deep-link imports: `package:foo/src/...`
- Missing feature in a package? Extend it there, not in the app.

---

## Logging

```dart
// ✅
logger.info('User signed in — userId: ${user.id}');
logger.error('Request failed', exception, stackTrace);

// ❌
print('...');  debugPrint('...');
```

- Never log passwords, tokens, or PII.
- Release builds: `minLevel: LogLevel.info` or higher.

---

## UI & Design System

```dart
// ✅ colors
Theme.of(context).colorScheme.primary

// ✅ typography
Theme.of(context).textTheme.bodyLarge

// ✅ spacing
SizedBox(height: AppSpacing.md)       // 16
SizedBox(width: AppSpacing.lg)        // 24

// ✅ radii
BorderRadius.circular(AppRadius.lg)   // 12

// ❌ never
Colors.blue  |  Color(0xFF...)  |  TextStyle(fontSize: 16)  |  16  |  12
```

---

## Error Handling

```dart
// ✅ return Result at boundaries
Future<Result<User>> fetchUser(String id) async {
  try {
    return Success(User.fromJson(await _api.getUser(id)));
  } catch (e, st) {
    _logger.error('fetchUser failed', e, st);
    return Failure(e);
  }
}

// ❌ never throw across feature boundaries
```

---

## Architecture

- `apps/` → app-specific wiring only (DI, routing entry, flavors, assets).
- `packages/` → all reusable logic. Packages never depend on `apps/`.
- Feature-first structure. No cross-feature imports.
- After pubspec changes: `melos bootstrap`, not `flutter pub get`.

---

## Testing & Commits

```sh
melos run format && melos run analyze && melos run test
```

Commits: `type(scope): description`  
e.g. `feat(core): add retry`, `fix(design_system): card radius`

---

## Doc Maintenance

Rule changes → update `AGENTS.md`, `GEMINI.md`, and `DESIGN.md` in the same PR.
