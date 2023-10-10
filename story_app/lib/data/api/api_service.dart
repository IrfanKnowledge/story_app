import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:story_app/data/model/list_story_model.dart';
import 'package:story_app/data/model/login_model.dart';
import 'package:story_app/data/model/upload_image_story_model.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1/';
  static const String _endPointPostRegister = 'register';
  static const String _endPointPostLogin = 'login';
  static const String _endPointGetAllStories = 'stories';
  static const String _endPointGetStoryDetail = 'detail/';
  static const String _endPointPostAddNewStory = 'stories/guest';

  /// login with email and password
  Future<LoginWrap> login({
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
      'location': '0',
    };

    final response = await http.get(
      Uri.parse('$_baseUrl$_endPointGetAllStories' '?')
          .replace(queryParameters: getAllStoriesQueryParameters),
      // headers: {
      //   'Authorization':
      //       'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VySWQiOiJ1c2VyLTVSZDlJdVRyRWZDUWZRWUUiLCJpYXQiOjE2OTYxMjk4MjN9.-Kknom-JpAaHjl6e0pS5nrw3o0vAR7HCAY5SdfrZkdk'
      // },
      headers: {
        'Authorization': 'Bearer $token',
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

  /// upload story
  Future<UploadImageStoryResponse> uploadStory({
    required List<int> photoBytes,
    required String fileName,
    required String description,
  }) async {
    final request = http.MultipartRequest(
        'POST', Uri.parse('$_baseUrl$_endPointPostAddNewStory'));

    final multiPartFile = http.MultipartFile.fromBytes(
      'photo',
      photoBytes,
      filename: fileName,
    );

    final Map<String, String> fields = {
      'description': description,
    };

    final Map<String, String> headers = {'Content-Type': 'multipart/form-data'};

    request.files.add(multiPartFile);
    request.fields.addAll(fields);
    request.headers.addAll(headers);

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    final UploadImageStoryResponse uploadImageStoryResponse =
        UploadImageStoryResponse.fromRawJson(responseData);

    if (statusCode == 201) {
      return uploadImageStoryResponse;
    } else {
      throw uploadImageStoryResponse.message;
    }
  }
}
