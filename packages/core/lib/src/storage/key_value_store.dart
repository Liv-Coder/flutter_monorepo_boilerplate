import 'package:shared_preferences/shared_preferences.dart';

/// Thin wrapper around [SharedPreferences] with typed accessors.
class KeyValueStore {
  KeyValueStore(this._prefs);

  static Future<KeyValueStore> create() async {
    final prefs = await SharedPreferences.getInstance();
    return KeyValueStore(prefs);
  }

  final SharedPreferences _prefs;

  String? getString(String key) => _prefs.getString(key);
  Future<void> setString(String key, String value) =>
      _prefs.setString(key, value);

  int? getInt(String key) => _prefs.getInt(key);
  Future<void> setInt(String key, int value) => _prefs.setInt(key, value);

  bool? getBool(String key) => _prefs.getBool(key);
  Future<void> setBool(String key, bool value) => _prefs.setBool(key, value);

  Future<void> remove(String key) => _prefs.remove(key);
  Future<void> clear() => _prefs.clear();
}
