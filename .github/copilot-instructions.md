# GitHub Copilot Instructions

## Project
Flutter monorepo managed with Melos. Five packages, one example app.

## When generating code
- Import `package:core/core.dart`, `package:design_system/design_system.dart`, or `package:logger/logger.dart` — never relative imports across package boundaries.
- Use `Result<T>` for fallible operations. Pattern match on `Success` / `Failure`.
- Use `AppLogger` for all logging. No `print()`.
- Use design system components (`AppButton`, `AppTextField`, `AppCard`) before raw Material widgets.
- Use `AppSpacing.*` and `AppRadius.*` tokens. No hardcoded padding or border radius.

## When generating tests
- Widget tests: `testWidgets` with `pumpWidget`.
- Pure Dart tests: `test` with `expect`.
- Place tests in `test/` mirroring `lib/` structure.

## When editing pubspec.yaml
- After any dependency change, run `melos bootstrap`.
- Use `path` dependencies for local packages.
