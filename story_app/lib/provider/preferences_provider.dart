import 'package:flutter/material.dart';
import 'package:story_app/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  bool _isLogin = false;
  bool get isLogin => _isLogin;

  String _token = '';
  String get token => _token;

  /// always check and get the current data from SharedPreferences when do instantiation
  PreferencesProvider({required this.preferencesHelper}) {
    print('instance PrefProv');
    _getLoginStatus();
    _getToken();
  }

  /// get login status from SharedPreferences
  void _getLoginStatus() async {
    _isLogin = await preferencesHelper.isLogin;
    notifyListeners();
    print('_getLoginStatus');
  }

  /// set login status to SharedPreferences
  void setLoginStatus(bool value) {
    preferencesHelper.setLoginStatus(value);
    _isLogin = value;
    notifyListeners();
    print('setLoginStatus, _isLogin = $_isLogin');
  }

  /// get token from SharedPreferences
  void _getToken() async {
    _token = await preferencesHelper.getToken;
    notifyListeners();
    print('_getToken');
  }

  /// set token to SharedPreferences
  void setToken(String value) {
    preferencesHelper.setToken(value);
    _token = value;
    notifyListeners();
    print('setToken, _token = $_token');
  }

  /// remove token from SharedPreferences
  void removeToken() {
    preferencesHelper.removeToken();
    _token = '';
    notifyListeners();
    print('removeToken, _token = $_token');
  }
}
