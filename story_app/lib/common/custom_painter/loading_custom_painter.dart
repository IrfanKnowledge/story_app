import 'dart:math' as math;

import 'package:flutter/material.dart';

class LoadingCustomPainter extends CustomPainter {
  final double _radiusCircleOuterPlus;

  double get radiusCircleOuterPlus => _radiusCircleOuterPlus;

  final Color _colorCircle;
  final Color _colorCircleOuter;
  final Color _colorArc;

  LoadingCustomPainter({
    required double radiusCircleOuterPlus,
    required Color colorCircle,
    required Color colorCircleOuter,
    required Color colorArc,
  })  : _radiusCircleOuterPlus = radiusCircleOuterPlus,
        _colorCircle = colorCircle,
        _colorCircleOuter = colorCircleOuter,
        _colorArc = colorArc;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    Paint paintCircle = Paint()
      ..color = _colorCircle
      ..style = PaintingStyle.fill;

    canvas.drawCircle(
      center,
      size.height,
      paintCircle,
    );

    Paint paintCircleOuter = Paint()
      ..color = _colorCircleOuter
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5;

    canvas.drawCircle(
      center,
      size.width + _radiusCircleOuterPlus,
      paintCircleOuter,
    );

    _drawArc(
      canvas: canvas,
      size: size,
      center: center,
      radiusPlus: _radiusCircleOuterPlus * 2,
      color: _colorArc,
      strokeWidth: 10.0,
      startAngle: 0,
      sweepAngle: math.pi / 2,
    );
  }

  @override
  bool shouldRepaint(covariant LoadingCustomPainter oldDelegate) {
    return _radiusCircleOuterPlus != oldDelegate.radiusCircleOuterPlus;
  }

  void _drawArc({
    required Canvas canvas,
    required Size size,
    required Offset center,
    required double radiusPlus,
    required Color color,
    required double strokeWidth,
    required double startAngle,
    required double sweepAngle,
  }) {
    Paint paintArc = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    Rect rect = Rect.fromCenter(
      center: center,
      width: size.width * 2 + radiusPlus,
      height: size.width * 2 + radiusPlus,
    );

    canvas.drawArc(
      rect,
      startAngle,
      sweepAngle,
      false,
      paintArc,
    );
  }
}
