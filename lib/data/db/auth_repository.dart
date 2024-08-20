import 'package:shared_preferences/shared_preferences.dart';

/// todo 3: create Auth Repository and
/// add some method for auth process
class AuthRepository {
  static const String tokenKey = "token";

  static Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(tokenKey)?.isNotEmpty ?? false;
  }

  static Future<bool> setToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setString(tokenKey, token);
  }

  static Future<bool> removeToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.clear();
  }

  static Future<String> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(tokenKey) ?? "";
  }
}
