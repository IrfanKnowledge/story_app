import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/detail_story_model.dart';
import 'package:story_app/data/string/string_data.dart';
import 'package:story_app/utils/loading_state.dart';

class DetailStoryProvider extends ChangeNotifier {
  final ApiService _apiService;

  DetailStoryProvider({
    required ApiService apiService,
    required String token,
    required String id,
  }) : _apiService = apiService {
    fetchStoryDetail(token: token, id: id);
  }

  LoadingState<DetailStoryModel> _stateDetailStoryModel =
      const LoadingState.initial();

  LoadingState<DetailStoryModel> get stateDetailStoryModel =>
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
          const LoadingState.error(StringData.noInternetConnection);
      notifyListeners();
    } catch (e, _) {
      _stateDetailStoryModel = LoadingState.error(e.toString());
      notifyListeners();
    }
  }
}
