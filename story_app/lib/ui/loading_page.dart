import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/preferences/preferences_helper.dart';
import 'package:story_app/main.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/widget/center_loading.dart';

class LoadingPage extends StatelessWidget {
  const LoadingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return PreferencesProvider(
          preferencesHelper: PreferencesHelper(
            sharedPreferences: SharedPreferences.getInstance(),
          ),
        );
      },
      child: Scaffold(
        body: Consumer<PreferencesProvider>(
          builder: (context, provider, child) {
            if (provider.stateToken == ResultState.loading) {
              return const CenterLoading();
            }
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (outerMatchedLocation.isEmpty) {
                outerMatchedLocation = '/';
              }
              String location = outerMatchedLocation;
              outerMatchedLocation = '/';
              outerRedirectExecuted = false;
              context.go(location);
            });
            return const CenterLoading();
          },
        ),
      ),
    );
  }
}
