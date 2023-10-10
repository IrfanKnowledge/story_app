import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/preferences/preferences_helper.dart';
import 'package:story_app/provider/detail_story_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/widget/center_error.dart';
import 'package:story_app/widget/center_loading.dart';

class DetailStoryPage extends StatelessWidget {
  final String id;

  const DetailStoryPage({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Story'),
      ),
      body: _buildMultiProvider(),
    );
  }

  Widget _buildMultiProvider() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return PreferencesProvider(
              preferencesHelper: PreferencesHelper(
                sharedPreferences: SharedPreferences.getInstance(),
              ),
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) {
            return DetailStoryProvider(
              apiService: ApiService(),
            );
          },
        )
      ],
      child: _getToken(),
    );
  }

  Widget _getToken() {
    return Consumer<PreferencesProvider>(
      builder: (context, provPref, _) {
        print('consumer PreferencesProvider');

        // if state is loading (fetch isLogin from SharedPreference),
        // show loading
        if (provPref.stateIsLogin == ResultState.loading) {
          return const CenterLoading();

          // if isLogin is true
        } else if (provPref.isLogin) {
          // if state is loading (fetch token from SharedPreference),
          // show loading
          if (provPref.stateToken == ResultState.loading) {
            return const CenterLoading();

            // if token is not empty, use the token to get story detail from API
          } else if (provPref.stateToken == ResultState.hasData) {
            return _getStoryDetail(
              token: provPref.token,
              id: id,
            );

            // if token is empty, show error message
          } else {
            return CenterError(description: provPref.messageToken);
          }

          // if isLogin is not true, show error message
        } else {
          return CenterError(description: provPref.messsageIsLogin);
        }
      },
    );
  }

  Widget _getStoryDetail({
    required String token,
    required String id,
  }) {
    return Consumer<DetailStoryProvider>(
      builder: (context, provider, _) {
        print('consumer DetailStoryProvider');

        // if state is not started,
        // then fetch story detail from API,
        if (provider.state == ResultState.notStarted) {
          // fetch story detail from API, required token and id.
          // using FutureBuilder to delay fetching process,
          // it's for avoiding error caused by calling setState() (notifyListeners()) and building process at the same time
          return FutureBuilder(
            future: _fetchStoryDetail(
              context: context,
              token: token,
              id: id,
            ),
            builder: (_, __) => const CenterLoading(),
          );

          // if state is loading (fetch story detail from API),
          // show loading
        } else if (provider.state == ResultState.loading) {
          return const CenterLoading();

          // if state is has data, show the data
        } else if (provider.state == ResultState.hasData) {
          return _buildCenterCheckData(provider.detailStoryWrap.story!.id);

          // if state is error, show error message
        } else if (provider.state == ResultState.error) {
          return CenterError(
            description: provider.message,
          );

          // if state is other else, show error message
        } else {
          return CenterError(
            description: provider.message,
          );
        }
      },
    );
  }

  /// fetch story detail from API, with delay process.
  /// used by [_getStoryDetail]
  Future<String> _fetchStoryDetail({
    required BuildContext context,
    required String token,
    required String id,
  }) async {
    await Future.delayed(
      const Duration(
        seconds: 1,
      ),
      () {
        final provider = context.read<DetailStoryProvider>();
        provider.fetchStoryDetail(
          token: token,
          id: id,
        );
      },
    );

    return 'loading...';
  }

  Widget _buildContainer() {
    return SingleChildScrollView(
      child: Container(),
    );
  }

  Widget _buildCenterCheckData(String message) {
    return Center(
      child: Text(
        message,
      ),
    );
  }
}
