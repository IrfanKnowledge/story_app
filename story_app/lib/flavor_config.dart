enum FlavorType {
  free,
  paid,
}

class FlavorValues {
  final bool isPaidVersion;

  const FlavorValues({
    this.isPaidVersion = false,
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
