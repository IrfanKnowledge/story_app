import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/color_scheme/theme.dart';
import 'package:story_app/data/string/string_data.dart';
import 'package:story_app/flavor_config.dart';
import 'package:story_app/provider/list_story_provider.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/ui/detail_story_page.dart';
import 'package:story_app/utils/widget_helper.dart';
import 'package:story_app/widget/card_story.dart';
import 'package:story_app/widget/scrollable_center_text.dart';

class ListStoryPage extends StatefulWidget {
  static const String goRoutePath = '/';
  static bool isShowDialogTrue = true;

  const ListStoryPage({super.key});

  @override
  State<ListStoryPage> createState() => _ListStoryPageState();
}

class _ListStoryPageState extends State<ListStoryPage>
    with SingleTickerProviderStateMixin {
  final bool _isUseSliverStyle = true;

  late AnimationController _loadingController;
  late Animation<double> _loadingAnimation;

  MaterialScheme? _colorSchemeCustom;
  TextTheme? _textTheme;

  void _initLoadingAnimation() {
    _loadingController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );

    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 15.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOutExpo,
    ));

    _loadingController.repeat(reverse: true);
  }

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
      providerListStory.setAllValueToDefault();
      providerListStory.fetchAllStoriesWithPagination(token: token);
    });

    ListStoryPage.isShowDialogTrue = true;

    _initLoadingAnimation();

    super.initState();
  }

  @override
  void dispose() {
    _loadingController.dispose();
    super.dispose();
  }

  Scaffold _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async => _refreshPage(context),
        child: _buildGetStories(
          context: context,
          builder: (context) {
            return _buildNotificationListener(
              context: context,
              child: _buildContainer(context),
            );
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final titleApp = FlavorConfig.instance.flavorValues.titleApp;

    return AppBar(
      title: Text(
        titleApp,
        style: _textTheme!.titleLarge?.copyWith(
          color: _colorSchemeCustom!.onSurface,
        ),
      ),
      backgroundColor: _colorSchemeCustom!.surfaceContainer,
      surfaceTintColor: _colorSchemeCustom!.surfaceContainer,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _colorSchemeCustom!.outlineVariant,
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
        child: _buildNestedScrollView(context),
      ),
    );
  }

  NestedScrollView _buildNestedScrollView(BuildContext context) {
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
      body: RefreshIndicator(
        onRefresh: () async => _refreshPage(context),
        child: _buildGetStories(
          context: context,
          builder: (context) {
            return _buildNotificationListener(
              context: context,
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                slivers: [
                  SliverToBoxAdapter(
                    child: _buildContainer(context),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  SliverAppBar _buildSliverAppBar({
    required BuildContext context,
    required bool innerBoxIsScrolled,
  }) {
    final titleApp = FlavorConfig.instance.flavorValues.titleApp;

    return SliverAppBar(
      pinned: false,
      snap: true,
      floating: true,
      forceElevated: innerBoxIsScrolled,
      backgroundColor: _colorSchemeCustom!.surfaceContainer,
      surfaceTintColor: _colorSchemeCustom!.surfaceContainer,
      title: Text(
        titleApp,
        style: _textTheme!.titleLarge?.copyWith(
          color: _colorSchemeCustom!.onSurface,
        ),
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: _colorSchemeCustom!.outlineVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }

  NotificationListener<ScrollEndNotification> _buildNotificationListener({
    required BuildContext context,
    required Widget child,
  }) {
    final providerListStory = context.watch<ListStoryProvider>();
    final providerPref = context.read<PreferencesProvider>();

    final int? pageItems = providerListStory.pageItems;
    final token = providerPref.stateToken.maybeWhen(
      loaded: (data) => data,
      orElse: () => '',
    );

    return NotificationListener<ScrollEndNotification>(
      onNotification: (notification) {
        if (notification.metrics.pixels ==
            notification.metrics.maxScrollExtent) {
          if (pageItems != null) {
            print('notificationListener, executed');
            providerListStory.fetchAllStoriesWithPagination(token: token);
          } else {
            return true;
          }
        }
        return false;
      },
      child: child,
    );
  }

  Widget _buildGetStories({
    required BuildContext context,
    required Widget Function(BuildContext context) builder,
  }) {
    return Consumer<ListStoryProvider>(
      builder: (context, provider, _) {
        final state = provider.stateListStory;
        const sizeWidthAndHeight = 30.0;

        Widget result = state.when(
          initial: () => WidgetHelper.loadingCustom(
            loadingController: _loadingController,
            loadingAnimation: _loadingAnimation,
            colorSchemeCustom: _colorSchemeCustom!,
            sizeWidthAndHeight: sizeWidthAndHeight,
          ),
          loading: () => WidgetHelper.loadingCustom(
            loadingController: _loadingController,
            loadingAnimation: _loadingAnimation,
            colorSchemeCustom: _colorSchemeCustom!,
            sizeWidthAndHeight: sizeWidthAndHeight,
          ),
          loaded: (data) {
            if (data.listStory.isEmpty) {
              return const ScrollableCenterText(text: StringData.emptyData);
            }
            return builder(context);
          },
          error: (message) => ScrollableCenterText(text: message),
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
    final providerListStory = context.watch<ListStoryProvider>();

    final savedListStory = providerListStory.listStory;
    final int? pageItems = providerListStory.pageItems;

    return ListView.builder(
      physics: _isUseSliverStyle
          ? const NeverScrollableScrollPhysics()
          : const AlwaysScrollableScrollPhysics(),
      shrinkWrap: _isUseSliverStyle ? true : false,
      itemBuilder: (context, index) {
        if (index == savedListStory.length && pageItems != null) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: WidgetHelper.loadingCustom(
                loadingController: _loadingController,
                loadingAnimation: _loadingAnimation,
                colorSchemeCustom: _colorSchemeCustom!,
                sizeWidthAndHeight: 10,
              ),
            ),
          );
        }

        final item = savedListStory[index];
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
      itemCount: savedListStory.length + (pageItems != null ? 1 : 0),
    );
  }

  void _refreshPage(BuildContext context) {
    final provListStory = context.read<ListStoryProvider>();
    final providerPref = context.read<PreferencesProvider>();

    final stateToken = providerPref.stateToken;
    final token = stateToken.maybeWhen(
      loaded: (data) => data,
      orElse: () => '',
    );

    provListStory.setAllValueToDefault();
    provListStory.fetchAllStoriesWithPagination(token: token);
  }

  @override
  Widget build(BuildContext context) {
    _colorSchemeCustom = context.read<MaterialThemeProvider>().currentSelected;
    _textTheme = Theme.of(context).textTheme;

    return _isUseSliverStyle
        ? _buildScaffoldSliver(context)
        : _buildScaffold(context);
  }
}
