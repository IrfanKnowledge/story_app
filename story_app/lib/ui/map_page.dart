import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/data/model/location_model.dart';
import 'package:story_app/provider/location_provider.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:geocoding/geocoding.dart' as geo;
import 'package:maps_launcher/maps_launcher.dart';

class MapPage extends StatefulWidget {
  static const String goRoutePath = 'map';

  final LatLng? _latLng;

  const MapPage({super.key, required LatLng? latLng}) : _latLng = latLng;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _defaultLatLng = const LatLng(-6.8957473, 107.6337669);
  final _defaultZoom = 18.0;
  late final GoogleMapController _googleMapController;
  final Set<Marker> _markers = {};
  final _uuid = const Uuid();

  geo.Placemark? _placemark;

  bool _isMyLocationBtnSelected = false;

  AppLocalizations? _appLocalizations;

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildScaffoldBody(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final colorSchemeCustom =
        context.watch<MaterialThemeProvider>().currentSelected;

    return AppBar(
      title: Text(_appLocalizations!.locationSelect),
      backgroundColor: colorSchemeCustom.surfaceContainer,
      surfaceTintColor: colorSchemeCustom.surfaceContainer,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScaffoldBody(BuildContext context) {
    return Stack(
      children: [
        _buildGoogleMap(context),
        if (widget._latLng == null)
          Positioned(
            top: 16,
            right: 16,
            child: _buildMyLocationButton(context),
          )
        else
          const SizedBox.shrink(),
        if (_placemark != null)
          Positioned(
            bottom: 16,
            right: 16,
            left: 16,
            child: _buildInformation(context: context, place: _placemark!),
          )
        else
          const SizedBox.shrink(),
        if (_markers.isNotEmpty)
          Positioned(
            top: 16,
            left: 16,
            child: FloatingActionButton.small(
              onPressed: () {
                final latLng = _markers.first.position;
                MapsLauncher.launchCoordinates(
                  latLng.latitude,
                  latLng.longitude,
                );
              },
              child: const Icon(Icons.map_outlined),
            ),
          )
        else
          const SizedBox.shrink(),
      ],
    );
  }

  GoogleMap _buildGoogleMap(BuildContext context) {
    return GoogleMap(
      markers: _markers,
      initialCameraPosition: CameraPosition(
        zoom: _defaultZoom,
        target: widget._latLng ?? _defaultLatLng,
      ),
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      myLocationEnabled: true,
      onMapCreated: (controller) async {
        setState(() {
          _googleMapController = controller;
        });

        if (widget._latLng != null) {
          final info = await geo.placemarkFromCoordinates(
            widget._latLng!.latitude,
            widget._latLng!.longitude,
          );

          final geo.Placemark place = info.first;

          setState(() {
            _placemark = place;
          });

          _defineMarker(
            latLng: widget._latLng!,
          );
        }

        _googleMapController.animateCamera(
          CameraUpdate.newLatLng(widget._latLng ?? _defaultLatLng),
        );
      },
      onLongPress: (argument) {
        if (widget._latLng == null) {
          _onGoogleMapLongPress(context, argument);
        }
      },
    );
  }

  Widget _buildMyLocationButton(BuildContext context) {
    final colorSchemeCustom =
        context.watch<MaterialThemeProvider>().currentSelected;

    ButtonStyle selectedFalseStyle() {
      return IconButton.styleFrom(
        backgroundColor: colorSchemeCustom.surfaceContainerHighest,
        foregroundColor: colorSchemeCustom.primary,
        shape: CircleBorder(
          side: BorderSide(color: colorSchemeCustom.outlineVariant),
        ),
      );
    }

    ButtonStyle selectedTrueStyle() {
      return IconButton.styleFrom(
        backgroundColor: colorSchemeCustom.primary,
        foregroundColor: colorSchemeCustom.onPrimary,
      );
    }

    return IconButton.filled(
      style:
          _isMyLocationBtnSelected ? selectedTrueStyle() : selectedFalseStyle(),
      onPressed: () => _onMyLocationButtonPress(context),
      icon: const Icon(Icons.my_location),
    );
  }

  Widget _buildInformation({
    required BuildContext context,
    required geo.Placemark place,
  }) {
    final colorSchemeCustom =
        context.watch<MaterialThemeProvider>().currentSelected;
    final textTheme = Theme.of(context).textTheme;
    final address = _addressFromPlaceMark(place);

    return Container(
      padding: const EdgeInsets.all(8.0),
      constraints: const BoxConstraints(maxWidth: 700),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: colorSchemeCustom.secondaryContainer,
        boxShadow: [
          BoxShadow(
            blurRadius: 20,
            offset: Offset.zero,
            color: colorSchemeCustom.shadow.withOpacity(0.6),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  place.street!,
                  style: textTheme.titleLarge!.copyWith(
                    color: colorSchemeCustom.onSecondaryContainer,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  address,
                  style: textTheme.bodyMedium!.copyWith(
                    color: colorSchemeCustom.onSecondaryContainer,
                  ),
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _addressFromPlaceMark(geo.Placemark place) {
    return "${place.street}, ${place.subLocality}, ${place.locality}, "
        "${place.subAdministrativeArea}, ${place.postalCode},"
        " ${place.administrativeArea}, ${place.country}";
  }

  void _showSnackBar({
    required BuildContext context,
    required String text,
  }) {
    final SnackBar snackBar = SnackBar(
      content: Text(text),
      duration: const Duration(seconds: 1),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void _onGoogleMapLongPress(BuildContext context, LatLng latLng) async {
    final providerLocation = context.read<LocationProvider>();

    void vShowSnackBar(String text) {
      _showSnackBar(context: context, text: text);
    }

    try {
      final info = await geo.placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      final geo.Placemark place = info.first;
      final address = _addressFromPlaceMark(place);

      setState(() {
        _placemark = place;
        _isMyLocationBtnSelected = false;
      });

      _defineMarker(
        provider: providerLocation,
        latLng: latLng,
        title: place.street!,
        description: address,
      );

      _googleMapController.animateCamera(
        CameraUpdate.newLatLngZoom(latLng, _defaultZoom),
      );
    } catch (e, _) {
      vShowSnackBar(e.toString());
    }
  }

  void _onMyLocationButtonPress(BuildContext context) async {
    final providerLocation = context.read<LocationProvider>();

    void vShowSnackBar(String text) {
      _showSnackBar(context: context, text: text);
    }

    final Location location = Location();
    late bool serviceEnabled;
    late PermissionStatus permissionStatus;
    late LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        vShowSnackBar(_appLocalizations!.locationServiceEnabled);
        setState(() {
          _isMyLocationBtnSelected = false;
        });
        return;
      }
    }

    permissionStatus = await location.hasPermission();
    if (permissionStatus == PermissionStatus.denied) {
      permissionStatus = await location.requestPermission();
      if (permissionStatus != PermissionStatus.granted) {
        vShowSnackBar(_appLocalizations!.locationPermission);
        setState(() {
          _isMyLocationBtnSelected = false;
        });
        return;
      }
    }

    try {
      locationData = await location.getLocation();
      final latLng = LatLng(locationData.latitude!, locationData.longitude!);

      final info = await geo.placemarkFromCoordinates(
        latLng.latitude,
        latLng.longitude,
      );

      final geo.Placemark place = info.first;
      final address = _addressFromPlaceMark(place);

      setState(() {
        _placemark = place;
        _isMyLocationBtnSelected = true;
      });

      _defineMarker(
        provider: providerLocation,
        latLng: latLng,
        title: place.street!,
        description: address,
      );

      _googleMapController.animateCamera(
        CameraUpdate.newLatLng(latLng),
      );
    } catch (e, _) {
      vShowSnackBar(e.toString());
    }
  }

  void _defineMarker({
    LocationProvider? provider,
    required LatLng latLng,
    String title = '',
    String description = '',
  }) {
    final marker = Marker(
      markerId: MarkerId(_uuid.v4()),
      position: latLng,
      infoWindow: InfoWindow(
        title: title,
        snippet: description,
      ),
    );

    setState(() {
      _markers.clear();
      _markers.add(marker);
    });

    if (provider != null) {
      provider.locationModel = LocationModel(
        street: title,
        address: description,
        latLng: latLng,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    _appLocalizations = AppLocalizations.of(context);

    return _buildScaffold(context);
  }
}
