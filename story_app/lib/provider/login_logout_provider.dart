import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/login_model.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/utils/string_helper.dart';

class LoginLogoutProvider extends ChangeNotifier {
  final ApiService apiService;

  LoginLogoutProvider({required this.apiService})
      : _state = ResultState.notStarted;

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
    print('before try');
    try {
      print('inside try');

      /// initiate process, _state = ResultState.loading
      _state = ResultState.loading;
      notifyListeners();
      final loginWrap = await apiService.postLogin(
        email: email,
        password: password,
      );

      /// if token is empty, _state = ResultState.noData
      if (loginWrap.loginResult!.token.isEmpty) {
        _state = ResultState.noData;
        notifyListeners();
        _message = loginWrap.message;
        print('token is empty, ResultState.noData, $_message');

        /// if token is not empty, _state = ResultState.hasData
      } else {
        _state = ResultState.hasData;
        notifyListeners();
        _loginWrap = loginWrap;
        print('token not empty, ResultState.hasData, $_message');
        print(loginWrap.loginResult!.name);
        print(loginWrap.loginResult!.token);
      }

      /// if no internet connection, _state = ResultState.error
    } on SocketException {
      _state = ResultState.error;
      notifyListeners();
      _message = StringHelper.noInternetConnection;
      print('ResultState.error: $_message');

      /// if other error show up, _state = ResultState.error
    } catch (e) {
      _state = ResultState.error;
      notifyListeners();
      _message = e.toString();
      print('ResultState.error: $_message');
    }
  }
}
