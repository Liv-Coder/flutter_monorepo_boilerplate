// tool/setup.dart
//
// Interactive rename script for the flutter-monorepo-boilerplate template.
// Run from the repo root: `dart run tool/setup.dart`
//
// What this covers:
//   - Renames apps/example_app/ to apps/<slug>/
//   - Rewrites package name, PascalCase widget name, display name,
//     org identifier, and root monorepo name across all text files
//   - Deletes the stale pubspec.lock so melos bootstrap regenerates it
//
// What this does NOT cover (requires human decisions):
//   - iOS code signing — set Team + Bundle Identifier in Xcode
//   - Android signing keys — configure android/key.properties for release
//   - App icons — replace assets and native icon files per platform
//   - Firebase / cloud config — google-services.json, GoogleService-Info.plist
//
// See SETUP.md for the full guide, manual steps, and troubleshooting.

import 'dart:io';

// ─── Template constants ────────────────────────────────────────────────────
// These values match what exists in the pristine boilerplate.

/// Dart package name used in apps/example_app/pubspec.yaml and imports.
const _templateAppSlug = 'example_app';

/// PascalCase root widget class (ExampleApp in apps/example_app/lib/app.dart).
const _templateAppPascal = 'ExampleApp';

/// Human-readable display name (shown in app launchers, window titles).
const _templateDisplayName = 'Example App';

/// Android namespace / applicationId suffix and iOS bundle ID suffix.
/// The boilerplate uses the repo folder name here, NOT the app slug.
/// Android: com.example.flutter_monorepo_boilerplate
/// iOS:     com.example.flutterMonorepoBoilerplate
const _templateOrgId = 'com.example';
const _templateAndroidSuffix = 'flutter_monorepo_boilerplate';
const _templateIosSuffix = 'flutterMonorepoBoilerplate';

/// Root pubspec.yaml / melos.yaml `name` field.
const _templateRootName = 'flutter_monorepo';

// ─── File-walk config ─────────────────────────────────────────────────────

const _skipDirs = <String>{
  '.git',
  '.dart_tool',
  '.idea',
  '.vscode',
  'build',
  'coverage',
};

const _textExtensions = <String>{
  '.dart',
  '.yaml',
  '.yml',
  '.json',
  '.xml',
  '.plist',
  '.pbxproj',
  '.gradle',
  '.kts',
  '.properties',
  '.kt',
  '.java',
  '.swift',
  '.m',
  '.h',
  '.md',
  '.txt',
  '.gitignore',
  '.cursorrules',
  '.clinerules',
  '.mdc',
};

// ─── Entry point ──────────────────────────────────────────────────────────

