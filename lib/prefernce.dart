import 'package:shared_preferences/shared_preferences.dart';

class PreferenceHandler {
  static const String _isLogin = 'isLogin';
  static const String _token = 'token';
  static const String _name = 'name';
  static const String _email = 'email';

  /// ======================
  /// SAVE DATA
  /// ======================

  Future<void> saveLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLogin, value);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_token, token);
  }

  Future<void> saveUser({required String name, required String email}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_name, name);
    await prefs.setString(_email, email);
  }

  /// ======================
  /// GET DATA
  /// ======================

  Future<bool> getIsLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLogin) ?? false;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_token);
  }

  Future<String?> getName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_name);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_email);
  }

  /// ======================
  /// DELETE / CLEAR
  /// ======================

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLogin);
    await prefs.remove(_token);
    await prefs.remove(_name);
    await prefs.remove(_email);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
