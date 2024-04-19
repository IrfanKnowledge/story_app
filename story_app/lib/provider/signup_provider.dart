import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/signup_model.dart';
import 'package:story_app/utils/loading_state.dart';
import 'package:story_app/utils/string_helper.dart';

class SignupProvider extends ChangeNotifier {
  final ApiService _apiService;

  SignupProvider({required ApiService apiService}) : _apiService = apiService;

  LoadingState<SignupModel> _state = const LoadingState.initial();

  LoadingState<SignupModel> get state => _state;

  void signup({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _state = const LoadingState.loading();
      notifyListeners();

      final signupWrap = await _apiService.signup(
        name: name,
        email: email,
        password: password,
      );

      _state = LoadingState.loaded(signupWrap);
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
