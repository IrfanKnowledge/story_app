import 'package:flutter/material.dart';
import 'package:story_app/data/preferences/preferences_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  bool _isLogin = false;
  bool get isLogin => _isLogin;

  /// always check and get the current data from SharedPreferences when do instantiation
  PreferencesProvider({required this.preferencesHelper}) {
    _getLoginPreferences();
  }

  /// get login status from SharedPreferences
  void _getLoginPreferences() async {
    _isLogin = await preferencesHelper.isLogin;
    notifyListeners();
  }

  /// set login status to SharedPreferences
  void setLogin(bool value) {
    preferencesHelper.setLogin(value);
    _getLoginPreferences();
  }
}
