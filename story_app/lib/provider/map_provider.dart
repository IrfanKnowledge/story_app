import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:story_app/data/model/location_model.dart';
import 'package:story_app/data/string/string_data.dart';
import 'package:story_app/utils/loading_state.dart';

class MapProvider extends ChangeNotifier {
  MapProvider();

  LoadingState<LocationData> _stateLocationData = const LoadingState.initial();

  LoadingState<LocationData> get stateLocationData => _stateLocationData;

  LoadingState<LocationModel> _stateLocationModel =
      const LoadingState.initial();

  LoadingState<LocationModel> get stateLocationModel => _stateLocationModel;

  void fetchLocationData(Location location) async {
    try {
      _stateLocationData = const LoadingState.loading();
      notifyListeners();

      final locationData = await location.getLocation();

      _stateLocationData = LoadingState.loaded(locationData);
      notifyListeners();
    } on SocketException {
      _stateLocationData =
      const LoadingState.error(StringData.noInternetConnection);
      notifyListeners();
    } catch (e, _) {
      _stateLocationData = LoadingState.error(e.toString());
      notifyListeners();
    }
  }

  void fetchPlaceMark(LatLng latLng) async {
    try {
      _stateLocationModel = const LoadingState.loading();
      notifyListeners();

      final listPlaceMark = await geo.placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

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
    } catch (e, _) {
      _stateLocationModel = LoadingState.error(e.toString());
      notifyListeners();
    }
  }
}
