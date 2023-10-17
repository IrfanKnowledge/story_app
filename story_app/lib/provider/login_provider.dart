import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/login_model.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/utils/string_helper.dart';

class LoginProvider extends ChangeNotifier {
  final ApiService apiService;

  LoginProvider({required this.apiService}) : _state = ResultState.notStarted;

  late LoginWrap _loginWrap;
  ResultState _state;
  String _message = '';

  LoginWrap get loginWrap => _loginWrap;

  ResultState get state => _state;

  String get message => _message;

  void postLogin({
    required String email,
    required String password,
  }) async {
    try {

      /// initiate process, _state = ResultState.loading
      _state = ResultState.loading;
      notifyListeners();
      final loginWrap = await apiService.login(
        email: email,
        password: password,
      );

      /// if token is empty, _state = ResultState.noData
      if (loginWrap.loginResult!.token.isEmpty) {
        _state = ResultState.noData;
        _message = loginWrap.message;
        notifyListeners();

        /// if token is not empty, _state = ResultState.hasData
      } else {
        _state = ResultState.hasData;
        _loginWrap = loginWrap;
        notifyListeners();
      }

      /// if no internet connection, _state = ResultState.error
    } on SocketException {
      _state = ResultState.error;
      _message = StringHelper.noInternetConnection;
      notifyListeners();

      /// if other error show up, _state = ResultState.error
    } catch (e, stacktrace) {
      _state = ResultState.error;
      _message = e.toString();
      notifyListeners();
    }
  }
}
