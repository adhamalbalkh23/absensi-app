import 'package:shared_preferences/shared_preferences.dart';
import 'package:absensi_apps/models/history_model.dart';

class PreferenceHandler {
  static const String _isLogin = 'isLogin';
  static const String _token = 'token';
  static const String _historyList = 'historyList';
  static const String _name = 'name';
  static const String _email = 'email';

  Future<void> saveUserName(String name) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_name, name);
  }

  Future<void> saveEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_email, email);
  }

  Future<String?> getUserName() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_name);
  }

  Future<String?> getEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_email);
  }

  // ======================
  // CREATE
  // ======================
  Future<void> storingIsLogin(bool isLogin) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_isLogin, isLogin);
  }

  Future<void> storingToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_token, token);
  }

  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_token, token);
  }

  // ======================
  // HISTORY
  // ======================
  Future<void> saveHistory(List<HistoryModel> historyList) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = historyList.map((item) => item.toJsonString()).toList();
    await prefs.setStringList(_historyList, jsonList);
  }

  Future<List<HistoryModel>> loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = prefs.getStringList(_historyList) ?? [];
    return jsonList.map((item) => HistoryModel.fromJsonString(item)).toList();
  }

  Future<void> addHistory(HistoryModel history) async {
    final historyList = await loadHistory();
    historyList.add(history);
    await saveHistory(historyList);
  }

  Future<void> clearHistory() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_historyList);
  }

  // ======================
  // GET
  // ======================
  Future<bool> getIsLogin() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLogin) ?? false;
  }

  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_token);
  }

  // ======================
  // DELETE
  // ======================
  Future<void> deleteIsLogin() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_isLogin);
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
