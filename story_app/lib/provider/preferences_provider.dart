import 'package:flutter/material.dart';
import 'package:story_app/data/preferences/preferences_helper.dart';
import 'package:story_app/utils/result_state_helper.dart';

class PreferencesProvider extends ChangeNotifier {
  PreferencesHelper preferencesHelper;

  bool _isLogin = false;
  String _token = '';
  String _messsageIsLogin = '';
  String _messageToken = '';
  ResultState _stateIsLogin = ResultState.notStarted;
  ResultState _stateToken = ResultState.notStarted;

  bool get isLogin => _isLogin;

  String get token => _token;

  String get messageToken => _messageToken;

  String get messsageIsLogin => _messsageIsLogin;

  ResultState get stateIsLogin => _stateIsLogin;

  ResultState get stateToken => _stateToken;

  /// always check and get the current data from SharedPreferences when do instantiation
  PreferencesProvider({required this.preferencesHelper}) {
    fetchToken();
    fetchLoginStatus();
  }

  /// get token from SharedPreferences
  void fetchToken() async {
    /// initiate process, _stateToken = ResultState.loading
    _stateToken = ResultState.loading;
    notifyListeners();
    _token = await preferencesHelper.getToken;

    /// if token is empty, _stateToken = ResultState.noData
    if (_token.isEmpty) {
      _stateToken = ResultState.noData;
      _messageToken =
          'Sesi anda sudah habis atau tidak valid, silahkan untu login ulang terlebih dahulu';
      notifyListeners();

      /// if token is not empty, _stateToken = ResultState.hasData
    } else {
      _stateToken = ResultState.hasData;
      notifyListeners();
    }
  }

  /// set token to SharedPreferences
  void setAndFetchToken(String value) {
    preferencesHelper.setToken(value);
    _token = value;
    fetchToken();
  }

  /// remove token from SharedPreferences
  void removeAndFetchToken() {
    preferencesHelper.removeToken();
    _token = '';
    fetchToken();
  }

  /// get login status from SharedPreferences
  void fetchLoginStatus() async {
    /// initiate process, _state = ResultState.loading
    _stateIsLogin = ResultState.loading;
    notifyListeners();
    _isLogin = await preferencesHelper.isLogin;

    /// await the data using if () else,
    /// that is why the result is always ResultState.hasData
    if (_isLogin) {
      _stateIsLogin = ResultState.hasData;
      notifyListeners();
    } else {
      _stateIsLogin = ResultState.hasData;
      _messsageIsLogin = 'Anda belum login, harap login terlebih dahulu';
      notifyListeners();
    }
  }

  /// set login status to SharedPreferences
  void setAndFetchLoginStatus(bool value) {
    preferencesHelper.setLoginStatus(value);
    _isLogin = value;
    fetchLoginStatus();
  }
}
