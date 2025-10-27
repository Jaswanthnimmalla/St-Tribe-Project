import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  static const Duration cacheDuration = Duration(hours: 1);

  Future<void> cacheData(String key, List<dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> jsonList = data.map((item) {
        final jsonMap = item.toJson();
        return json.encode(jsonMap);
      }).toList();

      await prefs.setStringList(key, jsonList);
      await prefs.setInt(
          '${key}_timestamp', DateTime.now().millisecondsSinceEpoch);
    } catch (e) {
      print('Error caching data: $e');
    }
  }

  Future<List<Map<String, dynamic>>?> getCachedData(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String>? jsonList = prefs.getStringList(key);
      final int? timestamp = prefs.getInt('${key}_timestamp');

      if (jsonList == null || timestamp == null) {
        return null;
      }

      // Check cache validity
      final DateTime cacheTime = DateTime.fromMillisecondsSinceEpoch(timestamp);
      if (DateTime.now().difference(cacheTime) > cacheDuration) {
        await prefs.remove(key);
        await prefs.remove('${key}_timestamp');
        return null;
      }

      return jsonList
          .map((jsonString) {
            try {
              return json.decode(jsonString) as Map<String, dynamic>;
            } catch (e) {
              print('Error parsing cached data: $e');
              return <String, dynamic>{};
            }
          })
          .where((map) => map.isNotEmpty)
          .toList();
    } catch (e) {
      print('Error getting cached data: $e');
      return null;
    }
  }

  Future<void> clearCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(key);
      await prefs.remove('${key}_timestamp');
    } catch (e) {
      print('Error clearing cache: $e');
    }
  }

  Future<void> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();
    } catch (e) {
      print('Error clearing all cache: $e');
    }
  }
}
