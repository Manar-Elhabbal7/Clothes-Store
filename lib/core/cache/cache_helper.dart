import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static late SharedPreferences _sharedPreferences;

  static Future<void> init() async {
    _sharedPreferences = await SharedPreferences.getInstance();
  }

  static const String _keyIsLoggedIn = 'isLoggedIn';
  static const String _keyUserName = 'userName';

  static Future<bool> saveUser({required String name}) async {
    await _sharedPreferences.setString(_keyUserName, name);
    return await _sharedPreferences.setBool(_keyIsLoggedIn, true);
  }

  static bool isLoggedIn() {
    return _sharedPreferences.getBool(_keyIsLoggedIn) ?? false;
  }

  static String? getUserName() {
    return _sharedPreferences.getString(_keyUserName);
  }

  static Future<bool> clearUser() async {
    await _sharedPreferences.remove(_keyUserName);
    return await _sharedPreferences.setBool(_keyIsLoggedIn, false);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    return await _sharedPreferences.setStringList(key, value);
  }

  static List<String>? getStringList(String key) {
    return _sharedPreferences.getStringList(key);
  }
}
