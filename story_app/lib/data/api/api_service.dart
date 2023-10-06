import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:story_app/data/model/list_story_model.dart';
import 'package:story_app/data/model/login_model.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1/';
  static const String _endPointPostRegister = 'register';
  static const String _endPointPostLogin = 'login';
  static const String _endPointGetAllStories = 'stories';
  static const String _endPointGetStoryDetail = 'detail/';
  static const String _endPointPostAddNewStory = 'stories';

  /// login with email and password
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

    if (statusCode == 200) {
      return loginWrap;
    } else {
      throw loginWrap.message;
    }
  }

  /// get all stories, using the token obtained from a successful login
  Future<ListStoryWrap> getAllStories({required String token}) async {
    final getAllStoriesQueryParameters = {
      'page': '1',
      'size': '20',
      'location': '1',
    };

    final response = await http.get(
      Uri.parse('$_baseUrl$_endPointGetAllStories' '?')
          .replace(queryParameters: getAllStoriesQueryParameters),
      // headers: {
      //   'Authorization':
      //       'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJ1c2VyLTVSZDlJdVRyRWZDUWZRWUUiLCJpYXQiOjE2OTYxMjk4MjN9.-Kknom-JpAaHjl6e0pS5nrw3o0vAR7HCAY5SdfrZkdk'
      // },
      headers: {
        'Authorization': 'Bearer $token'
      },
    );

    var statusCode = response.statusCode;
    final listStoryWrap = ListStoryWrap.fromRawJson(response.body);

    print('statusCode = $statusCode');
    if (statusCode == 200) {
      return listStoryWrap;
    } else {
      throw listStoryWrap.message;
    }
  }
}
