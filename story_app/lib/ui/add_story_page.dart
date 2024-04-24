import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/preferences/preferences_helper.dart';
import 'package:story_app/provider/add_story_provider.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/provider/upload_image_story_provider.dart';
import 'package:story_app/ui/bottom_nav_bar.dart';
import 'package:story_app/ui/list_story_page.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/widget/center_error.dart';
import 'package:story_app/widget/center_loading.dart';
import 'package:story_app/widget/text_with_red_star.dart';

class AddStoryPage extends StatefulWidget {
  static const String goRoutePath = 'add_story';

  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final TextEditingController _controllerDescription = TextEditingController();

  AppLocalizations? _appLocalizations;

  AppBar _buildAppBar(BuildContext context) {
    final colorSchemeCustom =
        context.watch<MaterialThemeProvider>().currentSelected;

    return AppBar(
      title: Text(_appLocalizations!.newStory),
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

  Widget _buildMultiProvider({
    required Widget Function(BuildContext context) builder,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
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
          ),
          // _buildDescription(context),
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
            const SizedBox(width: 10),
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

  Widget _buildDescription(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: MediaQuery.of(context).size.width),
          TextWithRedStar(value: '${_appLocalizations!.description}:'),
          const Gap(4),
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

  Widget _buildUploadButtonOrLoadingButton() {
    return Consumer<UploadImageStoryProvider>(
      builder: (context, provider, _) {
        if (provider.stateUpload == ResultState.loading) {
          return _buildIconButtonLoading();
        } else if (provider.stateUpload == ResultState.hasData) {
          return FutureBuilder(
            future: _autoNavigateBack(context),
            builder: (_, __) => _buildIconButtonLoading(),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: _buildFilledButtonUpload(context),
        );
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

  /// loading button for upload image process
  IconButton _buildIconButtonLoading() {
    return IconButton(
      onPressed: () {},
      icon: const CircularProgressIndicator(),
    );
  }

  SnackBar snackBar(String text) {
    return SnackBar(
      content: Text(text),
      duration: const Duration(
        seconds: 1,
      ),
    );
  }

  /// auto navigate back to previous page if upload image is success
  Future<String> _autoNavigateBack(BuildContext context) async {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        kIsWeb ? context.go(ListStoryPage.goRoutePath) : context.pop();
      },
    );
    return 'Loading...';
  }

  void _onGalleryView(BuildContext context) async {
    final provider = context.read<AddStoryProvider>();

    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  void _onCameraView(BuildContext context) async {
    final provider = context.read<AddStoryProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isIos = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isIos);
    if (isNotMobile) return;

    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  void _onUpload({
    required BuildContext context,
    required String description,
  }) async {
    final addStoryProvider = context.read<AddStoryProvider>();
    final imagePath = addStoryProvider.imagePath;
    final imageFile = addStoryProvider.imageFile;

    if (imagePath == null || imageFile == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar('Foto/Gambar belum dipilih'),
      );
      return;
    }

    if (description.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar('deskripsi tidak boleh kosong'),
      );
      return;
    }

    final providerPref = context.read<PreferencesProvider>();
    final stateToken = providerPref.stateToken;

    final token = stateToken.maybeWhen(
      loaded: (data) => data,
      orElse: () => '',
    );

    final fileName = imageFile.name;

    final readUploadProvider = context.read<UploadImageStoryProvider>();
    final photoBytes = await imageFile.readAsBytes();

    final compressedPhotoBytes =
        await readUploadProvider.compressImage(photoBytes);

    readUploadProvider.upload(
      photoBytes: compressedPhotoBytes,
      fileName: fileName,
      description: description,
      token: token,
    );
  }

  @override
  Widget build(BuildContext context) {
    _appLocalizations = AppLocalizations.of(context);

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
}
