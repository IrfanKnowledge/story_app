import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/model/list_story_model.dart';
import 'package:story_app/data/string/string_data.dart';
import 'package:story_app/provider/list_story_provider.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/ui/detail_story_page.dart';
import 'package:story_app/utils/string_helper.dart';
import 'package:story_app/widget/card_story.dart';
import 'package:story_app/widget/center_error.dart';
import 'package:story_app/widget/center_loading.dart';

class ListStoryPage extends StatefulWidget {
  static const String goRoutePath = '/';
  static bool isShowDialogTrue = true;

  const ListStoryPage({super.key});

  @override
  State<ListStoryPage> createState() => _ListStoryPageState();
}

class _ListStoryPageState extends State<ListStoryPage> {
  bool _isUseSliverStyle = true;

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

    ListStoryPage.isShowDialogTrue = true;

    super.initState();
  }

  Scaffold _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildGetStories(
        builder: (context) {
          return _buildContainer(context);
        },
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final colorSchemeCustom =
        context.watch<MaterialThemeProvider>().currentSelected;

    return AppBar(
      title: const Text(StringData.titleApp),
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

  Scaffold _buildScaffoldSliver(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _buildNestedScrollView(),
      ),
    );
  }

  NestedScrollView _buildNestedScrollView() {
    return NestedScrollView(
      floatHeaderSlivers: true,
      headerSliverBuilder: (context, innerBoxIsScrolled) {
        return [
          _buildSliverAppBar(
            context: context,
            innerBoxIsScrolled: innerBoxIsScrolled,
          ),
        ];
      },
      body: _buildGetStories(
        builder: (context) {
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: _buildContainer(context),
              ),
            ],
          );
        },
      ),
    );
  }

  SliverAppBar _buildSliverAppBar({
    required BuildContext context,
    required bool innerBoxIsScrolled,
  }) {
    final providerMaterial = context.watch<MaterialThemeProvider>();
    final colorSchemeCustom = providerMaterial.currentSelected;
    final textTheme = Theme.of(context).textTheme;

    return SliverAppBar(
      pinned: false,
      snap: true,
      floating: true,
      forceElevated: innerBoxIsScrolled,
      backgroundColor: colorSchemeCustom.surfaceContainer,
      surfaceTintColor: colorSchemeCustom.surfaceContainer,
      title: Text(StringData.titleApp, style: textTheme.titleLarge),
    );
  }

  Widget _buildGetStories({
    required Widget Function(BuildContext context) builder,
  }) {
    return Consumer<ListStoryProvider>(
      builder: (context, provider, _) {
        final state = provider.stateListStory;

        Widget result = state.when(
          initial: () => const CenterLoading(),
          loading: () => const CenterLoading(),
          loaded: (data) {
            if (data.listStory.isEmpty) {
              return const CenterError(description: StringHelper.emptyData);
            }
            return builder(context);
          },
          error: (message) => CenterError(description: message),
        );

        return result;
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
    final stateListStory = providerListStory.stateListStory;

    // Tidak akan kosong sebab sudah divalidasi
    final List<ListStory> listStory = stateListStory.maybeWhen(
      loaded: (data) => data.listStory,
      orElse: () => [],
    );

    return ListView.builder(
      physics: _isUseSliverStyle
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
      shrinkWrap: _isUseSliverStyle ? true : false,
      itemBuilder: (context, index) {
        final item = listStory[index];
        void onTap() {
          context.go(
            '/${DetailStoryPage.goRoutePath.replaceAll(':id', item.id)}',
          );
        }

        return CardStory(
          photo: item.photoUrl,
          name: item.name,
          description: item.description,
          onTap: onTap,
        );
      },
      itemCount: listStory.length,
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

  @override
  Widget build(BuildContext context) {
    return _isUseSliverStyle
        ? _buildScaffoldSliver(context)
        : _buildScaffold(context);
  }
}
