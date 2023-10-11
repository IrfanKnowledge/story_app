import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddStoryProvider extends ChangeNotifier {
  String? _imagePath;

  XFile? _imageFile;

  String description = '';

  String? get imagePath => _imagePath;

  XFile? get imageFile => _imageFile;

  void setImageFile(XFile? value) {
    _imageFile = value;
    notifyListeners();
  }

  void setImagePath(String value) {
    _imagePath = value;
    notifyListeners();
  }
}
