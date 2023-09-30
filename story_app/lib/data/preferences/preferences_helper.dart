import 'package:shared_preferences/shared_preferences.dart';

class PreferencesHelper {
  final Future<SharedPreferences> sharedPreferences;

  PreferencesHelper({required this.sharedPreferences});

  static const login = 'LOGIN';

  /// get login status from SharedPreferences with Future return type,
  /// it can be fail so use Future type,
  Future<bool> get isLogin async {
    final prefs = await sharedPreferences;
    return prefs.getBool(login) ?? false;
  }

  /// set login status to SharedPreferences
  void setLogin(bool value) async {
    final prefs = await sharedPreferences;
    prefs.setBool(login, value);
  }
}
