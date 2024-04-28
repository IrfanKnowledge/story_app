import 'package:flutter/cupertino.dart';
import 'package:story_app/common/url_strategy.dart';
import 'package:story_app/flavor_config.dart';
import 'package:story_app/main.dart';

void main () {
  usePathUrlStrategy();

  FlavorConfig(
    flavorType: FlavorType.paid,
    flavorValues: const FlavorValues(
      isPaidVersion: true,
    ),
  );

  runApp(const MyApp());
}