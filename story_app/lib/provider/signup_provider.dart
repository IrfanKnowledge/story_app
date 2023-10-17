import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:story_app/data/api/api_service.dart';
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

      final signupWrap = await _apiService.signup(
        name: name,
        email: email,
        password: password,
      );

      if (!signupWrap.error) {
        _state = ResultState.hasData;
        _message = signupWrap.message;
        notifyListeners();
      }
    } on SocketException {
      _state = ResultState.error;
      _message = StringHelper.noInternetConnection;
      notifyListeners();
    } catch (e, stacktrace) {
      _state = ResultState.error;
      _message = e.toString();
      notifyListeners();
    }
  }
}
