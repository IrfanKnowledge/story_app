import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/list_story_model.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/utils/string_helper.dart';

class ListStoryProvider extends ChangeNotifier {
  final ApiService apiService;

  ListStoryProvider({required this.apiService})
      : _state = ResultState.notStarted;

  late ListStoryWrap _listStoryWrap;
  ResultState _state;
  String _message = '';

  ListStoryWrap get listStoryWrap => _listStoryWrap;

  String get message => _message;

  ResultState get state => _state;

  void fetchAllStories({required String token}) async {
    try {
      print('ResultState.loading');

      /// initiate process, _state = ResultState.loading
      _state = ResultState.loading;
      notifyListeners();
      final listStoryWrap = await apiService.getAllStories(token: token);

      /// if listStory is empty, _state = ResultState.noData
      if (listStoryWrap.listStory!.isEmpty) {
        _state = ResultState.noData;
        _message = listStoryWrap.message;
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
      print('ResultState.error: $_message');

      /// if other error show up, _state = ResultState.error
    } catch (e) {
      _state = ResultState.error;
      _message = e.toString();
      notifyListeners();
      print('ResultState.error: $_message');
    }
  }
}
