import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> _sharedPreferences;

  PreferencesHelper({required Future<SharedPreferences> sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  static const token = 'TOKEN';
  static const login = 'LOGIN';

  Future<String> get getToken async {
    final prefs = await _sharedPreferences;
    return prefs.getString(token) ?? '';
  }

  void setToken(String value) async {
    final prefs = await _sharedPreferences;
    prefs.setString(token, value);
  }

  void removeToken() async {
    final prefs = await _sharedPreferences;
    prefs.remove(token);
  }

  Future<bool> get isLogin async {
    final prefs = await _sharedPreferences;
    return prefs.getBool(login) ?? false;
  }

  void setLoginStatus(bool value) async {
    final prefs = await _sharedPreferences;
    prefs.setBool(login, value);
  }

  void removeLoginStatus() async {
    final prefs = await _sharedPreferences;
    prefs.remove(login);
  }
}
