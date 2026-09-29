import 'package:hive_ce_flutter/hive_flutter.dart';

import 'adapters.dart';
import 'storage_exception.dart';
import 'storage_keys.dart';

/// Centralized Hive-backed storage service.
///
/// All boxes are opened once at app startup via [HiveStorageService.init].
/// Consumers never touch Hive directly — they go through this service.
class HiveStorageService {
  HiveStorageService._(this._boxes);

  final Map<String, Box<dynamic>> _boxes;

  /// Initialize Hive, register adapters, and open all declared boxes.
  /// Call once in `main()` before `runApp`.
  static Future<HiveStorageService> init() async {
    await Hive.initFlutter();
    await registerStorageAdapters();

    final boxes = <String, Box<dynamic>>{};
    for (final name in <String>[
      StorageBoxes.settings,
      StorageBoxes.cache,
      StorageBoxes.userData,
    ]) {
      boxes[name] = await Hive.openBox<dynamic>(name);
    }
    return HiveStorageService._(boxes);
  }

  Box<dynamic> _box(String name) {
    final box = _boxes[name];
    if (box == null) {
      throw StorageException(
        'Box "$name" is not opened. Add it to HiveStorageService.init().',
      );
    }
    return box;
  }

  // --- Generic CRUD ---

  /// Stores a [value] under [key] in the specified [boxName].
  Future<void> put(String boxName, String key, dynamic value) async {
    try {
      await _box(boxName).put(key, value);
    } catch (e) {
      throw StorageException('put failed for $boxName/$key', cause: e);
    }
  }

  /// Retrieves a value by [key] from the specified [boxName].
  dynamic get(String boxName, String key) => _box(boxName).get(key);

  /// Deletes a value by [key] from the specified [boxName].
  Future<void> delete(String boxName, String key) async {
    try {
      await _box(boxName).delete(key);
    } catch (e) {
      throw StorageException('delete failed for $boxName/$key', cause: e);
    }
  }

  /// Clears all entries from the specified [boxName].
  Future<void> clear(String boxName) async {
    try {
      await _box(boxName).clear();
    } catch (e) {
      throw StorageException('clear failed for $boxName', cause: e);
    }
  }

  // --- Typed helpers ---

  /// Reads a string value for [key] from [boxName].
  String? getString(String boxName, String key) => get(boxName, key) as String?;

  /// Writes a string [value] for [key] into [boxName].
  Future<void> setString(String boxName, String key, String value) =>
      put(boxName, key, value);

  /// Reads an integer value for [key] from [boxName].
  int? getInt(String boxName, String key) => get(boxName, key) as int?;

  /// Writes an integer [value] for [key] into [boxName].
  Future<void> setInt(String boxName, String key, int value) =>
      put(boxName, key, value);

  /// Reads a boolean value for [key] from [boxName].
  bool? getBool(String boxName, String key) => get(boxName, key) as bool?;

  /// Writes a boolean [value] for [key] into [boxName].
  Future<void> setBool(String boxName, String key, bool value) =>
      put(boxName, key, value);

  /// Reads a double value for [key] from [boxName].
  double? getDouble(String boxName, String key) => get(boxName, key) as double?;

  /// Writes a double [value] for [key] into [boxName].
  Future<void> setDouble(String boxName, String key, double value) =>
      put(boxName, key, value);

  /// Reads a string list for [key] from [boxName].
  List<String>? getStringList(String boxName, String key) =>
      (get(boxName, key) as List?)?.cast<String>();

  /// Writes a string list [value] for [key] into [boxName].
  Future<void> setStringList(
    String boxName,
    String key,
    List<String> value,
  ) =>
      put(boxName, key, value);

  // --- Observation ---

  /// Watch a specific key for changes. Emits on every write.
  Stream<BoxEvent> watch(String boxName, String key) =>
      _box(boxName).watch(key: key);

  /// Watch the entire box for changes.
  Stream<BoxEvent> watchBox(String boxName) => _box(boxName).watch();

  // --- Lifecycle ---

  /// Close all open boxes. Call on app shutdown or in test teardown.
  Future<void> close() async {
    for (final box in _boxes.values) {
      await box.close();
    }
  }
}
