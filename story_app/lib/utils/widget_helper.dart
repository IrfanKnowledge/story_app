import 'package:flutter/material.dart';
import 'package:story_app/common/color_scheme/theme.dart';
import 'package:story_app/widget/loading_custom.dart';

class WidgetHelper {
  static Widget loadingCustom({
    required AnimationController loadingController,
    required Animation<double> loadingAnimation,
    required MaterialScheme colorSchemeCustom,
    required double sizeWidthAndHeight,
  }) {
    return LoadingCustom(
      loadingController: loadingController,
      loadingAnimation: loadingAnimation,
      sizeWidthAndHeight: sizeWidthAndHeight,
      colorCircle: colorSchemeCustom.primaryContainer,
      colorCircleOuter: colorSchemeCustom.secondary,
      colorArc: colorSchemeCustom.tertiary,
    );
  }
}
