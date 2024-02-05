import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/common/assets/color_scheme/theme.dart';
import 'package:story_app/common/assets/font/roboto_flex.dart';
import 'package:story_app/common/url_strategy.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/preferences/preferences_helper.dart';
import 'package:story_app/provider/list_story_provider.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/ui/add_story_page.dart';
import 'package:story_app/ui/detail_story_page.dart';
import 'package:story_app/ui/list_story_page.dart';
import 'package:story_app/ui/login_page.dart';

void main() {
  // (use path url for web (remove hash '#' from url) or if isn't web then do nothing)
  // this method, it is from url_strategy.dart
  usePathUrlStrategy();

  runApp(const MyApp());
}

String? _redirectIfIsLogin() {
  if (isLogin) {
    return '/';
  } else {
    return null;
  }
}

String? _redirectIfIsNotLogin() {
  if (!isLogin) {
    return '/login';
  } else {
    return null;
  }
}

bool _listStoryPageRefresh(BuildContext context) {
  final listStoryProv = context.read<ListStoryProvider>();
  final token = context.read<PreferencesProvider>().token;
  listStoryProv.fetchAllStories(token: token);
  return true;
}

bool isLogin = false;

final routingConfig1 = RoutingConfig(
  routes: [
    GoRoute(
      path: '/',
      builder: (_, state) => const ListStoryPage(),
      redirect: (_, __) => _redirectIfIsNotLogin(),
      routes: [
        GoRoute(
          path: 'add_story',
          builder: (_, __) => const AddStoryPage(),
          redirect: (_, __) => _redirectIfIsNotLogin(),
          onExit: (context) => _listStoryPageRefresh(context),
        ),
        GoRoute(
          path: 'stories/:id',
          builder: (_, state) {
            return DetailStoryPage(
              id: state.pathParameters['id'] ?? '',
            );
          },
          redirect: (_, __) => _redirectIfIsNotLogin(),
          onExit: (context) => _listStoryPageRefresh(context),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginPage(),
      redirect: (_, __) => _redirectIfIsLogin(),
    ),
    GoRoute(
      path: '/signup',
      builder: (_, __) => const LoginPage(),
      redirect: (_, __) => _redirectIfIsLogin(),
    ),
  ],
);

final myRoutingConfig = ValueNotifier<RoutingConfig>(
  RoutingConfig(
    routes: routingConfig1.routes,
  ),
);

final _router = GoRouter.routingConfig(
  initialLocation: '/',
  routingConfig: myRoutingConfig,
  debugLogDiagnostics: true,
);

class MyApp extends StatefulWidget {
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
    return _buildMultiProvider(builder: (context) {
      final providerMaterialTheme = context.watch<MaterialThemeProvider>();

      return MaterialApp.router(
        title: 'Story App',
        themeMode: providerMaterialTheme.themeMode,
        theme: _theme,
        darkTheme: _darkTheme,
        routerConfig: _router,
      );
    });
  }
}
