# Flutter Monorepo Boilerplate

Production-ready Flutter monorepo with modular packages, Melos orchestration, and CI/CD. Inspired by `flutter_boilerplate_project`, organized as a multi-package workspace.

## Structure

```
flutter_monorepo/
├── apps/example_app/          # Sample Flutter app
├── packages/core/             # Dio networking, Result, storage, env config
├── packages/design_system/    # Tokens, themes, reusable components
├── packages/logger/           # Multi-level logging, pure Dart
├── melos.yaml                 # Melos configuration
├── pubspec.yaml               # Workspace root
├── analysis_options.yaml      # Shared lint ruleset
├── .cursorrules               # Cursor AI rules
└── .github/copilot-instructions.md
```

## Packages

| Package | Description | Depends on |
|---|---|---|
| `core` | Networking (Dio), error handling (`Result<T>`), local storage (`KeyValueStore`), environment config | Flutter, Dio, shared_preferences |
| `design_system` | Color palette, typography, spacing, radius, themes (light/dark), `AppButton`, `AppTextField`, `AppCard` | Flutter |
| `logger` | Seven-level logging (trace→fatal), pretty and JSON printers, configurable output | Pure Dart |

## Getting Started

### Prerequisites

- Flutter 3.27+ (`flutter --version`)
- Dart 3.6+ (`dart --version`)
- Melos: `dart pub global activate melos`

### Bootstrap

```bash
git clone https://github.com/your-org/flutter_monorepo.git
cd flutter_monorepo
melos bootstrap
```

### Run the example app

```bash
cd apps/example_app
flutter run
```

### Common commands

| Command | What it does |
|---|---|
| `melos bootstrap` | Resolve all dependencies, link local packages |
| `melos run analyze` | Run `flutter analyze` in every package |
| `melos run test` | Run tests in every package with a `test/` directory |
| `melos run format` | Verify formatting across the workspace |
| `melos run fix` | Apply automated fixes across all packages |
| `melos run test:coverage` | Run tests with coverage |

## Adding a New Package

```bash
mkdir -p packages/new_package/lib/src
# create pubspec.yaml, lib/new_package.dart, analysis_options.yaml
# add path to root pubspec.yaml workspace list
melos bootstrap
```

## Adding a New App

```bash
flutter create apps/new_app --org com.yourorg
# add path to root pubspec.yaml workspace list
# add path dependencies on packages
melos bootstrap
```

## AI Rules

- **Cursor** reads `.cursorrules` at the repo root.
- **GitHub Copilot** reads `.github/copilot-instructions.md`.
- **Claude Code** reads `CLAUDE.md` if present — create one referencing `.cursorrules` if needed.

## Contribution Guidelines

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT — see [LICENSE](LICENSE).
