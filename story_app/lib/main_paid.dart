import 'dart:io';

import 'package:device_preview_screenshot/device_preview_screenshot.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'package:story_app/common/url_strategy.dart';
import 'package:story_app/data/string/string_data.dart';
import 'package:story_app/flavor_config.dart';
import 'package:story_app/main.dart';

void main () async {
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

  if (!kIsWeb) {
    final directory = await getExternalStorageDirectory();

    runApp(
      DevicePreview(
        enabled: true,
        tools: [
          ...DevicePreview.defaultTools,
          DevicePreviewScreenshot(
            multipleScreenshots: true,
            onScreenshot: screenshotAsFiles(directory!),
          ),
        ],
        builder: (_) => const MyApp(),
      ),
    );
  } else {
    runApp(const MyApp());
  }
}