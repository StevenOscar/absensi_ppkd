import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefHelper {
  static final String _tokenKey = "token";

  static Future<void> setToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_tokenKey, token);
  }

  static Future<String> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey) ?? "";
  }

  static Future<void> deleteToken() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_tokenKey);
  }
}
