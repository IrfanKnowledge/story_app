import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:story_app/common/url_strategy.dart';
import 'package:story_app/data/string/string_data.dart';
import 'package:story_app/flavor_config.dart';
import 'package:story_app/main.dart';

void main () {
  WidgetsFlutterBinding.ensureInitialized();

  usePathUrlStrategy();

  HttpOverrides.global = MyHttpOverrides();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  LicenseRegistry.addLicense(() async* {
    final license = await rootBundle
        .loadString('assets/license/font/OFL_roboto_flex.txt');
    yield LicenseEntryWithLineBreaks(['google_fonts'], license);
  });

  FlavorConfig(
    flavorType: FlavorType.paid,
    flavorValues: const FlavorValues(
      isPaidVersion: true,
      titleApp: StringData.titleApp,
    ),
  );

  runApp(const MyApp());
}