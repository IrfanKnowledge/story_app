import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:story_app/common/custom_painter/loading_custom_painter.dart';
import 'package:story_app/common/url_strategy.dart';

void main() {
  usePathUrlStrategy();

  runApp(const LoadingCustomPage());
}

class LoadingCustomPage extends StatefulWidget {
  const LoadingCustomPage({super.key});

  @override
  State<LoadingCustomPage> createState() => _LoadingCustomPageState();
}

class _LoadingCustomPageState extends State<LoadingCustomPage>
    with SingleTickerProviderStateMixin {
  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;

  @override
  void initState() {
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 15.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOutExpo,
    ));

    _loadingController.repeat(reverse: true);

    super.initState();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Loading Custom',
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Loading Custom'),
        ),
        body: Center(
          child: AnimatedBuilder(
            animation: _loadingAnimation,
            builder: (context, child) {
              return Transform.rotate(
                angle: _loadingController.status == AnimationStatus.forward
                    ? (math.pi * 2) * _loadingController.value
                    : -(math.pi * 2) * _loadingController.value,
                child: CustomPaint(
                  foregroundPainter: LoadingCustomPainter(
                    radiusCircleOuterPlus: _loadingAnimation.value,
                    colorCircle: Colors.greenAccent,
                    colorCircleOuter: Colors.blue,
                    colorArc: Colors.red,
                  ),
                  child: const SizedBox(
                    width: 50,
                    height: 50,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
