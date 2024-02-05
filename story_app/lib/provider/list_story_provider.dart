import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/list_story_model.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/utils/string_helper.dart';

class ListStoryProvider extends ChangeNotifier {
  final ApiService _apiService;

  ListStoryProvider({
    required ApiService apiService,
  }) : _apiService = apiService;

  late ListStoryWrap _listStoryWrap;
  ResultState _state = ResultState.notStarted;
  String _message = '';

  ListStoryWrap get listStoryWrap => _listStoryWrap;

  String get message => _message;

  ResultState get state => _state;

  void fetchAllStories({required String token}) async {
    try {
      _state = ResultState.loading;
      notifyListeners();
      final listStoryWrap = await _apiService.getAllStories(token: token);

      if (listStoryWrap.listStory!.isEmpty) {
        _state = ResultState.noData;
        _message = StringHelper.emptyData;
        notifyListeners();

      } else {
        _state = ResultState.hasData;
        _listStoryWrap = listStoryWrap;
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
