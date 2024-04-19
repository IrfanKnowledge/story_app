import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/common/color_scheme/theme.dart';
import 'package:story_app/common/font/roboto_flex.dart';
import 'package:story_app/common/url_strategy.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/preferences/preferences_helper.dart';
import 'package:story_app/provider/list_story_provider.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/ui/add_story_page.dart';
import 'package:story_app/ui/detail_story_page.dart';
import 'package:story_app/ui/list_story_page.dart';
import 'package:story_app/ui/loading_page.dart';
import 'package:story_app/ui/login_page.dart';
import 'package:story_app/ui/signup_page.dart';

void main() {
  usePathUrlStrategy();

  runApp(const MyApp());
}

///
/// Penggunaan [MyApp.outerMatchedLocation] dan [MyApp.outerRedirectExecuted]
/// menjadi bagian dari penggunaan [LoadingPage]. Lebih jelasnya terdapat
/// penjelesan pada [LoadingPage].
///
class MyApp extends StatefulWidget {
  static String outerMatchedLocation = '/';
  static bool outerRedirectExecuted = false;

  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final MaterialTheme _materialTheme;
  late final MaterialScheme _materialSchemeCurrentSelected;
  late final ThemeMode _themeMode;
  late final ThemeData _theme;
  late final ThemeData _darkTheme;
  late final MaterialScheme _materialSchemeLight;
  late final MaterialScheme _materialSchemeDark;

  String? _redirectIfIsLogin(BuildContext context) {
    final state = context.read<PreferencesProvider>().stateIsLogin;

    final isLogin = state.maybeWhen(
      loaded: (data) => data,
      orElse: () => false,
    );

    if (isLogin) {
      return ListStoryPage.goRoutePath;
    } else {
      return null;
    }
  }

  String? _redirectIfIsNotLogin(BuildContext context) {
    final state = context.read<PreferencesProvider>().stateIsLogin;

    final isLogin = state.maybeWhen(
      loaded: (data) => data,
      orElse: () => false,
    );

    if (!isLogin) {
      return '/${LoginPage.goRoutePath}';
    } else {
      return null;
    }
  }

  bool _listStoryPageRefresh(BuildContext context) {
    final listStoryProv = context.read<ListStoryProvider>();
    final stateToken = context.read<PreferencesProvider>().stateToken;
    final token = stateToken.maybeWhen(
      loaded: (data) => data,
      orElse: () => '',
    );

    listStoryProv.fetchAllStories(token: token);
    return true;
  }

  /// Posisikan penggunaan [_routesLoginAndLoading] di bagian terluar
  /// list RouteBase, sebab perlu mengakses status login terlebih dahulu
  /// sebelum masuk ke path '/'. Jika diposisikan di bawah '/', ketika
  /// terjadi redirect atau go('/') maka yang terjadi adalah aksi pop,
  /// bukan push ataupun pushReplacement.
  late final _routesLoginAndLoading = <RouteBase>[
    GoRoute(
      path: '/${LoginPage.goRoutePath}',
      builder: (_, __) {
        return const LoginPage();
      },
      redirect: (context, __) => _redirectIfIsLogin(context),
      routes: [
        GoRoute(
          path: SignupPage.goRouteName,
          builder: (_, __) => const SignupPage(),
          redirect: (context, __) => _redirectIfIsLogin(context),
          onExit: (context) {
            print('signup, onExit');
            return true;
          },
        ),
      ],
    ),
    GoRoute(
      path: '/${LoadingPage.goRoutePath}',
      builder: (context, state) {
        print(
          'main, _routes, /loading, outerMatchedLocation: ${MyApp.outerMatchedLocation}',
        );
        return const LoadingPage();
      },
    ),
  ];

  late final _routes = <RouteBase>[
    GoRoute(
      path: ListStoryPage.goRoutePath,
      builder: (_, state) => const ListStoryPage(),
      routes: [
        GoRoute(
          path: 'add_story',
          builder: (_, __) => const AddStoryPage(),
          redirect: (context, __) => _redirectIfIsNotLogin(context),
          onExit: (context) => _listStoryPageRefresh(context),
        ),
        GoRoute(
          path: 'stories/:id',
          builder: (_, state) {
            return DetailStoryPage(
              id: state.pathParameters['id'] ?? '',
            );
          },
          redirect: (context, __) => _redirectIfIsNotLogin(context),
          onExit: (context) => _listStoryPageRefresh(context),
        ),
      ],
    ),
    ..._routesLoginAndLoading,
  ];

  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    final stateToken = context.read<PreferencesProvider>().stateToken;

    stateToken.maybeWhen(
      loading: () {
        if (!MyApp.outerRedirectExecuted) {
          MyApp.outerMatchedLocation = state.matchedLocation;
          MyApp.outerRedirectExecuted = true;
        }
        return '/${LoadingPage.goRoutePath}';
      },
      orElse: () {},
    );

    if (state.matchedLocation == ListStoryPage.goRoutePath) {
      return _redirectIfIsNotLogin(context);
    }
    return null;
  }

  late final _router = GoRouter(
    routes: _routes,
    initialLocation: ListStoryPage.goRoutePath,
    debugLogDiagnostics: true,
    redirect: redirect,
  );

  @override
  void initState() {
    _materialTheme = MaterialTheme(RobotoFlex.textTheme);
    _theme = _materialTheme.light();
    _darkTheme = _materialTheme.dark();
    _materialSchemeLight = MaterialTheme.lightScheme();
    _materialSchemeDark = MaterialTheme.darkScheme();
    _materialSchemeCurrentSelected = _materialSchemeLight;
    _themeMode = ThemeMode.light;
    super.initState();
  }

  MultiProvider _buildMultiProvider({
    required Widget Function(BuildContext context) builder,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return MaterialThemeProvider(
              currentSelected: _materialSchemeCurrentSelected,
              themeMode: _themeMode,
              light: _materialSchemeLight,
              dark: _materialSchemeDark,
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
        ChangeNotifierProvider(
          create: (context) {
            return ListStoryProvider(
              apiService: ApiService(),
            );
          },
        ),
      ],
      builder: (context, _) => builder(context),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildMultiProvider(
      builder: (context) {
        final providerMaterialTheme = context.watch<MaterialThemeProvider>();

        return MaterialApp.router(
          routerConfig: _router,
          title: 'Story App',
          themeMode: providerMaterialTheme.themeMode,
          theme: _theme,
          darkTheme: _darkTheme,
        );
      },
    );
  }
}
