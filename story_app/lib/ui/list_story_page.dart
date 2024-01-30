import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/main.dart';
import 'package:story_app/provider/list_story_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/ui/add_story_page.dart';
import 'package:story_app/ui/detail_story_page.dart';
import 'package:story_app/ui/login_page.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/widget/card_story_widget.dart';
import 'package:story_app/widget/center_error.dart';
import 'package:story_app/widget/center_loading.dart';

class ListStoryPage extends StatefulWidget {
  static const path = '/stories';

  const ListStoryPage({super.key});

  @override
  State<ListStoryPage> createState() => _ListStoryPageState();
}

class _ListStoryPageState extends State<ListStoryPage> {
  late final String _token;

  @override
  void initState() {
    final providerPref = context.read<PreferencesProvider>();
    print(' initState(), token: ${ providerPref.token}');
    _token = providerPref.token;
    super.initState();
  }

  Widget _buildMultiProvider({
    required Widget Function(BuildContext context, Widget? child) builder,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return ListStoryProvider(
              apiService: ApiService(),
              token: _token,
            );
          },
        ),
      ],
      builder: builder,
    );
  }

  Scaffold _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildGetStories(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      title: const Text('Story'),
      actions: [
        IconButton(
          onPressed: () {
            kIsWeb
                ? context.go(AddStoryPage.path)
                : context
                    .push(
                      AddStoryPage.path,
                    )
                    .then(
                      (_) => _refreshPage(context),
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
            var provider = context.read<PreferencesProvider>();
            provider.setLoginStatus(false);
            provider.removeToken();

            context.go(LoginPage.path);
            // myRoutingConfig.value = routingConfigBeforeLogin;
          },
          icon: const Icon(Icons.logout),
        ),
        const SizedBox(width: 10),
      ],
    );
  }

  void _refreshPage(BuildContext context) {
    final listStoryProv = context.read<ListStoryProvider>();
    listStoryProv.fetchAllStories(token: _token);
  }

  Widget _buildGetStories(BuildContext context) {
    return Consumer<ListStoryProvider>(
      builder: (context, provListStory, _) {
        print('provListStory.state: ${provListStory.state}');
        if (provListStory.state == ResultState.loading) {
          return const CenterLoading();
        } else if (provListStory.state == ResultState.hasData) {
          return _buildContainer(context);
        } else if (provListStory.state == ResultState.noData) {
          return CenterError(description: provListStory.message);
        } else if (provListStory.state == ResultState.error) {
          return CenterError(description: provListStory.message);
        } else {
          return CenterError(description: provListStory.message);
        }
      },
    );
  }

  Container _buildContainer(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
      child: _buildListView(context),
    );
  }

  Widget _buildListView(BuildContext context) {
    final providerListStory = context.read<ListStoryProvider>();
    final listStory = providerListStory.listStoryWrap.listStory;

    return ListView.builder(
      itemCount: listStory!.length,
      itemBuilder: (context, index) {
        final item = listStory[index];
        void onTap() {
          kIsWeb
              ? context.go('${DetailStoryPage.path}${item.id}')
              : context
                  .push(
                    '${DetailStoryPage.path}${item.id}',
                  )
                  .then(
                    (_) => _refreshPage(context),
                  );
        }

        return CardStoryWidget(
          photo: item.photoUrl,
          name: item.name,
          description: item.description,
          onTap: onTap,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMultiProvider(
      builder: (context, _) => _buildScaffold(context),
    );
  }
}
