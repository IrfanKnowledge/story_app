import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:readmore/readmore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/detail_story_model.dart';
import 'package:story_app/data/preferences/preferences_helper.dart';
import 'package:story_app/provider/detail_story_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/widget/center_error.dart';
import 'package:story_app/widget/center_loading.dart';

class DetailStoryPage extends StatelessWidget {
  static const String path = '/stories/';

  final String id;

  const DetailStoryPage({super.key, required this.id});

  final textStyle16 = const TextStyle(
    fontSize: 16,
  );

  final textStyle16Bold = const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

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

  /// get token from SharedPreference
  /// used for [_getStoryDetail]
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

  /// get story detail from API,
  /// required token and id
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
          return _buildContainer(context);

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

  Widget _buildContainer(BuildContext context) {
    final provider = context.read<DetailStoryProvider>();
    final Story? story = provider.detailStoryWrap.story;

    final image = story!.photoUrl;

    final dateTime = story.createdAt;
    var createdAt = DateFormat('yyyy-MM-dd H:m:s').format(dateTime);

    final name = story.name;
    final latitude = story.lat;
    final longitude = story.lon;
    final description = story.description;

    var textStyle14BoldColor = TextStyle(
      color: const ColorScheme.light().secondary,
      fontSize: 14,
      fontWeight: FontWeight.bold,
    );

    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                decoration: BoxDecoration(
                  color: const ColorScheme.light().secondary,
                ),
                child: Image.network(
                  image,
                  height: 500,
                  fit: BoxFit.contain,
                  errorBuilder: (_, error, stackTrace) {
                    print(
                      '_buildContainer, DetailStoryPage, Image.network, error: $error',
                    );
                    print('stackTrace: $stackTrace');
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
        _buildContainerLabel('longitude:'),
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
            fontWeight: FontWeight.bold),
      ),
    );
  }
}
