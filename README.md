# Flutter Monorepo Boilerplate

Production-ready Flutter monorepo with modular packages, Melos orchestration, and CI/CD. Inspired by `flutter_boilerplate_project`, organized as a multi-package workspace.

## Using this template

**Clone to start a new project:**

1. Click **Use this template** on GitHub (or `git clone` if you want the full history).
2. From the repo root, run:
   ```bash
   dart run tool/setup.dart
   ```
3. Follow the three prompts (display name, slug, org). The script renames `example_app`, rewrites identifiers, and removes the stale lock file.
4. Run `melos bootstrap` then `melos run test` to confirm everything is wired.

Full guide — including manual steps, native config (iOS signing, Android keys, app icons), and troubleshooting — see [SETUP.md](SETUP.md).

**Just want to try it first?** Skip `setup.dart` and run the demo directly:

```bash
melos bootstrap
cd apps/example_app && flutter run
```

---

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
├── SETUP.md                   # Rename & setup guide
├── tool/setup.dart            # Interactive rename script
├── .cursorrules               # Cursor AI rules
└── .github/copilot-instructions.md
```

## Packages

| Package         | Description                                                                                             | Depends on                       |
| --------------- | ------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `core`          | Networking (Dio), error handling (`Result<T>`), local storage (`KeyValueStore`), environment config     | Flutter, Dio, shared_preferences |
| `design_system` | Color palette, typography, spacing, radius, themes (light/dark), `AppButton`, `AppTextField`, `AppCard` | Flutter                          |
| `logger`        | Seven-level logging (trace→fatal), pretty and JSON printers, configurable output                        | Pure Dart                        |

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

| Command                   | What it does                                        |
| ------------------------- | --------------------------------------------------- |
| `melos bootstrap`         | Resolve all dependencies, link local packages       |
| `melos run analyze`       | Run `flutter analyze` in every package              |
| `melos run test`          | Run tests in every package with a `test/` directory |
| `melos run format`        | Verify formatting across the workspace              |
| `melos run fix`           | Apply automated fixes across all packages           |
| `melos run test:coverage` | Run tests with coverage                             |

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

- **Antigravity** reads `AGENTS.md` at the root and `.agents/rules/*.md` (modular, trigger-gated rules).
- **Gemini CLI** reads `GEMINI.md` at the root (identical to `AGENTS.md`).
- **Cursor** reads `.cursorrules` (flat) and `.cursor/rules/*.mdc` (per-concern rules).
- **Windsurf** reads `.windsurf/rules/flutter_standards.md`.
- **GitHub Copilot** reads `.github/copilot-instructions.md`.
- **Claude Code / Codex** reads `AGENTS.md` (the Anthropic-standard filename).

## Contribution Guidelines

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT — see [LICENSE](LICENSE).
