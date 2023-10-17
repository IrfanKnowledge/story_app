import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:story_app/data/model/detail_story_model.dart';
import 'package:story_app/data/model/list_story_model.dart';
import 'package:story_app/data/model/login_model.dart';
import 'package:story_app/data/model/singup_model.dart';
import 'package:story_app/data/model/upload_image_story_model.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1/';
  static const String _endPointPostRegister = 'register';
  static const String _endPointPostLogin = 'login';
  static const String _endPointGetAllStories = 'stories';
  static const String _endPointGetStoryDetail = 'stories/';
  static const String _endPointPostAddNewStoryGuest = 'stories/guest';
  static const String _endPointPostAddNewStory = 'stories';

  /// singup with name, email, password
  Future<SignupWrap> signup({
    required String name,
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse('$_baseUrl$_endPointPostRegister'),
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'email': email,
        'password': password,
      }),
    );

    var statusCode = response.statusCode;
    final signupWrap = SignupWrap.fromRawJson(response.body);

    if (statusCode == 201) {
      return signupWrap;
    } else {
      throw signupWrap.message;
    }
  }

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
      Uri.parse(
        '$_baseUrl$_endPointGetAllStories' '?',
      ).replace(
        queryParameters: getAllStoriesQueryParameters,
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    var statusCode = response.statusCode;
    final listStoryWrap = ListStoryWrap.fromRawJson(response.body);

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
    String token = '',
  }) async {
    // if token is empty then use guest end point,
    // if token is not empty then use token end point
    final endPoint = token.isEmpty
        ? _endPointPostAddNewStoryGuest
        : _endPointPostAddNewStory;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl$endPoint'),
    );

    final multiPartFile = http.MultipartFile.fromBytes(
      'photo',
      photoBytes,
      filename: fileName,
    );

    final Map<String, String> fields = {
      'description': description,
    };

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };

    if (token.isNotEmpty) {
      headers.addAll(
        {'Authorization': 'Bearer $token'},
      );
    }

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

  /// get story detail
  Future<DetailStoryWrap> getDetailStory({
    required String token,
    required String id,
  }) async {

    final response = await http.get(
      Uri.parse(
        '$_baseUrl$_endPointGetStoryDetail/$id',
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final statusCode = response.statusCode;
    final detailStoryWrap = DetailStoryWrap.fromRawJson(response.body);

    if (statusCode == 200) {
      return detailStoryWrap;
    } else {
      throw detailStoryWrap.message;
    }
  }
}
