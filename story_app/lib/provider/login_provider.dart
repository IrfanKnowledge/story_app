import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/login_model.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/utils/string_helper.dart';

class LoginProvider extends ChangeNotifier {

  final ApiService _apiService;

  /// constructor ini tidak akan menjalankan proses perubahan state
  /// perubahan state dimulai ketika memanggil method [LoginProvider.postLogin]
  LoginProvider({required ApiService apiService})
      : _apiService = apiService;

  late LoginWrap _loginWrap;
  ResultState _state = ResultState.notStarted;
  String _message = '';

  LoginWrap get loginWrap => _loginWrap;

  ResultState get state => _state;

  String get message => _message;


  void postLogin({
    required String email,
    required String password,
  }) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final loginWrap = await _apiService.login(
        email: email,
        password: password,
      );

      if (loginWrap.loginResult!.token.isEmpty) {
        _state = ResultState.noData;
        _message = loginWrap.message;
        notifyListeners();

      } else {
        _state = ResultState.hasData;
        _loginWrap = loginWrap;
        notifyListeners();
      }

    } on SocketException {
      _state = ResultState.error;
      _message = StringHelper.noInternetConnection;
      notifyListeners();

    } catch (e) {
      _state = ResultState.error;
      _message = e.toString();
      notifyListeners();
    }
  }

  void setStateToNotStartedWithoutNotify() {
    _state = ResultState.notStarted;
  }
}