Future<void> main(List<String> args) async {
  _header('flutter-monorepo-boilerplate — setup');

  // Sanity checks — must be run from the repo root.
  if (!File('melos.yaml').existsSync() || !File('pubspec.yaml').existsSync()) {
    _die('Run this script from the repo root directory.');
  }
  if (!Directory('apps/$_templateAppSlug').existsSync()) {
    _die(
      'apps/$_templateAppSlug not found.\n'
      'Setup may have already run, or you renamed the folder manually.\n'
      'See SETUP.md → "When not to rename" if you want to add a new app '
      'alongside the existing one.',
    );
  }

  // ── Gather inputs ────────────────────────────────────────────────────────
  stdout.writeln('Answer three prompts. Press Enter to accept the default.\n');

  final displayName = _prompt(
    'App display name  (shown to users)',
    'My App',
  );

  final slug = _prompt(
    'App slug          (snake_case, used as package name)',
    'my_app',
  );

  final org = _prompt(
    'Organization ID   (reverse-DNS, e.g. com.mycompany)',
    'com.mycompany',
  );

  // ── Validate ─────────────────────────────────────────────────────────────
  if (!RegExp(r'^[a-z][a-z0-9_]*$').hasMatch(slug)) {
    _die(
      'Invalid slug "$slug".\n'
      'Must be snake_case: lowercase letters, digits, underscores; '
      'must start with a letter.',
    );
  }
  if (!RegExp(r'^[a-z][a-z0-9]*(\.[a-z][a-z0-9]*)+$').hasMatch(org)) {
    _die(
      'Invalid org "$org".\n'
      'Must be dotted lowercase reverse-DNS, e.g. com.mycompany',
    );
  }

  final pascal = _toPascalCase(slug); // my_app → MyApp
  final camel = _toCamelCase(slug); // my_app → myApp
  final androidSuffix = slug; // my_app  (snake_case)
  final iosSuffix = camel; // myApp   (camelCase)
  final rootName = '${slug}_monorepo'; // my_app_monorepo

  // ── Preview ──────────────────────────────────────────────────────────────
  stdout.writeln('');
  stdout.writeln('Changes that will be applied:');
  stdout.writeln('');
  _row('Folder', 'apps/$_templateAppSlug', 'apps/$slug');
  _row('Package name', _templateAppSlug, slug);
  _row('Root widget', _templateAppPascal, pascal);
  _row('Display name', _templateDisplayName, displayName);
  _row('Org ID', _templateOrgId, org);
  _row('Android suffix', _templateAndroidSuffix, androidSuffix);
  _row('iOS suffix', _templateIosSuffix, iosSuffix);
  _row('Root name', _templateRootName, rootName);
  stdout.writeln('');

  final confirm = _prompt('Proceed? (y/N)', 'n');
  if (confirm.toLowerCase() != 'y') {
    stdout.writeln('Aborted. No changes were made.');
    exit(0);
  }

  stdout.writeln('');

  // ── Step 1: Rename app folder ────────────────────────────────────────────
  _step('Renaming apps/$_templateAppSlug → apps/$slug');
  Directory('apps/$_templateAppSlug').renameSync('apps/$slug');

  // ── Step 2: Build replacement map ────────────────────────────────────────
  // Order matters: longer/more-specific strings before shorter ones that
  // could be substrings (e.g. the iOS suffix before the plain org).
  final replacements = <String, String>{
    // Native identifiers — most specific first
    '$_templateOrgId.$_templateIosSuffix.RunnerTests': '$org.${iosSuffix}Tests',
    '$_templateOrgId.$_templateIosSuffix': '$org.$iosSuffix',
    '$_templateOrgId.$_templateAndroidSuffix': '$org.$androidSuffix',

    // Dart / package identifiers
    _templateAppPascal: pascal,
    _templateDisplayName: displayName,
    _templateAppSlug: slug,

    // Root monorepo name
    _templateRootName: rootName,

    // Bare org (catches any remaining com.example occurrences)
    _templateOrgId: org,
  };

  // ── Step 3: Walk and rewrite text files ───────────────────────────────────
  _step('Rewriting file contents');
  var filesChanged = 0;
  for (final entity in Directory('.').listSync(recursive: true)) {
    if (entity is! File) continue;
    if (_isSkipped(entity.path)) continue;
    if (entity.path.endsWith('pubspec.lock')) continue;
    if (!_isTextFile(entity.path)) continue;

    String content;
    try {
      content = entity.readAsStringSync();
    } catch (_) {
      continue; // binary file slipped through extension check — skip
    }

    var updated = content;
    replacements.forEach((from, to) {
      updated = updated.replaceAll(from, to);
    });

    if (updated != content) {
      entity.writeAsStringSync(updated);
      filesChanged++;
      stdout.writeln('  ✓ ${_rel(entity.path)}');
    }
  }

  // ── Step 4: Delete stale lock ─────────────────────────────────────────────
  _step('Removing stale pubspec.lock');
  final lock = File('pubspec.lock');
  if (lock.existsSync()) {
    lock.deleteSync();
    stdout.writeln('  ✓ pubspec.lock deleted (regenerated by melos bootstrap)');
  } else {
    stdout.writeln('  — pubspec.lock not present, nothing to delete');
  }

  // ── Done ─────────────────────────────────────────────────────────────────
  stdout.writeln('');
  stdout.writeln('━' * 40);
  stdout.writeln('Done. $filesChanged files rewritten.');
  stdout.writeln('');
  stdout.writeln('Next steps:');
  stdout.writeln('');
  stdout.writeln('  1.  melos bootstrap');
  stdout.writeln('  2.  melos run analyze');
  stdout.writeln('  3.  melos run test');
  stdout.writeln('  4.  cd apps/$slug && flutter run');
  stdout.writeln('');
  stdout.writeln('Native config (script cannot do these safely):');
  stdout.writeln('  iOS:     Open apps/$slug/ios/Runner.xcworkspace in Xcode.');
  stdout.writeln('           Runner target → General → set Team & Bundle ID.');
  stdout.writeln('  Android: Verify namespace + applicationId in');
  stdout.writeln('           apps/$slug/android/app/build.gradle.kts.');
  stdout.writeln('');
  stdout.writeln('Run `git diff` to review every change before committing.');
  stdout.writeln('See SETUP.md for the full checklist and troubleshooting.');
}

// ─── Helpers ──────────────────────────────────────────────────────────────

String _prompt(String label, String fallback) {
  stdout.write('  $label [$fallback]: ');
  final line = stdin.readLineSync(encoding: systemEncoding)?.trim() ?? '';
  return line.isEmpty ? fallback : line;
}

void _header(String text) {
  stdout.writeln('');
  stdout.writeln('━' * 40);
  stdout.writeln(text);
  stdout.writeln('━' * 40);
  stdout.writeln('');
}

void _step(String text) {
  stdout.writeln('');
  stdout.writeln('▸ $text');
}

void _row(String label, String from, String to) {
  stdout.writeln('  ${label.padRight(16)} $from → $to');
}

Never _die(String message) {
  stderr.writeln('');
  stderr.writeln('Error: $message');
  exit(1);
}

bool _isSkipped(String path) {
  final p = path.replaceAll(r'\', '/');
  return _skipDirs.any((d) => p.contains('/$d/') || p.startsWith('./$d/'));
}

bool _isTextFile(String path) {
  final lower = path.toLowerCase();
  // Files without extensions that are plaintext by convention
  const noExtFiles = <String>{
    'makefile',
    'dockerfile',
    'gemfile',
    '.gitignore',
    '.gitattributes',
  };
  final base = lower.split(RegExp(r'[/\\]')).last;
  if (noExtFiles.contains(base)) return true;
  return _textExtensions.any(lower.endsWith);
}

String _rel(String path) {
  final p = path.replaceAll(r'\', '/');
  return p.startsWith('./') ? p.substring(2) : p;
}

String _toPascalCase(String snake) => snake
    .split('_')
    .where((s) => s.isNotEmpty)
    .map((s) => s[0].toUpperCase() + s.substring(1))
    .join();

String _toCamelCase(String snake) {
  final p = _toPascalCase(snake);
  return p.isEmpty ? p : p[0].toLowerCase() + p.substring(1);
}
