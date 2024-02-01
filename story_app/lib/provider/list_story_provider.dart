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
    required String token,
  }) : _apiService = apiService {
    fetchAllStories(token: token);
  }

  late ListStoryWrap _listStoryWrap;
  ResultState _state = ResultState.notStarted;
  String _message = '';

  ListStoryWrap get listStoryWrap => _listStoryWrap;

  String get message => _message;

  ResultState get state => _state;

  void fetchAllStories({required String token}) async {
    try {
      /// initiate process, _state = ResultState.loading
      _state = ResultState.loading;
      notifyListeners();
      final listStoryWrap = await _apiService.getAllStories(token: token);

      /// if listStory is empty, _state = ResultState.noData
      if (listStoryWrap.listStory!.isEmpty) {
        _state = ResultState.noData;
        _message = StringHelper.emptyData;
        notifyListeners();

        /// if listStory is notEmpty, _state = ResultState.hasData
      } else {
        _state = ResultState.hasData;
        _listStoryWrap = listStoryWrap;
        notifyListeners();
      }

      /// if no internet connection, _state = ResultState.error
    } on SocketException {
      _state = ResultState.error;
      _message = StringHelper.noInternetConnection;
      notifyListeners();

      /// if other error show up, _state = ResultState.error
    } catch (e, stacktrace) {
      _state = ResultState.error;
      _message = e.toString();
      notifyListeners();
    }
  }
}
