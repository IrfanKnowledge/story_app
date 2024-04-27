import 'package:flutter/material.dart';

class LocalizationsProvider extends ChangeNotifier {
  Locale _locale;

  ///
  /// Dapat digunakan pada [MaterialApp] sebagai acuan apabila
  /// locale memiliki languangeCode = 'system', maka biarkan [MaterialApp]
  /// mengikuti sistem dengan cara memberi nilai null pada [MaterialApp.locale]
  ///
  static const localeSystem = Locale('system');

  LocalizationsProvider({
    required Locale locale,
  }) : _locale = locale;

  Locale get locale => _locale;

  set locale(Locale value) {
    _locale = value;
    notifyListeners();
  }
}
