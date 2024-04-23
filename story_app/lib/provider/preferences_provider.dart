import 'package:flutter/material.dart';
import 'package:story_app/data/preferences/preferences_helper.dart';
import 'package:story_app/utils/loading_state.dart';

class PreferencesProvider extends ChangeNotifier {
  final PreferencesHelper _preferencesHelper;

  LoadingState<String> _stateToken = const LoadingState.initial();

  LoadingState<bool> _stateIsLogin = const LoadingState.initial();

  LoadingState<ThemeMode?> _stateThemeMode = const LoadingState.initial();

  LoadingState<String?> _stateLangCode = const LoadingState.initial();

  LoadingState<String> get stateToken => _stateToken;

  LoadingState<bool> get stateIsLogin => _stateIsLogin;

  LoadingState<ThemeMode?> get stateThemeMode => _stateThemeMode;

  LoadingState<String?> get stateLangCode => _stateLangCode;

  PreferencesProvider({required PreferencesHelper preferencesHelper})
      : _preferencesHelper = preferencesHelper {
    print('test');
    fetchToken();
    fetchLoginStatus();
    fetchTheme();
    fetchLangCode();
  }

  void fetchToken() async {
    _stateToken = const LoadingState.loading();
    notifyListeners();

    final token = await _preferencesHelper.token;

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

    final isLogin = await _preferencesHelper.login;

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

  void fetchTheme() async {
    _stateThemeMode = const LoadingState.loading();
    notifyListeners();

    final theme = await _preferencesHelper.theme;

    ThemeMode? themeMode;
    if (theme == ThemeMode.system.name) {
      themeMode = ThemeMode.system;
    } else if (theme == ThemeMode.light.name) {
      themeMode = ThemeMode.light;
    } else if (theme == ThemeMode.dark.name) {
      themeMode = ThemeMode.dark;
    }

    _stateThemeMode = LoadingState.loaded(themeMode);
    notifyListeners();
  }

  void setAndFetchTheme(ThemeMode value) {
    _preferencesHelper.setTheme(value.name);
    fetchTheme();
  }

  void fetchLangCode() async {
    _stateLangCode = const LoadingState.loading();
    notifyListeners();

    final langCode = await _preferencesHelper.langCode;

    if (langCode.isEmpty) {
      _stateLangCode = const LoadingState.loaded(null);
    } else {
      _stateLangCode = LoadingState.loaded(langCode);
    }
    notifyListeners();
  }

  void setAndFetchLangCode(String value) {
    _preferencesHelper.setLangCode(value);
    fetchLangCode();
  }
}
