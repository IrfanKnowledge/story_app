import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/main.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/widget/center_loading.dart';

///
/// Halaman ini berfungsi apabila flutter project ini digunakan untuk build web.
/// Sebab penerapan penyimpanan data token login pada Shared Preference
/// melalui provider, tidak berfungsi dengan baik pada website. Setiap kali
/// teripcu refresh page, maka nilai pada provider menjadi default sehingga
/// perlu mengambil ulang data token login pada Shared Preference.
///
class LoadingPage extends StatelessWidget {
  static const String goRoutePath = 'loading';

  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<PreferencesProvider>(
        builder: (context, provider, _) {
          final stateToken = provider.stateToken;

          Widget? result = stateToken.maybeWhen(
            loading: () => const CenterLoading(),
            orElse: () => null,
          );

          if (result != null) {
            return result;
          }

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
