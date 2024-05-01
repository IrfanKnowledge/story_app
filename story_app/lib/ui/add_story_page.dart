import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/color_scheme/theme.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/location_model.dart';
import 'package:story_app/flavor_config.dart';
import 'package:story_app/provider/add_story_provider.dart';
import 'package:story_app/provider/location_provider.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/provider/upload_image_story_provider.dart';
import 'package:story_app/ui/map_page.dart';
import 'package:story_app/widget/text_with_red_star.dart';

class AddStoryPage extends StatefulWidget {
  static const String goRoutePath = 'add_story';

  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final TextEditingController _controllerDescription = TextEditingController();

  TextStyle? _textStyleSubTitle;
  TextStyle? _textStyleBody;

  AppLocalizations? _appLocalizations;

  MaterialScheme? _colorSchemeCustom;
  TextTheme? _textTheme;

  @override
  void initState() {
    final providerLocation = context.read<LocationProvider>();

    Future.microtask(() {
      providerLocation.locationModel = null;
    });

    super.initState();
  }

  @override
  void dispose() {
    _controllerDescription.dispose();
    super.dispose();
  }

  void _initStyle(BuildContext context) {
    _textStyleSubTitle = _textTheme!.titleSmall?.copyWith(
      color: _colorSchemeCustom!.onSurface,
      fontWeight: FontWeight.bold,
    );
    _textStyleBody = _textTheme!.bodyMedium?.copyWith(
      color: _colorSchemeCustom!.onSurface,
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        child: _buildMultiProvider(
          builder: (context) {
            return _buildContainer(context);
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: Text(
        _appLocalizations!.newStory,
        style: _textTheme!.titleLarge?.copyWith(
          color: _colorSchemeCustom!.onSurface,
        ),
      ),
      backgroundColor: _colorSchemeCustom!.surfaceContainer,
      surfaceTintColor: _colorSchemeCustom!.surfaceContainer,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _colorSchemeCustom!.outlineVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMultiProvider({
    required Widget Function(BuildContext context) builder,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AddStoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UploadImageStoryProvider(apiService: ApiService()),
        ),
      ],
      builder: (context, _) => builder(context),
    );
  }

  Container _buildContainer(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildGetPicture(context),
          const Divider(height: 32),
          _buildDescription1(context),
          // _buildDescription2(context),
          _buildAddStoryFromMap(
            context: context,
            isPaidVersion: FlavorConfig.instance.flavorValues.isPaidVersion,
          ),
          const Divider(height: 32),
          _buildUploadButtonOrLoadingButton(),
        ],
      ),
    );
  }

  Column _buildGetPicture(BuildContext context) {
    return Column(
      children: [
        context.watch<AddStoryProvider>().imagePath == null
            ? const Icon(
                Icons.image,
                size: 100,
              )
            : _showImage(context),
        const Gap(16),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => _onCameraView(context),
              child: Text(_appLocalizations!.camera),
            ),
            const Gap(10),
            ElevatedButton(
              onPressed: () => _onGalleryView(context),
              child: Text(_appLocalizations!.gallery),
            ),
          ],
        ),
      ],
    );
  }

  Widget _showImage(BuildContext context) {
    final imagePath = context.read<AddStoryProvider>().imagePath;
    const double height = 300.0;
    const BoxFit boxFit = BoxFit.contain;

    final image = kIsWeb
        ? Image.network(
            imagePath ?? '',
            fit: boxFit,
            height: height,
          )
        : Image.file(
            File(imagePath ?? ''),
            fit: boxFit,
            height: height,
          );

    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: 300,
      child: image,
    );
  }

  Widget _buildDescription1(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          TextWithRedStar(
            value: '${_appLocalizations!.description}:',
            textStyle: _textStyleSubTitle!,
          ),
          const Gap(8),
          TextField(
            controller: _controllerDescription,
            keyboardType: TextInputType.multiline,
            minLines: 3,
            maxLines: 6,
            maxLength: 50,
            buildCounter: (
              context, {
              required currentLength,
              required isFocused,
              maxLength,
            }) {
              return Text('$currentLength / $maxLength');
            },
            decoration: InputDecoration(
              hintText: _appLocalizations!.description,
              border: const OutlineInputBorder(),
              filled: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription2(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width),
          TextWithRedStar(
            value: '${_appLocalizations!.description}:',
            textStyle: _textStyleSubTitle!,
          ),
          const Gap(8),
          const Text('-'),
          const Gap(16),
          Align(
            alignment: Alignment.center,
            child: ElevatedButton(
              onPressed: () {},
              child: Text(_appLocalizations!.changeDescription),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddStoryFromMap({
    required BuildContext context,
    required bool isPaidVersion,
  }) {
    if (!isPaidVersion) return const Gap(0);

    final providerLocation = context.watch<LocationProvider>();
    final locationModel = providerLocation.locationModel;

    return Column(
      children: [
        const Divider(height: 32),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${_appLocalizations!.addLocation}:',
                style: _textStyleSubTitle,
              ),
              const Gap(8),
              locationModel != null
                  ? _buildLocationInformation(
                      context,
                      locationModel,
                    )
                  : const Gap(0),
              Align(
                alignment: Alignment.center,
                child: ElevatedButton(
                  onPressed: () => _onAddLocation(context),
                  child: Text(_appLocalizations!.addLocation),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Column _buildLocationInformation(
    BuildContext context,
    LocationModel locationModel,
  ) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "Latitude: ${locationModel.latLng.latitude}",
          style: _textStyleBody,
        ),
        Text(
          "Longitude: ${locationModel.latLng.longitude}",
          style: _textStyleBody,
        ),
        Text(
          locationModel.street,
          style: _textStyleBody,
        ),
        Text(
          locationModel.address,
          style: _textStyleBody,
        ),
        const Gap(8),
      ],
    );
  }

  Widget _buildUploadButtonOrLoadingButton() {
    return Consumer<UploadImageStoryProvider>(
      builder: (context, provider, _) {
        final state = provider.stateUpload;

        Widget result = state.maybeWhen(
          loading: () => _buildIconButtonLoading(),
          loaded: (data) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              context.pop();
            });

            return _buildIconButtonLoading();
          },
          orElse: () {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: _buildFilledButtonUpload(context),
            );
          },
        );

        return result;
      },
    );
  }

  /// button for upload image
  FilledButton _buildFilledButtonUpload(BuildContext context) {
    return FilledButton(
      style: FilledButton.styleFrom(
        minimumSize: const Size(
          double.infinity,
          40,
        ),
      ),
      onPressed: () {
        _onUpload(
          context: context,
          description: _controllerDescription.text,
        );
      },
      child: Text(_appLocalizations!.upload),
    );
  }

  IconButton _buildIconButtonLoading() {
    return IconButton(
      onPressed: () {},
      icon: const CircularProgressIndicator(),
    );
  }

  SnackBar snackBar({String text = '', int seconds = 1}) {
    return SnackBar(
      content: Text(text),
      duration: const Duration(
        seconds: 1,
      ),
    );
  }

  void _onCameraView(BuildContext context) async {
    final provider = context.read<AddStoryProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isIos);

    if (isNotMobile) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar(text: _appLocalizations!.cameraError),
      );
      return;
    }

    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      _onCroppedFile(pickedFile, provider);
    }
  }

  void _onGalleryView(BuildContext context) async {
    final provider = context.read<AddStoryProvider>();

    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      _onCroppedFile(pickedFile, provider);
    }
  }

  void _onCroppedFile(XFile pickedFile, AddStoryProvider provider) async {
    CroppedFile? croppedFile = await ImageCropper().cropImage(
      sourcePath: pickedFile.path,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
      compressQuality: 70,
      uiSettings: [
        WebUiSettings(context: context),
      ],
    );

    if (croppedFile != null) {
      List<int> bytes = await croppedFile.readAsBytes();
      pickedFile = XFile.fromData(
        Uint8List.fromList(bytes),
        path: croppedFile.path,
      );

      final directory = await getExternalStorageDirectory();
      final file = File('${directory!.path}/${pickedFile.name}');

      await file.writeAsBytes(Uint8List.fromList(bytes));

      provider.imageFile = pickedFile;
      provider.imagePath = pickedFile.path;
    }
  }

  void _onAddLocation(BuildContext context) {
    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotCompatible = !(isAndroid || isIos);

    if (isNotCompatible) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar(text: _appLocalizations!.addLocationError),
      );
      return;
    }

    context.go('/${AddStoryPage.goRoutePath}/${MapPage.goRoutePath}');
  }

  void _onUpload({
    required BuildContext context,
    required String description,
  }) async {
    final addStoryProvider = context.read<AddStoryProvider>();
    final providerPref = context.read<PreferencesProvider>();
    final readUploadProvider = context.read<UploadImageStoryProvider>();
    final providerLocation = context.read<LocationProvider>();

    final imagePath = addStoryProvider.imagePath;
    final imageFile = addStoryProvider.imageFile;

    if (imagePath == null || imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar(text: _appLocalizations!.imageSelectError),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar(text: _appLocalizations!.descriptionFormError),
      );
      return;
    }

    final stateToken = providerPref.stateToken;
    final token = stateToken.maybeWhen(
      loaded: (data) => data,
      orElse: () => '',
    );

    print('upload token: $token');

    final fileName = imageFile.name;
    final photoBytes = await imageFile.readAsBytes();

    final compressedPhotoBytes =
        await readUploadProvider.compressImage(photoBytes);

    final latLng = providerLocation.locationModel?.latLng;

    readUploadProvider.upload(
      photoBytes: compressedPhotoBytes,
      fileName: fileName,
      description: description,
      lat: latLng?.latitude,
      lon: latLng?.longitude,
      token: token,
    );
  }

  @override
  Widget build(BuildContext context) {
    _appLocalizations = AppLocalizations.of(context);
    _colorSchemeCustom = context.read<MaterialThemeProvider>().currentSelected;
    _textTheme = Theme.of(context).textTheme;

    _initStyle(context);

    return _buildScaffold(context);
  }
}
