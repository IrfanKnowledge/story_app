import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/provider/list_story_provider.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/ui/detail_story_page.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/widget/card_story_widget.dart';
import 'package:story_app/widget/center_error.dart';
import 'package:story_app/widget/center_loading.dart';

class ListStoryPage extends StatefulWidget {
  static const String goRoutePath = '/';

  const ListStoryPage({super.key});

  @override
  State<ListStoryPage> createState() => _ListStoryPageState();
}

class _ListStoryPageState extends State<ListStoryPage> {

  AppLocalizations? _appLocalizations;

  @override
  void initState() {
    final providerPref = context.read<PreferencesProvider>();
    final stateToken = providerPref.stateToken;
    final token = stateToken.maybeWhen(
      loaded: (data) => data,
      orElse: () => '',
    );

    final providerListStory = context.read<ListStoryProvider>();

    print('list_story_page, initState()');

    Future.microtask(() async {
      providerListStory.fetchAllStories(token: token);
    });

    super.initState();
  }

  Scaffold _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildGetStories(context),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final colorSchemeCustom =
        context.watch<MaterialThemeProvider>().currentSelected;

    return AppBar(
      title: Text(_appLocalizations!.titleApp),
      backgroundColor: colorSchemeCustom.surfaceContainer,
      surfaceTintColor: colorSchemeCustom.surfaceContainer,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _refreshPage(BuildContext context) {
    final listStoryProv = context.read<ListStoryProvider>();

    final providerPref = context.read<PreferencesProvider>();
    final stateToken = providerPref.stateToken;
    final token = stateToken.maybeWhen(
      loaded: (data) => data,
      orElse: () => '',
    );

    listStoryProv.fetchAllStories(token: token);
  }

  Widget _buildIsLogin() {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, _) {
        final stateIsLogin = provider.stateIsLogin;
        final stateToken = provider.stateToken;
        if (stateIsLogin == ResultState.loading ||
            stateToken == ResultState.loading) {
          return const CenterLoading();
        }

        return _buildGetStories(context);
      },
    );
  }

  Widget _buildGetStories(BuildContext context) {
    return Consumer<ListStoryProvider>(
      builder: (context, provListStory, _) {
        print('provListStory.state: ${provListStory.state}');
        if (provListStory.state == ResultState.notStarted) {
          // WidgetsBinding.instance.addPostFrameCallback((_) {
          //   final providerPref = context.read<PreferencesProvider>();
          //   provListStory.fetchAllStories(token: providerPref.token);
          // });
          return const CenterLoading();
        } else if (provListStory.state == ResultState.loading) {
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
      padding: const EdgeInsets.symmetric(horizontal: 16),
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
              ? context.go(
                  '/${DetailStoryPage.goRoutePath.replaceAll(':id', item.id)}')
              : context.push(
                  '/${DetailStoryPage.goRoutePath.replaceAll(':id', item.id)}',
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
    _appLocalizations = AppLocalizations.of(context);
    return _buildScaffold(context);
  }
}
