import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/main.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/widget/center_loading.dart';

///
/// Fungsi utamanya adalah apabila flutter project ini digunakan untuk build web.
/// Sebab penerapan penyimpanan data token login disimpan pada Shared Preference
/// melalui provider. Penerapan provider pada web, tidak berfungsi dengan baik.
/// Setiap kali teripcu refresh page, maka nilai pada provider menjadi default.
/// Sehingga perlu mengambil ulang data token login pada Shared Preference.
///
/// Fungsi lainnya adalah bisa dijadikan tempat untuk memuat pengaturan lainnya.
/// Contoh: Theme, Localizations, dll..
///
class LoadingPage extends StatelessWidget {
  static const String goRoutePath = 'loading';

  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    print('LoadingPage, build, first');
    final providerTheme = context.read<MaterialThemeProvider>();

    return Scaffold(
      body: Consumer<PreferencesProvider>(
        builder: (context, provider, _) {
          print('loaidng_page, first');
          final stateToken = provider.stateToken;
          final stateTheme = provider.stateThemeMode;

          Widget? result = stateToken.maybeWhen(
            loading: () => const CenterLoading(),
            orElse: () => null,
          );

          if (result != null) return result;

          result = stateTheme.maybeWhen(
            loading: () => const CenterLoading(),
            loaded: (data) {
              if (data != null) {
                print('data: $data');
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  providerTheme.setCurrentSelected(context, data);
                });
              }
              return null;
            },
            orElse: () => null,
          );

          if (result != null) return result;

          print('stateTheme: $stateTheme');


          WidgetsBinding.instance.addPostFrameCallback((_) {
            String location = MyApp.outerMatchedLocation;
            MyApp.outerMatchedLocation = '/';
            MyApp.outerRedirectExecuted = false;
            context.go(location);
          });

          result = const CenterLoading();

          return result;
        },
      ),
    );
  }
}
