import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddStoryProvider extends ChangeNotifier {
  String? _imagePath;

  XFile? _imageFile;

  String? get imagePath => _imagePath;

  set imagePath(String? value) {
    _imagePath = value;
    notifyListeners();
  }

  XFile? get imageFile => _imageFile;

  set imageFile(XFile? value) {
    _imageFile = value;
    notifyListeners();
  }
}
