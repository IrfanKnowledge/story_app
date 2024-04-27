import 'dart:io';

import 'package:flutter/material.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/list_story_model.dart';
import 'package:story_app/data/string/string_data.dart';
import 'package:story_app/utils/loading_state.dart';

class ListStoryProvider extends ChangeNotifier {
  final ApiService _apiService;

  ListStoryProvider({
    required ApiService apiService,
  }) : _apiService = apiService;

  LoadingState<ListStoryModel> _stateListStory = const LoadingState.initial();

  final List<ListStory> _listStory = [];
  int? pageItems = 1;
  final sizeItems = 10;

  LoadingState<ListStoryModel> get stateListStory => _stateListStory;

  List<ListStory> get listStory => _listStory;

  ///
  /// Pastikan [pageItems] tidak null sebelum menggunakan [fetchAllStoriesWithPagination]
  ///
  void fetchAllStoriesWithPagination({required String token}) async {
    try {
      if (pageItems == 1) {
        _stateListStory = const LoadingState.loading();
        notifyListeners();
      }

      final listStoryModel = await _apiService.getAllStories(
        token: token,
        pageItems: pageItems!,
        sizeItems: sizeItems,
      );

      final listStory = listStoryModel.listStory;
      _listStory.addAll(listStory);

      if (listStory.length < sizeItems) {
        pageItems = null;
      } else {
        pageItems = pageItems! + 1;
      }

      _stateListStory = LoadingState.loaded(listStoryModel);
      notifyListeners();
    } on SocketException {
      _stateListStory =
          const LoadingState.error(StringData.noInternetConnection);
      notifyListeners();
    } catch (e, _) {
      _stateListStory = LoadingState.error(e.toString());
      notifyListeners();
    }
  }

  ///
  /// Gunakan ini saat pertama kali melakukan [fetchAllStoriesWithPagination].
  /// Gunakan sebelum memanggil [fetchAllStoriesWithPagination].
  ///
  void setAllValueToDefault() {
    _listStory.clear();
    pageItems = 1;
    _stateListStory = const LoadingState.initial();
  }
}
