import 'package:story_app/data/string/string_data.dart';

enum FlavorType {
  free,
  paid,
}

class FlavorValues {
  final bool isPaidVersion;
  final String titleApp;

  const FlavorValues({
    this.isPaidVersion = false,
    this.titleApp = StringData.titleAppFree,
  });
}

class FlavorConfig {
  final FlavorType flavorType;
  final FlavorValues flavorValues;

  static FlavorConfig? _instance;

  FlavorConfig({
    this.flavorType = FlavorType.free,
    this.flavorValues = const FlavorValues(),
  }) {
    _instance = this;
  }

  static FlavorConfig get instance => _instance ?? FlavorConfig();
}
