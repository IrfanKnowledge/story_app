import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/utils/string_helper.dart';

class UploadImageStoryProvider extends ChangeNotifier {
  final ApiService apiService;

  UploadImageStoryProvider({required this.apiService})
      : _state = ResultState.notStarted;

  String _message = '';
  ResultState _state;


  ResultState get resultState => _state;

  String get message => _message;

  Future<List<int>> compressImage(List<int> bytes) async {
    int maxBytes = 1000000;
    int imageLength = bytes.length;

    print('$imageLength, $maxBytes');
    print(imageLength < maxBytes);
    /// jika imageLength lebih kecil dari 1 ribu bytes (1 MB),
    /// maka tidak perlu dilakukan compress
    if (imageLength < maxBytes) return bytes;

    final img.Image image = img.decodeImage(Uint8List.fromList(bytes))!;
    int compressQuality = 100;
    int length = imageLength;
    List<int> newByte = [];

    do {
      compressQuality -= 10;

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
  }) async {
    try {
      print('ResultState.loading, upload, upload_image_story_provider');

      _state = ResultState.loading;
      notifyListeners();
      final uploadResponse = await apiService.uploadStory(
        photoBytes: photoBytes,
        fileName: fileName,
        description: description,
      );

      if (!uploadResponse.error) {
        _state = ResultState.hasData;
        _message = uploadResponse.message;
        notifyListeners();
        print('ResultState.hasdata, upload, upload_image_story_provider');
      }

      /// if no internet connection, _state = ResultState.error
    } on SocketException {
      _state = ResultState.error;
      _message = StringHelper.noInternetConnection;
      notifyListeners();
      print('ResultState.error: $_message');

      /// if other error show up, _state = ResultState.error
    } catch (e, stacktrace) {
      _state = ResultState.error;
      _message = e.toString();
      notifyListeners();
      print('ResultState.error: $_message');
      print(stacktrace);
    }
  }
}
