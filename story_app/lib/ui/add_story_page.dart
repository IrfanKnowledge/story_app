import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/preferences/preferences_helper.dart';
import 'package:story_app/provider/add_story_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/provider/upload_image_story_provider.dart';
import 'package:story_app/ui/list_story_page.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/widget/center_error.dart';
import 'package:story_app/widget/center_loading.dart';

class AddStoryPage extends StatefulWidget {
  static const String path = '/add_story';

  const AddStoryPage({super.key});

  @override
  State<AddStoryPage> createState() => _AddStoryPageState();
}

class _AddStoryPageState extends State<AddStoryPage> {
  final TextEditingController _controllerDescription = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('New Story'),
      ),
      body: SingleChildScrollView(
        child: _buildMultiProvider(),
      ),
    );
  }

  Widget _buildMultiProvider() {
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
      child: _getTokenIfNotGuest(),
    );
  }

  Widget _getTokenIfNotGuest() {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, _) {
        // if state is loading (fetch isLogin from SharedPreference),
        // show loading
        if (provider.stateIsLogin == ResultState.loading) {
          return const CenterLoading();

          // if login is true
        } else if (provider.isLogin) {
          print('isLogin = ${provider.isLogin}');
          // if state is loading (fetch token from SharedPreference),
          // show loading
          if (provider.stateToken == ResultState.loading) {
            return const CenterLoading();

            // if token is not empty, then [_buildContainer()]
          } else if (provider.stateToken == ResultState.hasData) {
            return _buildContainer(context);

            // if token is empty, show error message
          } else {
            return CenterError(
              description: provider.messageToken,
            );
          }

          // if login is not true
        } else {
          return _buildContainer(context);
        }
      },
    );
  }

  Container _buildContainer(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.only(
        top: 32,
        bottom: 8,
        right: 16.0,
        left: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // context.watch == provider.of<>(context)
          // to listen imagePath from AddStoryProvider
          context.watch<AddStoryProvider>().imagePath == null

              // if null, show default image
              ? const Icon(
                  Icons.image,
                  size: 100,
                )

              // if not null, show image
              : _showImage(context),
          const SizedBox(height: 20),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () => _onCameraView(context),
                child: const Text('Camera'),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () => _onGalleryView(context),
                child: const Text('Gallery'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          TextField(
            controller: _controllerDescription,
            keyboardType: TextInputType.multiline,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: 'Deskripsi',
              border: OutlineInputBorder(),
              filled: true,
            ),
          ),
          const SizedBox(height: 10),
          _buildUploadButtonOrLoadingButton(),
        ],
      ),
    );
  }

  void _onGalleryView(BuildContext context) async {
    // context.read == Provider.of<>(context, listen: false),
    // access AddStoryProvider();
    final provider = context.read<AddStoryProvider>();

    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 500,
      imageQuality: 90,
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
      maxHeight: 500,
      imageQuality: 90,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage(BuildContext context) {
    final imagePath = context.read<AddStoryProvider>().imagePath;

    // check is app running on Web Environment or not
    return kIsWeb
        ? Image.network(
            imagePath.toString(),
            fit: BoxFit.contain,
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.contain,
          );
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

    final preferenceProvider = context.read<PreferencesProvider>();
    final isLogin = preferenceProvider.isLogin;
    var token = preferenceProvider.token;

    // if login is not true, token = string empty
    if (!isLogin) {
      token = '';
    }

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

  SnackBar snackBar(String text) {
    return SnackBar(
      content: Text(text),
      duration: const Duration(
        seconds: 1,
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
        return _buildElevatedButtonUpload(context);
      },
    );
  }

  /// button for upload image
  ElevatedButton _buildElevatedButtonUpload(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
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
      child: const Text('Upload'),
    );
  }

  /// loading button for upload image process
  IconButton _buildIconButtonLoading() {
    return IconButton(
      onPressed: () {},
      icon: const CircularProgressIndicator(),
    );
  }

  /// auto navigate back to previous page if upload image is success
  Future<String> _autoNavigateBack(BuildContext context) async {
    Future.delayed(
      const Duration(seconds: 1),
      () {
        kIsWeb ? context.go(ListStoryPage.path) : context.pop();
      },
    );
    return 'Loading...';
  }
}
