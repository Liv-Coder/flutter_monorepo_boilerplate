---
trigger: glob
globs: ["**/*.dart"]
description: "Logging and error-handling rules for all Dart files in the Flutter monorepo."
---

# Flutter Monorepo — Logging & Error Handling

## Logging — AppLogger only

Use `AppLogger` from `package:logger/logger.dart`. **`print()` and `debugPrint()` are
never permitted in production code.**

```dart
// ✅ correct
import 'package:logger/logger.dart';

final logger = AppLogger(minLevel: LogLevel.debug);

logger.info('User signed in — userId: ${user.id}');
logger.warning('Cache miss — fetching from network');
logger.error('Payment failed', exception, stackTrace);
logger.fatal('Unrecoverable state', error, st);

// ❌ wrong — forbidden
print('user: ${user.id}');
debugPrint('something happened');
```

### Level guide

| Level | When to use |
|---|---|
| `trace` | Fine-grained step-by-step (rarely needed) |
| `debug` | Development noise, verbose state |
| `info` | App lifecycle events, user actions |
| `warning` | Degraded / unexpected but recoverable |
| `error` | Operation failed, user impact |
| `fatal` | Process about to crash or data corrupted |

### What to never log

- Passwords, API tokens, or session credentials.
- PII: names, emails, phone numbers, addresses.
- Raw HTTP response bodies if they may contain any of the above.

### Release builds

Set `minLevel: LogLevel.info` (or higher) in production flavors.

---

## Error handling — Result<T>

Use `Result<T>` from `package:core/core.dart` at **service and repository
boundaries**. Do not throw exceptions across feature boundaries.

```dart
// ✅ correct — returns Result, caller decides
import 'package:core/core.dart';

Future<Result<User>> fetchUser(String id) async {
  try {
    final data = await _api.getUser(id);
    return Success(User.fromJson(data));
  } catch (e, st) {
    _logger.error('fetchUser failed — id: $id', e, st);
    return Failure(e);
  }
}

// Caller uses pattern matching — no nested try/catch in UI
final result = await fetchUser(id);
switch (result) {
  case Success(:final value): showUser(value);
  case Failure(:final error): showError(error);
}

// ❌ wrong — throws across feature boundary
Future<User> fetchUser(String id) async =>
    User.fromJson(await _api.getUser(id));
```
