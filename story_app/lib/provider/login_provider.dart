import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/login_model.dart';
import 'package:story_app/utils/loading_state.dart';
import 'package:story_app/utils/string_helper.dart';

class LoginProvider extends ChangeNotifier {
  final ApiService _apiService;

  LoginProvider({required ApiService apiService}) : _apiService = apiService;

  LoadingState<LoginModel> _state = const LoadingState.initial();

  LoadingState<LoginModel> get state => _state;

  void login({
    required String email,
    required String password,
  }) async {
    try {
      _state = const LoadingState.loading();
      notifyListeners();

      final loginWrap = await _apiService.login(
        email: email,
        password: password,
      );

      _state = LoadingState.loaded(loginWrap);
      notifyListeners();
    } on SocketException {
      _state = const LoadingState.error(StringHelper.noInternetConnection);
      notifyListeners();
    } catch (e) {
      _state = LoadingState.error(e.toString());
      notifyListeners();
    }
  }
}
