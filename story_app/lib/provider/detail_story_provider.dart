import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/detail_story_model.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/utils/string_helper.dart';

class DetailStoryProvider extends ChangeNotifier {
  final ApiService apiService;

  DetailStoryProvider({required this.apiService})
      : _state = ResultState.notStarted;

  late DetailStoryWrap _detailStoryWrap;
  String _message = '';
  ResultState _state;

  DetailStoryWrap get detailStoryWrap => _detailStoryWrap;

  ResultState get state => _state;

  String get message => _message;

  void fetchStoryDetail({
    required String token,
    required String id,
  }) async {
    try {
      // initiate process, _state = ResultState.loading
      _state = ResultState.loading;
      notifyListeners();

      print('ResultState.loading, fetchStoryDetail, FetchStoryDetailProvider');

      final detailStoryWrap = await apiService.getDetailStory(
        token: token,
        id: id,
      );

      if (detailStoryWrap.story!.id.isNotEmpty) {
        _state = ResultState.hasData;
        _detailStoryWrap = detailStoryWrap;
        notifyListeners();

        print(
            'ResultState.hasData, fetchStoryDetail, FetchStoryDetailProvider');
      }

      // if no internet connection, _state = ResultState.error
    } on SocketException {
      _state = ResultState.error;
      _message = StringHelper.noInternetConnection;
      notifyListeners();

      print('ResultState.error: $_message');

      // if other error show up, _state = ResultState.error
    } catch (e, stacktrace) {
      _state = ResultState.error;
      _message = e.toString();
      notifyListeners();

      print('ResultState.error: $_message');
      print(stacktrace);
    }
  }
}
