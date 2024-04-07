import 'package:flutter/material.dart';
import 'package:story_app/common/assets/color_scheme/theme.dart';
import 'package:story_app/utils/result_state_helper.dart';

/// Dikarenakan sebagian variable dari Theme.of(context).colorScheme
/// tidak sepenuhnya mendukung konsep Material Design 3 terkini,
/// maka inisiatif membuat provider khusus untuk
/// menanganinya.
class MaterialThemeProvider extends ChangeNotifier {
  MaterialScheme _currentSelected;
  ThemeMode _themeMode;
  final MaterialScheme _light;
  final MaterialScheme _dark;

  ResultState _state = ResultState.notStarted;

  MaterialThemeProvider({
    required MaterialScheme currentSelected,
    required ThemeMode themeMode,
    required MaterialScheme light,
    required MaterialScheme dark,
  })  : _currentSelected = currentSelected,
        _themeMode = themeMode,
        _dark = dark,
        _light = light;

  MaterialScheme get currentSelected => _currentSelected;

  ThemeMode get themeMode => _themeMode;

  ResultState get state => _state;

  MaterialScheme get dark => _dark;

  MaterialScheme get light => _light;

  void setCurrentSelectedToLight() {
    _state = ResultState.loading;
    notifyListeners();

    _currentSelected = _light;
    _themeMode = ThemeMode.light;
    _state = ResultState.hasData;
    notifyListeners();
  }

  void setCurrentSelectedToDark() {
    _state = ResultState.loading;
    notifyListeners();

    _currentSelected = _dark;
    _themeMode = ThemeMode.dark;
    _state = ResultState.hasData;
    notifyListeners();
  }
}
