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
      body: _getToken(),
    );
  }

  Widget _getToken() {
    return Consumer<PreferencesProvider>(
      builder: (context, providerPref, _) {
        return _text(providerPref);
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
