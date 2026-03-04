import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../error/exceptions.dart';

class LocalStorageService {
  final SharedPreferences _prefs;

  LocalStorageService(this._prefs);

  // String
  Future<bool> setString(String key, String value) async {
    try {
      return await _prefs.setString(key, value);
    } catch (_) {
      throw const CacheException(message: 'Failed to save string');
    }
  }

  String? getString(String key) {
    try {
      return _prefs.getString(key);
    } catch (_) {
      throw const CacheException(message: 'Failed to read string');
    }
  }

  // Bool
  Future<bool> setBool(String key, bool value) async {
    try {
      return await _prefs.setBool(key, value);
    } catch (_) {
      throw const CacheException(message: 'Failed to save bool');
    }
  }

  bool? getBool(String key) {
    try {
      return _prefs.getBool(key);
    } catch (_) {
      throw const CacheException(message: 'Failed to read bool');
    }
  }

  // Int
  Future<bool> setInt(String key, int value) async {
    try {
      return await _prefs.setInt(key, value);
    } catch (_) {
      throw const CacheException(message: 'Failed to save int');
    }
  }

  int? getInt(String key) {
    try {
      return _prefs.getInt(key);
    } catch (_) {
      throw const CacheException(message: 'Failed to read int');
    }
  }

  // Double
  Future<bool> setDouble(String key, double value) async {
    try {
      return await _prefs.setDouble(key, value);
    } catch (_) {
      throw const CacheException(message: 'Failed to save double');
    }
  }

  double? getDouble(String key) {
    try {
      return _prefs.getDouble(key);
    } catch (_) {
      throw const CacheException(message: 'Failed to read double');
    }
  }

  // JSON Object
  Future<bool> setJson(String key, Map<String, dynamic> value) async {
    try {
      return await _prefs.setString(key, jsonEncode(value));
    } catch (_) {
      throw const CacheException(message: 'Failed to save JSON');
    }
  }

  Map<String, dynamic>? getJson(String key) {
    try {
      final raw = _prefs.getString(key);
      if (raw == null) return null;
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      throw const CacheException(message: 'Failed to read JSON');
    }
  }

  // Remove
  Future<bool> remove(String key) async {
    try {
      return await _prefs.remove(key);
    } catch (_) {
      throw const CacheException(message: 'Failed to remove key');
    }
  }

  // Clear all
  Future<bool> clear() async {
    try {
      return await _prefs.clear();
    } catch (_) {
      throw const CacheException(message: 'Failed to clear storage');
    }
  }

  bool containsKey(String key) => _prefs.containsKey(key);
}
