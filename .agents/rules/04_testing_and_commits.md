---
trigger: glob
globs: ["**/*_test.dart", "**/test/**"]
description: "Testing conventions and pre-commit checklist for the Flutter monorepo. Active when viewing or editing test files."
---

# Flutter Monorepo — Testing & Commits

## Test structure

Mirror `lib/` exactly in `test/`:

```
packages/core/
├── lib/src/result.dart
└── test/result_test.dart      ← mirrors lib/src/
```

- **Widget tests**: use `flutter_test`.
- **Pure Dart packages**: use `package:test`.
- Every feature change or new package needs a corresponding test.

```dart
// packages/core/test/result_test.dart
import 'package:core/core.dart';
import 'package:test/test.dart';

void main() {
  test('Success holds value', () {
    const r = Success(42);
    expect(r.value, 42);
  });

  test('Failure holds error', () {
    const r = Failure<int>('network error');
    expect(r.error, 'network error');
  });
}
```

## Pre-commit checklist (all three must pass)

```sh
melos run format   # dart format --set-exit-if-changed .
melos run analyze  # flutter analyze
melos run test     # flutter test across all packages
```

## Commit format

```
type(scope): short description
```

| Type | When |
|---|---|
| `feat` | New feature |
| `fix` | Bug fix |
| `chore` | Build, deps, config (no behavior change) |
| `refactor` | Restructure without behavior change |
| `test` | Tests only |
| `docs` | Documentation only |

Scope = package name: `feat(core): add retry interceptor` · `fix(design_system): card radius token`
