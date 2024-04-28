import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:uuid/uuid.dart';

class MapPage extends StatefulWidget {
  static const String goRoutePath = 'map';

  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final _dicodingOffice = const LatLng(-6.8957473, 107.6337669);
  final _defaultZoom = 18.0;
  late final GoogleMapController _googleMapController;
  final Set<Marker> _markers = {};
  final _uuid = const Uuid();

  AppLocalizations? _appLocalizations;

  @override
  void initState() {
    // final marker = Marker(
    //   markerId: const MarkerId("dicoding"),
    //   position: _dicodingOffice,
    //   onTap: () {
    //     _googleMapController.animateCamera(
    //       CameraUpdate.newLatLngZoom(_dicodingOffice, _defaultZoom),
    //     );
    //   },
    // );
    // _markers.add(marker);
    super.initState();
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildGoogleMap(),
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

  GoogleMap _buildGoogleMap() {
    return GoogleMap(
      markers: _markers,
      initialCameraPosition: CameraPosition(
        zoom: _defaultZoom,
        target: _dicodingOffice,
      ),
      onMapCreated: (controller) {
        setState(() {
          _googleMapController = controller;
        });
      },
      onLongPress: (argument) {
        setState(() {
          final latLang = LatLng(argument.latitude, argument.longitude);
          final marker = Marker(
            markerId: MarkerId(_uuid.v4()),
            position: latLang,
            onTap: () {
              _googleMapController.animateCamera(
                CameraUpdate.newLatLngZoom(latLang, _defaultZoom),
              );
            },
            infoWindow: const InfoWindow(
              title: 'hello world',
              snippet: 'hello snipped',
            ),
          );
          _markers.clear();
          _markers.add(marker);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    _appLocalizations = AppLocalizations.of(context);

    return _buildScaffold(context);
  }
}
