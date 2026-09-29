import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:storage/storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late Directory tempDir;
  late HiveStorageService storage;

  setUpAll(() {
    tempDir = Directory.systemTemp.createTempSync('hive_storage_test_');
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (MethodCall methodCall) async => tempDir.path,
    );
  });

  setUp(() async {
    storage = await HiveStorageService.init();
  });

  tearDown(() async {
    await storage.close();
  });

  tearDownAll(() {
    if (tempDir.existsSync()) {
      tempDir.deleteSync(recursive: true);
    }
  });

  test('init opens all three declared boxes', () {
    expect(storage.get(StorageBoxes.settings, 'non_existent'), isNull);
    expect(storage.get(StorageBoxes.cache, 'non_existent'), isNull);
    expect(storage.get(StorageBoxes.userData, 'non_existent'), isNull);
  });

  test('put + get roundtrip works', () async {
    await storage.put(StorageBoxes.cache, 'test_key', 'test_value');
    expect(storage.get(StorageBoxes.cache, 'test_key'), equals('test_value'));
  });

  test('setString/getString and setInt/getInt and setBool/getBool roundtrip',
      () async {
    await storage.setString(
      StorageBoxes.settings,
      StorageKeys.themeMode,
      'dark',
    );
    expect(
      storage.getString(StorageBoxes.settings, StorageKeys.themeMode),
      equals('dark'),
    );

    await storage.setInt(StorageBoxes.settings, StorageKeys.lastSyncAt, 42);
    expect(
      storage.getInt(StorageBoxes.settings, StorageKeys.lastSyncAt),
      equals(42),
    );

    await storage.setBool(
      StorageBoxes.settings,
      StorageKeys.onboardingComplete,
      true,
    );
    expect(
      storage.getBool(
        StorageBoxes.settings,
        StorageKeys.onboardingComplete,
      ),
      isTrue,
    );
  });

  test('delete removes a value', () async {
    await storage.setString(
      StorageBoxes.settings,
      StorageKeys.themeMode,
      'system',
    );
    expect(
      storage.getString(StorageBoxes.settings, StorageKeys.themeMode),
      equals('system'),
    );

    await storage.delete(StorageBoxes.settings, StorageKeys.themeMode);
    expect(
      storage.getString(StorageBoxes.settings, StorageKeys.themeMode),
      isNull,
    );
  });

  test('clear empties a box', () async {
    await storage.setString(StorageBoxes.cache, 'key1', 'val1');
    await storage.setString(StorageBoxes.cache, 'key2', 'val2');

    await storage.clear(StorageBoxes.cache);

    expect(storage.getString(StorageBoxes.cache, 'key1'), isNull);
    expect(storage.getString(StorageBoxes.cache, 'key2'), isNull);
  });

  test('unknown box name throws StorageException', () {
    expect(
      () => storage.get('unknown_box', 'key'),
      throwsA(isA<StorageException>()),
    );
  });
}
