---
trigger: always_on
description: "Core startup checklist and monorepo orientation for the Flutter monorepo. Always active."
---

# Flutter Monorepo — Startup Checklist

Before writing any code, always read:

1. `AGENTS.md` — packages table, logging, error handling, architecture, testing.
2. `DESIGN.md` — theming, spacing, tokens, shared components.
3. `packages/<pkg>/README.md` for every package you plan to change.
4. Files directly related to the task (the feature screen, service, or cubit).

If something is unclear: **check the docs first, then ask**. Never guess.

## Repo layout (quick reference)

```
flutter_monorepo_boilerplate/
├── apps/example_app/       ← app-specific wiring only (DI, routing, assets)
└── packages/
    ├── core/               ← Result<T>, DioClient, Environment, KeyValueStore
    ├── design_system/      ← Tokens, themes, AppButton, AppCard, AppTextField
    ├── logger/             ← AppLogger — the only permitted logger
    ├── routing/            ← GoRouter entry points
    └── storage/            ← HiveStorageService
```

## Golden rules

- Shared logic → `packages/`. App-specific wiring → `apps/`.
- Extend a package rather than duplicating logic inside an app.
- Import from the public barrel only: `package:foo/foo.dart` — never `package:foo/src/...`.
- After any `pubspec.yaml` change: `melos bootstrap`, not `flutter pub get`.
- Doc changes → update `AGENTS.md`, `GEMINI.md`, and `DESIGN.md` in the same PR.
