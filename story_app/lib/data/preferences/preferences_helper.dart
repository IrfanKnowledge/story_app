import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const login = 'LOGIN';
  static const token = 'TOKEN';

  /// get login status from SharedPreferences with Future return type,
  /// it can be fail so use Future type,
  Future<bool> get isLogin async {
    final prefs = await sharedPreferences;
    return prefs.getBool(login) ?? false;
  }

  /// set login status to SharedPreferences
  void setLoginStatus(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(login, value);
  }

  /// get token from SharedPreferences with Future return type
  /// it can be fail so use Future type,
  Future<String> get getToken async {
    final prefs = await sharedPreferences;
    return prefs.getString(token) ?? '';
  }

  /// set token to SharedPreferences
  void setToken(String value) async {
    final prefs = await sharedPreferences;
    prefs.setString(token, value);
  }

  /// remove token from SharedPreferences
  void removeToken() async {
    final prefs = await sharedPreferences;
    prefs.remove(token);
  }
}
