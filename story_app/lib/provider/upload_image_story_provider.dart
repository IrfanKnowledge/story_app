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
      : _stateUpload = ResultState.notStarted;

  String _messageUpload = '';

  ResultState _stateUpload;

  ResultState get stateUpload => _stateUpload;

  String get messageUpload => _messageUpload;

  Future<List<int>> compressImage(List<int> bytes) async {
    const int maxBytes = 1000000;
    final int imageLength = bytes.length;

    // jika imageLength lebih kecil dari 1 ribu bytes (1 MB),
    // maka tidak perlu dilakukan compress
    if (imageLength < maxBytes) return bytes;

    // img.decodeImage will using UI thread,
    // so highly recommend don't use this
    final img.Image image = img.decodeImage(bytes as Uint8List)!;
    int compressQuality = 90;
    int length = imageLength;
    List<int> newByte = [];

    do {
      compressQuality -= 10;

      // img.encodeJpg will using UI thread,
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
    String token = '',
  }) async {
    try {
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
      }

      // if no internet connection, _state = ResultState.error
    } on SocketException {
      _stateUpload = ResultState.error;
      _messageUpload = StringHelper.noInternetConnection;
      notifyListeners();

      // if other error show up, _state = ResultState.error
    } catch (e) {
      _stateUpload = ResultState.error;
      _messageUpload = e.toString();
      notifyListeners();
    }
  }
}
