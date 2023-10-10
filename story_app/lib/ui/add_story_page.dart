import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/provider/add_story_provider.dart';
import 'package:story_app/provider/upload_image_story_provider.dart';

class AddStoryPage extends StatefulWidget {
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

  Widget _buildChangeNotifier() {
    return ChangeNotifierProvider(
      create: (_) => AddStoryProvider(),
      builder: (context, _) => _buildContainer(context),
    );
  }

  Widget _buildMultiProvider() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AddStoryProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => UploadImageStoryProvider(apiService: ApiService()),
        ),
      ],
      builder: (context, _) => _buildContainer(context),
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
          /// context.watch == provider.of<>(context)
          /// to listen imagePath from AddStoryProvider
          context.watch<AddStoryProvider>().imagePath == null

              /// if null, show default image
              ? const Icon(
                  Icons.image,
                  size: 100,
                )

              /// if not null, show image
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
          ElevatedButton(
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
          ),
        ],
      ),
    );
  }

  void _onGalleryView(BuildContext context) async {
    /// context.read == Provider.of<>(context, listen: false),
    /// access AddStoryProvider();
    final provider = context.read<AddStoryProvider>();

    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
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
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  Widget _showImage(BuildContext context) {
    final imagePath = context.read<AddStoryProvider>().imagePath;

    /// check is app running on Web Environment or not
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
    final provider = context.read<AddStoryProvider>();
    final imagePath = provider.imagePath;
    final imageFile = provider.imageFile;
    if (imagePath == null || imageFile == null) return;

    final uploadProvider = context.read<UploadImageStoryProvider>();
    final fileName = imageFile.name;
    final photoBytes = await imageFile.readAsBytes();

    final compressedPhotoBytes = await uploadProvider.compressImage(photoBytes);

    uploadProvider.upload(
      photoBytes: compressedPhotoBytes,
      fileName: fileName,
      description: description,
    );
  }
}
