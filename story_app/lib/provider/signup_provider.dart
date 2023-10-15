import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/singup_model.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/utils/string_helper.dart';

class SignupProvider extends ChangeNotifier {
  final ApiService _apiService;

  SignupProvider(this._apiService) : _state = ResultState.notStarted;

  ResultState _state;
  String _message = '';

  ResultState get state => _state;

  String get message => _message;

  void signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      print('ResultState.loading, signup, signup_provider');

      final signupWrap = await _apiService.signup(
        name: name,
        email: email,
        password: password,
      );

      if (!signupWrap.error) {
        _state = ResultState.hasData;
        _message = signupWrap.message;
        notifyListeners();
        print('ResultState.hasdata, signup, signup_provider');
        print('message: $_message, signup, signup_provider');
      }
    } on SocketException {
      _state = ResultState.error;
      _message = StringHelper.noInternetConnection;
      notifyListeners();
      print('ResultState.error, signup, signup_provider');
      print('ResultState.error: $_message');
    } catch (e, stacktrace) {
      _state = ResultState.error;
      _message = e.toString();
      notifyListeners();
      print('ResultState.error, signup, signup_provider');
      print('ResultState.error: $_message');
      print(stacktrace);
    }
  }
}
