import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/preferences/preferences_helper.dart';
import 'package:story_app/provider/list_story_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/ui/add_story_page.dart';
import 'package:story_app/ui/login_page.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/widget/card_story_widget.dart';

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
      body: _getTokenFromPreferences(),
    );
  }

  Widget _getTokenFromPreferences() {
    return Consumer<PreferencesProvider>(
      builder: (context, providerPref, _) {

        /// if state is loading (fetch isLogin from SharedPreference),
        /// show loading
        if (providerPref.stateIsLogin == ResultState.loading) {
          return _buildLoading();

          /// if isLogin is true
        } else if (providerPref.isLogin) {

          /// if state is loading (fetch token from SharedPreference),
          /// show loading
          if (providerPref.stateToken == ResultState.loading) {
            return _buildLoading();

            /// if token is not empty, show the data
          } else if (providerPref.stateToken == ResultState.hasData) {
            return _text(providerPref);

            /// if token is empty, show error message
          } else {
            return _buildError(providerPref.messageToken);
          }

          /// if isLogin is not true, show error message
        } else {
          return _buildError(providerPref.messsageIsLogin);
        }
      },
    );
  }

  Widget _getStories() {
    return Consumer<ListStoryProvider>(
      builder: (context, provListStory, _) {
        if (provListStory.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          print('success');
          return Center(
            child: Text(provListStory.listStoryWrap.message),
          );
        }
      },
    );
  }

  Widget _buildLoading() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  Widget _buildError(String description) {
    return Center(
      child: Text(description),
    );
  }

  Text _text(PreferencesProvider providerPref) => Text(
      'Login Status = ${providerPref.isLogin}, token = ${providerPref.token}');

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
            );
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

  Container _buildContainer() {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: const CardStoryWidget(),
    );
  }
}
