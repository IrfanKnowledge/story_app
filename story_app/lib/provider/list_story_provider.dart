import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/list_story_model.dart';
import 'package:story_app/utils/loading_state.dart';
import 'package:story_app/utils/string_helper.dart';

class ListStoryProvider extends ChangeNotifier {
  final ApiService _apiService;

  ListStoryProvider({
    required ApiService apiService,
  }) : _apiService = apiService;

  LoadingState<ListStoryModel> _stateListStory = const LoadingState.initial();

  LoadingState<ListStoryModel> get stateListStory => _stateListStory;

  void fetchAllStories({required String token}) async {
    try {
      _stateListStory = const LoadingState.loading();
      notifyListeners();

      final listStoryModel =
          await _apiService.getAllStories(token: token);

      _stateListStory = LoadingState.loaded(listStoryModel);
      notifyListeners();
    } on SocketException {
      _stateListStory =
          const LoadingState.error(StringHelper.noInternetConnection);
      notifyListeners();
    } catch (e, stacktrace) {
      _stateListStory = LoadingState.error(e.toString());
      notifyListeners();
    }
  }
}
