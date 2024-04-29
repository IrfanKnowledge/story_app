import 'package:google_maps_flutter/google_maps_flutter.dart';

class LocationModel {
  final String street;
  final String address;
  final LatLng latLng;

  LocationModel({
    required this.street,
    required this.address,
    required this.latLng,
  });
}
