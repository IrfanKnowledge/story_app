import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_app/data/model/login_model.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1/';
  static const String _endPointPostRegister = 'register';
  static const String _endPointPostLogin = 'login';
  static const String _endPointGetStoryList = 'stories';
  static const String _endPointGetStoryDetail = 'detail/';
  static const String _endPointPostAddNewStory = 'stories';

  Future<LoginWrap> postLogin({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_endPointPostLogin'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    var statusCode = response.statusCode;
    final loginWrap = LoginWrap.fromRawJson(response.body);

    if (statusCode == 200 || statusCode == 401) {
      return loginWrap;
    } else {
      throw Exception(loginWrap.message);
    }
  }
}
