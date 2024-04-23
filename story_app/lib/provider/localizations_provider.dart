import 'package:flutter/material.dart';

class LocalizationsProvider extends ChangeNotifier {
  Locale _locale;
  bool isLocaleSystem;

  LocalizationsProvider({
    required Locale locale,
    required this.isLocaleSystem,
  }) : _locale = locale;

  Locale get locale => _locale;

  set locale(Locale value) {
    _locale = value;
    notifyListeners();
  }
}
