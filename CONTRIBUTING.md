# Contributing

## Setup

```bash
git clone https://github.com/your-org/flutter_monorepo.git
cd flutter_monorepo
melos bootstrap
```

## Workflow

1. Create a branch: `git checkout -b feat/your-feature`
2. Write code in the appropriate package under `packages/` or `apps/`.
3. Add tests in `test/` mirroring `lib/`.
4. Run `melos run analyze` and `melos run test`.
5. Commit with conventional commit format: `feat(core): add retry interceptor`.
6. Open a PR against `main`.

## Package Boundaries

- **Never** import from another package using a relative path. Use `package:core/core.dart`, etc.
- If a utility is needed by two or more packages, move it to `core`.
- If a widget is needed by two or more apps, move it to `design_system`.

## Code Style

- Follow the lint rules in `analysis_options.yaml`.
- Public APIs require doc comments.
- Prefer `const` and `final`. No `var` where `final` works.
- Use design tokens (`AppSpacing`, `AppRadius`, `AppColors`) instead of magic numbers.

## Testing

- Every package must have tests for its public API.
- Widget tests use `flutter_test`. Pure Dart tests use `package:test`.
- Coverage target: 80% per package.

## Release

```bash
melos version --yes
melos publish --no-dry-run
```

## License

By contributing, you agree that your contributions will be licensed under the MIT License.
