import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;
import 'package:story_app/data/model/detail_story_model.dart';
import 'package:story_app/data/model/list_story_model.dart';
import 'package:story_app/data/model/login_model.dart';
import 'package:story_app/data/model/signup_model.dart';
import 'package:story_app/data/model/upload_image_story_model.dart';

class ApiService {
  static const String _baseUrl = 'https://story-api.dicoding.dev/v1/';
  static const String _endPointPostRegister = 'register';
  static const String _endPointPostLogin = 'login';
  static const String _endPointGetAllStories = 'stories';
  static const String _endPointGetStoryDetail = 'stories/{id}';
  static const String _endPointPostAddNewStoryAsGuest = 'stories/guest';
  static const String _endPointPostAddNewStory = 'stories';

  Future<SignupModel> signup({
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
    final signupModel = SignupModel.fromRawJson(response.body);

    if (statusCode == 201) {
      return signupModel;
    } else {
      throw signupModel;
    }
  }

  Future<LoginModel> login({
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
    final loginModel = LoginModel.fromRawJson(response.body);

    if (statusCode == 200) {
      return loginModel;
    } else {
      throw loginModel;
    }
  }

  Future<ListStoryModel> getAllStories({
    required String token,
    int pageItems = 1,
    int sizeItems = 10,
    int location = 0,
  }) async {
    final getAllStoriesQueryParameters = {
      'page': pageItems.toString(),
      'size': sizeItems.toString(),
      'location': location.toString(),
    };

    final response = await http.get(
      Uri.parse(
        '$_baseUrl$_endPointGetAllStories?',
      ).replace(
        queryParameters: getAllStoriesQueryParameters,
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    var statusCode = response.statusCode;
    final listStoryModel = ListStoryModel.fromRawJson(response.body);

    if (statusCode == 200) {
      return listStoryModel;
    } else {
      throw listStoryModel;
    }
  }

  Future<UploadImageStoryModel> uploadStory({
    required List<int> photoBytes,
    required String fileName,
    required String description,
    double? lat,
    double? lon,
    String token = '',
  }) async {
    final endPoint = token.isEmpty
        ? _endPointPostAddNewStoryAsGuest
        : _endPointPostAddNewStory;

    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$_baseUrl$endPoint'),
    );

    Map<String, String> headers = {
      'Content-Type': 'multipart/form-data',
    };

    if (token.isNotEmpty) {
      headers.addAll(
        {'Authorization': 'Bearer $token'},
      );
    }

    final Map<String, String> fields = {
      'description': description,
    };

    if (lat != null && lon != null) {
      fields.addAll({
        'lat': lat.toString(),
        'lon': lon.toString(),
      });
    }

    // fileName is a must, if not it will fail
    final multiPartFile = http.MultipartFile.fromBytes(
      'photo',
      photoBytes,
      filename: fileName,
    );

    request.headers.addAll(headers);
    request.fields.addAll(fields);
    request.files.add(multiPartFile);

    final http.StreamedResponse streamedResponse = await request.send();
    final int statusCode = streamedResponse.statusCode;

    final Uint8List responseList = await streamedResponse.stream.toBytes();
    final String responseData = String.fromCharCodes(responseList);

    final UploadImageStoryModel uploadImageStoryModel =
        UploadImageStoryModel.fromRawJson(responseData);

    if (statusCode == 201) {
      return uploadImageStoryModel;
    } else {
      throw uploadImageStoryModel;
    }
  }

  Future<DetailStoryModel> getDetailStory({
    required String token,
    required String id,
  }) async {
    final response = await http.get(
      Uri.parse(
        '$_baseUrl${_endPointGetStoryDetail.replaceAll('{id}', id)}',
      ),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    final statusCode = response.statusCode;
    final detailStoryModel = DetailStoryModel.fromRawJson(response.body);

    if (statusCode == 200) {
      return detailStoryModel;
    } else {
      throw detailStoryModel;
    }
  }
}
