import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:story_app/common/custom_painter/loading_custom_painter.dart';

class LoadingCustom extends StatelessWidget {
  final AnimationController _loadingController;
  final Animation<double> _loadingAnimation;
  final double _sizeWidthAndHeight;
  final Color _colorCircle;
  final Color _colorCircleOuter;
  final Color _colorArc;

  const LoadingCustom({
    super.key,
    required AnimationController loadingController,
    required Animation<double> loadingAnimation,
    required double sizeWidthAndHeight,
    required Color colorCircle,
    required Color colorCircleOuter,
    required Color colorArc,
  })  : _sizeWidthAndHeight = sizeWidthAndHeight,
        _loadingAnimation = loadingAnimation,
        _loadingController = loadingController,
        _colorCircle = colorCircle,
        _colorCircleOuter = colorCircleOuter,
        _colorArc = colorArc;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _loadingAnimation,
        builder: (context, child) {
          return Transform.rotate(
            angle: _loadingController.status == AnimationStatus.forward
                ? (math.pi * 2) * _loadingController.value
                : -(math.pi * 2) * _loadingController.value,
            child: CustomPaint(
              foregroundPainter: LoadingCustomPainter(
                colorCircle: _colorCircle,
                colorCircleOuter: _colorCircleOuter,
                colorArc: _colorArc,
                radiusCircleOuterPlus: _loadingAnimation.value,
              ),
              child: SizedBox(
                width: _sizeWidthAndHeight,
                height: _sizeWidthAndHeight,
              ),
            ),
          );
        },
      ),
    );
  }
}
