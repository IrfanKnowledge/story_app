import 'package:flutter/material.dart';
import 'package:story_app/common/color_scheme/theme.dart';
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
    required BuildContext context,
    required Brightness brightness,
    required MaterialScheme currentSelected,
    required ThemeMode themeMode,
    required MaterialScheme light,
    required MaterialScheme dark,
  })
      : _currentSelected = currentSelected,
        _themeMode = themeMode,
        _dark = dark,
        _light = light {
    if (themeMode == ThemeMode.system) {
      if (brightness == Brightness.light) {
        _currentSelected = _light;
      } else {
        _currentSelected = _dark;
      }
    }
  }

  MaterialScheme get currentSelected => _currentSelected;

  ThemeMode get themeMode => _themeMode;

  ResultState get state => _state;

  MaterialScheme get dark => _dark;

  MaterialScheme get light => _light;

  void setCurrentSelected(BuildContext context, ThemeMode vThemeMode) {
    _state = ResultState.loading;
    notifyListeners();

    _themeMode = vThemeMode;

    switch (_themeMode) {
      case ThemeMode.system:
        final brightness = MediaQuery
            .of(context)
            .platformBrightness;

        if (brightness == Brightness.light) {
          _currentSelected = _light;
        } else {
          _currentSelected = _dark;
        }
      case ThemeMode.light:
        _currentSelected = _light;
      case ThemeMode.dark:
        _currentSelected = _dark;
    }

    _state = ResultState.hasData;
    notifyListeners();
  }
}
