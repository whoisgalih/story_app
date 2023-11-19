import 'package:shared_preferences/shared_preferences.dart';

/// todo 3: create Auth Repository and
/// add some method for auth process
class AuthRepository {
  final String tokenKey = "token";

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(tokenKey)?.isNotEmpty ?? false;
  }

  Future<bool> setToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    return await preferences.setString(tokenKey, token);
  }

  Future<bool> removeToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.clear();
  }

  Future<String> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    return preferences.getString(tokenKey) ?? "";
  }
}
