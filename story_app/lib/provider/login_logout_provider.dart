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

  Future<void> postLogin({
    required String email,
    required String password,
  }) async {
    print('before try');
    try {
      print('after try');
      _state = ResultState.loading;
      notifyListeners();
      final loginWrap = await apiService.postLogin(
        email: email,
        password: password,
      );

      /// if result is empty then...
      if (loginWrap.loginResult.token.isEmpty) {
        print('token is empty, ResultState.noData');
        _state = ResultState.noData;
        notifyListeners();
        _message = StringHelper.emptyData;

        /// if not empty then...
      } else {
        print('token not empty, ResultState.hasData');
        print(loginWrap.loginResult.name);
        print(loginWrap.loginResult.token);
        _state = ResultState.hasData;
        notifyListeners();
        _loginWrap = loginWrap;
      }

      /// if no internet connection then...
    } on SocketException {
      print('ResultState.error: $_message');
      _state = ResultState.error;
      notifyListeners();
      _message = StringHelper.noInternetConnection;

      /// if other error show up then...
    } catch (e) {
      print('ResultState.error: $e');
      _state = ResultState.error;
      notifyListeners();
      _message = StringHelper.failedToLoadData;
    }
  }
}
