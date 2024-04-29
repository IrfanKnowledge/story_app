import 'package:flutter/foundation.dart';
import 'package:story_app/data/model/location_model.dart';

class LocationProvider extends ChangeNotifier {
  LocationModel? _locationModel;
  LocationModel? get locationModel => _locationModel;
  set locationModel (LocationModel? locationModel) {
    _locationModel = locationModel;
    notifyListeners();
  }
}
