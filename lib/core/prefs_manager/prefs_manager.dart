import 'package:shared_preferences/shared_preferences.dart';

/// Manages app preferences using SharedPreferences
class PrefsManager {
  static PrefsManager? _instance;
  static SharedPreferences? _prefs;

  PrefsManager._();

  static Future<PrefsManager> getInstance() async {
    _instance ??= PrefsManager._();
    _prefs ??= await SharedPreferences.getInstance();
    return _instance!;
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs!.setString(key, value);
  }

  String? getString(String key) {
    return _prefs!.getString(key);
  }

  Future<bool> setBool(String key, bool value) async {
    return await _prefs!.setBool(key, value);
  }

  bool? getBool(String key) {
    return _prefs!.getBool(key);
  }

  bool getBoolOrDefault(String key, bool defaultValue) {
    return _prefs!.getBool(key) ?? defaultValue;
  }

  Future<bool> setInt(String key, int value) async {
    return await _prefs!.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs!.getInt(key);
  }

  int getIntOrDefault(String key, int defaultValue) {
    return _prefs!.getInt(key) ?? defaultValue;
  }

  Future<bool> setDouble(String key, double value) async {
    return await _prefs!.setDouble(key, value);
  }

  double? getDouble(String key) {
    return _prefs!.getDouble(key);
  }

  Future<bool> remove(String key) async {
    return await _prefs!.remove(key);
  }

  Future<bool> clear() async {
    return await _prefs!.clear();
  }

  bool containsKey(String key) {
    return _prefs!.containsKey(key);
  }
}
