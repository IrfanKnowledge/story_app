import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:story_app/common/color_scheme/theme.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/detail_story_model.dart';
import 'package:story_app/provider/detail_story_provider.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/ui/map_page.dart';
import 'package:story_app/widget/center_loading.dart';
import 'package:story_app/widget/scrollable_center_text.dart';

class DetailStoryPage extends StatefulWidget {
  static const String goRoutePath = 'stories/:id';

  final String id;

  const DetailStoryPage({
    super.key,
    required this.id,
  });

  @override
  State<DetailStoryPage> createState() => _DetailStoryPageState();
}

class _DetailStoryPageState extends State<DetailStoryPage> {
  final textStyle16 = const TextStyle(
    fontSize: 16,
  );

  final textStyle16Bold = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  AppLocalizations? _appLocalizations;
  MaterialScheme? _colorSchemeCustom;
  TextTheme? _textTheme;

  void _initBuild(BuildContext context) {
    final providerMaterialTheme = context.watch<MaterialThemeProvider>();

    _appLocalizations = AppLocalizations.of(context);
    _colorSchemeCustom = providerMaterialTheme.currentSelected;
    _textTheme = Theme.of(context).textTheme;
  }

  Widget _buildMultiProvider({
    required Widget Function(BuildContext context) builder,
  }) {
    final providerPref = context.read<PreferencesProvider>();
    final token = providerPref.stateToken.maybeWhen(
      loaded: (data) => data,
      orElse: () => '',
    );

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) {
            return DetailStoryProvider(
              apiService: ApiService(),
              id: widget.id,
              token: token,
            );
          },
        )
      ],
      builder: (context, _) => builder(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final providerDetail = context.read<DetailStoryProvider>();
    final providerPref = context.read<PreferencesProvider>();

    final token = providerPref.stateToken.maybeWhen(
      loaded: (data) => data,
      orElse: () => '',
    );

    return Scaffold(
      appBar: _buildAppBar(context),
      body: RefreshIndicator(
        onRefresh: () async {
          providerDetail.fetchStoryDetail(
            token: token,
            id: widget.id,
          );
        },
        child: _getStoryDetail(
          token: token,
          id: widget.id,
          builder: (context) {
            return _buildContainer(context);
          },
        ),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final colorSchemeCustom =
        context.watch<MaterialThemeProvider>().currentSelected;

    return AppBar(
      title: Text(_appLocalizations!.detailStory),
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

  /// get story detail from API,
  /// required token and id
  Widget _getStoryDetail({
    required String token,
    required String id,
    required Widget Function(BuildContext context) builder,
  }) {
    return Consumer<DetailStoryProvider>(
      builder: (context, provider, _) {
        final state = provider.stateDetailStoryModel;

        Widget result = state.when(
          initial: () => const CenterLoading(),
          loading: () => const CenterLoading(),
          loaded: (_) => builder(context),
          error: (message) => ScrollableCenterText(text: message),
        );

        return result;
      },
    );
  }

  Widget _buildContainer(BuildContext context) {
    final provider = context.read<DetailStoryProvider>();

    final state = provider.stateDetailStoryModel;
    final Story? story = state.maybeWhen(
      loaded: (data) => data.story,
      orElse: () => null,
    );

    final double? latitude = story!.lat;
    final double? longitude = story.lon;
    final description = story.description;

    var textStyle14BoldColor = TextStyle(
      color: Theme.of(context).colorScheme.primary,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    return SingleChildScrollView(
      child: Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildDetailImage(context),
            const Gap(10),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildDetailDateTimeAndUsername(context),
                  const Gap(10),
                  if (latitude != null && longitude != null)
                    _buildDetailLocation(
                      context: context,
                      latitude: latitude,
                      longitude: longitude,
                    )
                  else
                    const Gap(0),
                  _buildDetailDescription(story),
                  const Gap(8),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailImage(BuildContext context) {
    final provider = context.read<DetailStoryProvider>();

    final state = provider.stateDetailStoryModel;
    final Story? story = state.maybeWhen(
      loaded: (data) => data.story,
      orElse: () => null,
    );

    final image = story!.photoUrl;

    return Container(
      decoration: const BoxDecoration(
        color: Colors.black,
      ),
      child: Image.network(
        headers: const {
          'Connection': 'keep-alive',
        },
        image,
        height: 300,
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          }
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            height: 300,
            child: Center(
              child: CircularProgressIndicator(
                backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                    : null,
              ),
            ),
          );
        },
        errorBuilder: (_, error, stackTrace) {
          return const Icon(
            Icons.image,
            size: 100,
          );
        },
      ),
    );
  }

  Column _buildDetailDateTimeAndUsername(BuildContext context) {
    final provider = context.read<DetailStoryProvider>();

    final state = provider.stateDetailStoryModel;
    final Story? story = state.maybeWhen(
      loaded: (data) => data.story,
      orElse: () => null,
    );

    final dateTime = story!.createdAt;
    var createdAt = DateFormat('yyyy-MM-dd H:m:s').format(dateTime);

    final name = story.name;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          createdAt,
          style: _textTheme!.titleMedium,
        ),
        const Gap(8),
        Text(
          name,
          style: _textTheme!.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailLocation({
    required BuildContext context,
    required double latitude,
    required double longitude,
  }) {
    final latLng = LatLng(latitude, longitude);

    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${_appLocalizations!.description}:',
                style: _textTheme!.labelLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Gap(8),
              Text(
                'Latitude: ${latitude.toString()}',
                style: _textTheme!.bodyMedium,
              ),
              Text(
                'Longitude: ${longitude.toString()}',
                style: _textTheme!.bodyMedium,
              ),
              const Gap(8),
              TextButton(
                style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(4.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    )),
                onPressed: () {
                  context.go(
                    '/${DetailStoryPage.goRoutePath}/${MapPage.goRoutePath}',
                    extra: latLng,
                  );
                },
                child: Text(_appLocalizations!.seeLocationOnMap),
              ),
              const Gap(8),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailDescription(Story story) {
    final description = story.description;
    final textStyle = _textTheme!.bodyMedium?.copyWith(
      fontWeight: FontWeight.bold,
      color: _colorSchemeCustom!.primary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          "${_appLocalizations!.description}:",
          style: _textTheme!.labelLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Gap(8),
        ReadMoreText(
          description,
          textAlign: TextAlign.justify,
          style: _textTheme!.bodyMedium,
          trimLines: 3,
          trimMode: TrimMode.Line,
          trimCollapsedText: _appLocalizations!.more,
          trimExpandedText: _appLocalizations!.less,
          moreStyle: textStyle,
          lessStyle: textStyle,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    _initBuild(context);

    return _buildMultiProvider(
      builder: (context) {
        return _buildScaffold(context);
      },
    );
  }
}
