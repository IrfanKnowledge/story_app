import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/detail_story_model.dart';
import 'package:story_app/provider/detail_story_provider.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/widget/center_error.dart';
import 'package:story_app/widget/center_loading.dart';

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
    final providerPref = context.read<PreferencesProvider>();
    final token = providerPref.stateToken.maybeWhen(
      loaded: (data) => data,
      orElse: () => '',
    );

    return Scaffold(
      appBar: _buildAppBar(context),
      body: _getStoryDetail(
        token: token,
        id: widget.id,
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
          error: (message) => CenterError(description: message),
        );

        return result;

        // if (provider.state == ResultState.notStarted) {
        //   return FutureBuilder(
        //     future: _fetchStoryDetail(
        //       context: context,
        //       token: token,
        //       id: id,
        //     ),
        //     builder: (_, __) => const CenterLoading(),
        //   );
        // } else if (provider.state == ResultState.loading) {
        //   return const CenterLoading();
        //
        //   // if state is has data, show the data
        // } else if (provider.state == ResultState.hasData) {
        //   return _buildContainer(context);
        //
        //   // if state is error, show error message
        // } else if (provider.state == ResultState.error) {
        //   return CenterError(
        //     description: provider.message,
        //   );
        //
        //   // if state is other else, show error message
        // } else {
        //   return CenterError(
        //     description: provider.message,
        //   );
        // }
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

  Widget _buildContainer(BuildContext context) {
    final provider = context.read<DetailStoryProvider>();
    final state = provider.stateDetailStoryModel;
    final Story? story = state.maybeWhen(
      loaded: (data) => data.story,
      orElse: () => null,
    );

    final image = story!.photoUrl;

    final dateTime = story.createdAt;
    var createdAt = DateFormat('yyyy-MM-dd H:m:s').format(dateTime);

    final name = story.name;
    final latitude = story.lat;
    final longitude = story.lon;
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
            Container(
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
                        backgroundColor:
                            Theme.of(context).colorScheme.primaryContainer,
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
            ),
            const SizedBox(
              height: 10,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    createdAt,
                    style: textStyle16,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    name,
                    style: textStyle16Bold,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  ..._buildLatLon(
                    latitude: latitude,
                    longitude: longitude,
                  ),
                  _buildContainerLabel('Deskripsi:'),
                  const SizedBox(
                    height: 5,
                  ),
                  ReadMoreText(
                    description,
                    textAlign: TextAlign.justify,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    trimLines: 3,
                    trimMode: TrimMode.Line,
                    trimCollapsedText: 'Selengkapnya',
                    trimExpandedText: 'Lebih sedikit',
                    moreStyle: textStyle14BoldColor,
                    lessStyle: textStyle14BoldColor,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildLatLon(
      {required double? latitude, required double? longitude}) {
    if (latitude != null && longitude != null) {
      final list = [
        _buildContainerLabel('Latitude:'),
        const SizedBox(
          height: 5,
        ),
        Text(
          latitude.toString(),
          style: textStyle16,
        ),
        const SizedBox(
          height: 10,
        ),
        _buildContainerLabel('Longitude:'),
        const SizedBox(
          height: 5,
        ),
        Text(
          longitude.toString(),
          style: textStyle16,
        ),
        const SizedBox(
          height: 10,
        ),
      ];
      return list;
    } else {
      // return empty widget
      return [
        const SizedBox.shrink(),
      ];
    }
  }

  Widget _buildContainerLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: const ColorScheme.light().secondary,
      ),
      child: Text(
        label,
        style: TextStyle(
          color: const ColorScheme.light().onSecondary,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _appLocalizations = AppLocalizations.of(context);
    return _buildMultiProvider(
      builder: (context) {
        return _buildScaffold(context);
      },
    );
  }
}
