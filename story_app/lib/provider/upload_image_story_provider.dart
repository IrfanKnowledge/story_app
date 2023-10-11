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
      : _stateUpload = ResultState.notStarted,
        _stateCompressImage = ResultState.notStarted;

  late List<int> _bytesImage;

  String _messageCompressImage = '';
  String _messageUpload = '';

  ResultState _stateCompressImage;
  ResultState _stateUpload;

  List<int> get bytesImage => _bytesImage;

  ResultState get stateCompressImage => _stateCompressImage;

  ResultState get stateUpload => _stateUpload;

  String get messageCompressImage => _messageCompressImage;

  String get messageUpload => _messageUpload;

  void compressImage(List<int> bytes) async {
    _stateCompressImage = ResultState.loading;
    notifyListeners();

    print('_stateCompressImage, $_stateCompressImage');

    int maxBytes = 1000000;
    int imageLength = bytes.length;

    print('$imageLength, $maxBytes');
    print(imageLength < maxBytes);

    /// jika imageLength lebih kecil dari 1 ribu bytes (1 MB),
    /// maka tidak perlu dilakukan compress
    if (imageLength < maxBytes) {
      _stateCompressImage = ResultState.hasData;
      _bytesImage = bytes;
      notifyListeners();
    } else {
      print('before img.decodeImage');

      final img.Image image = img.decodeImage(bytes as Uint8List)!;
      int compressQuality = 90;
      int length = imageLength;
      List<int> newByte = [];

      print('after img.decodeImage');

      do {
        compressQuality -= 10;
        print('compressQuality: $compressQuality');

        newByte = img.encodeJpg(
          image,
          quality: compressQuality,
        );

        length = newByte.length;
      } while (length > maxBytes);

      _stateCompressImage = ResultState.hasData;
      _bytesImage = newByte;

      // reset _satateUpload
      _stateUpload = ResultState.notStarted;
      notifyListeners();
    }
  }

  void upload({
    required List<int> photoBytes,
    required String fileName,
    required String description,
    String token = '',
  }) async {
    try {
      print('ResultState.loading, upload, upload_image_story_provider');

      _stateUpload = ResultState.loading;
      notifyListeners();
      final uploadResponse = await apiService.uploadStory(
        photoBytes: photoBytes,
        fileName: fileName,
        description: description,
        token: token,
      );

      if (!uploadResponse.error) {
        _stateUpload = ResultState.hasData;
        _messageUpload = uploadResponse.message;
        notifyListeners();
        print('ResultState.hasdata, upload, upload_image_story_provider');
      }

      /// if no internet connection, _state = ResultState.error
    } on SocketException {
      _stateUpload = ResultState.error;
      _messageUpload = StringHelper.noInternetConnection;
      notifyListeners();
      print('ResultState.error: $_messageUpload');

      /// if other error show up, _state = ResultState.error
    } catch (e, stacktrace) {
      _stateUpload = ResultState.error;
      _messageUpload = e.toString();
      notifyListeners();
      print('ResultState.error: $_messageUpload');
      print(stacktrace);
    }
  }
}
