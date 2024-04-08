import 'package:flutter/material.dart';
import 'package:story_app/data/preferences/preferences_helper.dart';
import 'package:story_app/utils/loading_state.dart';

class PreferencesProvider extends ChangeNotifier {
  final PreferencesHelper _preferencesHelper;

  LoadingState<String> _stateToken = const LoadingState.initial();

  LoadingState<bool> _stateIsLogin = const LoadingState.initial();

  LoadingState<String> get stateToken => _stateToken;

  LoadingState<bool> get stateIsLogin => _stateIsLogin;

  PreferencesProvider({required PreferencesHelper preferencesHelper})
      : _preferencesHelper = preferencesHelper {
    fetchToken();
    fetchLoginStatus();
  }

  void fetchToken() async {
    _stateToken = const LoadingState.loading();
    notifyListeners();

    final token = await _preferencesHelper.getToken;

    _stateToken = LoadingState.loaded(token);
    notifyListeners();
  }

  void setAndFetchToken(String value) {
    _preferencesHelper.setToken(value);
    _stateToken = LoadingState.loaded(value);
    fetchToken();
  }

  void removeAndFetchToken() {
    _preferencesHelper.removeToken();
    _stateToken = const LoadingState.loaded('');
    fetchToken();
  }

  void fetchLoginStatus() async {
    _stateIsLogin = const LoadingState.loading();
    notifyListeners();

    final isLogin = await _preferencesHelper.isLogin;

    _stateIsLogin = LoadingState.loaded(isLogin);
    notifyListeners();
  }

  void setAndFetchLoginStatus(bool value) {
    _preferencesHelper.setLoginStatus(value);
    _stateIsLogin = LoadingState.loaded(value);
    fetchLoginStatus();
  }

  void removeAndFetchLoginStatus() {
    _preferencesHelper.removeLoginStatus();
    _stateIsLogin = const LoadingState.loaded(false);
    fetchLoginStatus();
  }
}
