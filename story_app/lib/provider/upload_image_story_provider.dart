import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/upload_image_story_model.dart';
import 'package:story_app/data/string/string_data.dart';
import 'package:story_app/utils/loading_state.dart';

class UploadImageStoryProvider extends ChangeNotifier {
  final ApiService apiService;

  UploadImageStoryProvider({required this.apiService});

  LoadingState<UploadImageStoryModel> _stateUpload =
      const LoadingState.initial();

  LoadingState<UploadImageStoryModel> get stateUpload => _stateUpload;

  Future<List<int>> compressImage(List<int> bytes) async {
    const int maxBytes = 1000000;
    final int imageLength = bytes.length;

    // jika imageLength lebih kecil dari 1 ribu bytes (1 MB),
    // maka tidak perlu dilakukan compress
    if (imageLength < maxBytes) return bytes;

    // icon.decodeImage will using UI thread,
    // so highly recommend don't use this
    final img.Image image = img.decodeImage(bytes as Uint8List)!;
    int compressQuality = 90;
    int length = imageLength;
    List<int> newByte = [];

    do {
      compressQuality -= 10;

      // icon.encodeJpg will using UI thread,
      // so highly recommend don't use this
      newByte = img.encodeJpg(
        image,
        quality: compressQuality,
      );

      length = newByte.length;
    } while (length > maxBytes);

    return newByte;
  }

  void upload({
    required List<int> photoBytes,
    required String fileName,
    required String description,
    double? lat,
    double? lon,
    String token = '',
  }) async {
    try {
      _stateUpload = const LoadingState.loading();
      notifyListeners();

      final uploadImageStoryModel = await apiService.uploadStory(
        photoBytes: photoBytes,
        fileName: fileName,
        description: description,
        lat: lat,
        lon: lon,
        token: token,
      );

      _stateUpload = LoadingState.loaded(uploadImageStoryModel);
      notifyListeners();
    } on SocketException {
      _stateUpload = const LoadingState.error(StringData.noInternetConnection);
      notifyListeners();
    } catch (e, _) {
      _stateUpload = LoadingState.error(e.toString());
      notifyListeners();
    }
  }
}
