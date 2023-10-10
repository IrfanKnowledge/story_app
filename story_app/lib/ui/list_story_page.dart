import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/list_story_model.dart';
import 'package:story_app/data/preferences/preferences_helper.dart';
import 'package:story_app/provider/list_story_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/ui/add_story_page.dart';
import 'package:story_app/ui/login_page.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/widget/card_story_widget.dart';
import 'package:story_app/widget/center_error.dart';
import 'package:story_app/widget/center_loading.dart';

class ListStoryPage extends StatelessWidget {
  const ListStoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _buildMultiProvider();
  }

  Widget _buildMultiProvider() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => ListStoryProvider(apiService: ApiService()),
        ),
      ],
      builder: (context, _) => _buildScaffold(context),
    );
  }

  Scaffold _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _getToken(),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Story'),
      actions: [
        IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddStoryPage(),
              ),
            ).then((_) {
              final listStoryProv = context.read<ListStoryProvider>();
              final token = context.read<PreferencesProvider>().token;
              listStoryProv.fetchAllStories(token: token);
            });
          },
          icon: const Icon(Icons.add),
        ),
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.settings),
        ),
        IconButton(
          onPressed: () {
            var providerPref =
                Provider.of<PreferencesProvider>(context, listen: false);
            providerPref.setLoginStatus(false);
            providerPref.removeToken();

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => const LoginPage(),
              ),
            );
          },
          icon: const Icon(Icons.logout),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  /// get token from SharedPreference
  /// used by [_buildScaffold]
  Widget _getToken() {
    return Consumer<PreferencesProvider>(
      builder: (context, provPref, _) {
        print('consumer PreferencesProvider');

        /// if state is loading (fetch isLogin from SharedPreference),
        /// show loading
        if (provPref.stateIsLogin == ResultState.loading) {
          return const CenterLoading();

          /// if isLogin is true
        } else if (provPref.isLogin) {
          /// if state is loading (fetch token from SharedPreference),
          /// show loading
          if (provPref.stateToken == ResultState.loading) {
            return const CenterLoading();

            /// if token is not empty, use the token to get stories from API
          } else if (provPref.stateToken == ResultState.hasData) {
            return _getStories(provPref.token);

            /// if token is empty, show error message
          } else {
            return CenterError(description: provPref.messageToken);
          }

          /// if isLogin is not true, show error message
        } else {
          return CenterError(description: provPref.messsageIsLogin);
        }
      },
    );
  }

  /// get stories, required token.
  /// used by [_getToken]
  Widget _getStories(String token) {
    return Consumer<ListStoryProvider>(
      builder: (context, provListStory, _) {
        print('consumer ListStoryProvider');

        /// if state is not started,
        /// then fetch all stories from API,
        if (provListStory.state == ResultState.notStarted) {
          /// fetch all stories from API, required token.
          /// using FutureBuilder to delay fetching process,
          /// it's for avoiding error caused by calling setState() (notifyListeners()) and building process at the same time
          return FutureBuilder(
            future: _fetchAllStories(
              provListStory: provListStory,
              token: token,
            ),
            builder: (_, __) => const CenterLoading(),
          );

          /// if state is loading (fetch all stories from API),
          /// show loading
        } else if (provListStory.state == ResultState.loading) {
          return const CenterLoading();

          /// if state is has data, show the data
        } else if (provListStory.state == ResultState.hasData) {
          // return Center(
          //   child: Text(
          //     '${provListStory.listStoryWrap.message}, ${provListStory.listStoryWrap.listStory}',
          //   ),
          // );
          return _buildContainer(provListStory.listStoryWrap.listStory);

          /// if state is no data, show error message
        } else if (provListStory.state == ResultState.noData) {
          return CenterError(description: provListStory.message);

          /// if state is error, show error message
        } else if (provListStory.state == ResultState.error) {
          return CenterError(description: provListStory.message);

          /// if state is other else, show error message
        } else {
          return CenterError(description: provListStory.message);
        }
      },
    );
  }

  /// fetchAllStories from API, with delay process.
  /// used by [_getStories]
  Future<String> _fetchAllStories({
    required ListStoryProvider provListStory,
    required String token,
  }) async {
    await Future.delayed(
      const Duration(seconds: 1),
      () {
        provListStory.fetchAllStories(token: token);
      },
    );

    return 'loading...';
  }

  Container _buildContainer(List<ListStory>? listStory) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: _buildListView(listStory),
    );
  }

  Widget _buildListView(List<ListStory>? listStory) {
    return ListView.builder(
      itemCount: listStory!.length,
      itemBuilder: (context, index) {
        final item = listStory[index];

        return CardStoryWidget(
          photo: item.photoUrl,
          name: item.name,
          description: item.description,
        );
      },
    );
  }
}
