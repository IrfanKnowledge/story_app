import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> _sharedPreferences;

  PreferencesHelper({required Future<SharedPreferences> sharedPreferences})
      : _sharedPreferences = sharedPreferences;

  static const _token = 'TOKEN';
  static const _login = 'LOGIN';

  static const _theme = 'THEME';
  static const _langCode = 'LANG_CODE';

  /// is language use system configuration or not?
  static const _langStatus = 'LANG_STATUS';

  Future<String> get token async {
    final prefs = await _sharedPreferences;
    return prefs.getString(_token) ?? '';
  }

  void setToken(String value) async {
    final prefs = await _sharedPreferences;
    prefs.setString(_token, value);
  }

  void removeToken() async {
    final prefs = await _sharedPreferences;
    prefs.remove(_token);
  }

  Future<bool> get login async {
    final prefs = await _sharedPreferences;
    return prefs.getBool(_login) ?? false;
  }

  void setLoginStatus(bool value) async {
    final prefs = await _sharedPreferences;
    prefs.setBool(_login, value);
  }

  void removeLoginStatus() async {
    final prefs = await _sharedPreferences;
    prefs.remove(_login);
  }

  Future<String> get theme async {
    final prefs = await _sharedPreferences;
    return prefs.getString(_theme) ?? '';
  }

  void setTheme(String value) async {
    final prefs = await _sharedPreferences;
    prefs.setString(_theme, value);
  }

  void removeTheme() async {
    final prefs = await _sharedPreferences;
    prefs.remove(_theme);
  }
}
