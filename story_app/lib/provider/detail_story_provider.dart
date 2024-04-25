import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/detail_story_model.dart';
import 'package:story_app/utils/loading_state.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/utils/string_helper.dart';

class DetailStoryProvider extends ChangeNotifier {
  final ApiService _apiService;

  DetailStoryProvider({
    required ApiService apiService,
    required String token,
    required String id,
  }) : _apiService = apiService {
    fetchStoryDetail(token: token, id: id);
  }

  LoadingState<DetailStoryWrap> _stateDetailStoryModel =
      const LoadingState.initial();

  LoadingState<DetailStoryWrap> get stateDetailStoryModel =>
      _stateDetailStoryModel;

  void fetchStoryDetail({
    required String token,
    required String id,
  }) async {
    try {
      _stateDetailStoryModel = const LoadingState.loading();
      notifyListeners();

      final detailStoryModel = await _apiService.getDetailStory(
        token: token,
        id: id,
      );

      _stateDetailStoryModel = LoadingState.loaded(detailStoryModel);
      notifyListeners();
    } on SocketException {
      _stateDetailStoryModel =
          const LoadingState.error(StringHelper.noInternetConnection);
      notifyListeners();
    } catch (e, stacktrace) {
      _stateDetailStoryModel = LoadingState.error(e.toString());
      notifyListeners();
    }
  }
}
