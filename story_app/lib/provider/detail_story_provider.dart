import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/detail_story_model.dart';
import 'package:story_app/data/model/location_model.dart';
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

  LoadingState<LocationModel> _stateLocationModel =
      const LoadingState.initial();

  LoadingState<LocationModel> get stateLocationModel => _stateLocationModel;

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

  void fetchPlaceMark(LatLng latLng) async {
    try {
      _stateLocationModel = const LoadingState.loading();
      notifyListeners();

      print('before listPlaceMark');

      final listPlaceMark = await geo.placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );


      print('after listPlaceMark: $listPlaceMark');

      final placeMark = listPlaceMark.first;
      final street = placeMark.street;
      final address =
          "${placeMark.street}, ${placeMark.subLocality}, ${placeMark.locality}, "
          "${placeMark.subAdministrativeArea}, ${placeMark.postalCode},"
          " ${placeMark.administrativeArea}, ${placeMark.country}";

      final locationModel = LocationModel(
        street: street ?? '',
        address: address,
        latLng: latLng,
      );

      _stateLocationModel = LoadingState.loaded(locationModel);
      notifyListeners();
    } on SocketException {
      _stateLocationModel =
          const LoadingState.error(StringData.noInternetConnection);
      notifyListeners();
    } catch (e, stacktrace) {
      _stateLocationModel = LoadingState.error(e.toString());
      print('detail, locationModel, error: ${e.toString()}, stacktrace: ${stacktrace.toString()}');
      notifyListeners();
    }
  }
}
