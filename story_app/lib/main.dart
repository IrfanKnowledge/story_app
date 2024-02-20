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
import 'package:story_app/ui/loading_page.dart';
import 'package:story_app/ui/login_page.dart';
import 'package:story_app/ui/signup_page.dart';
import 'package:story_app/ui/test1_page.dart';
import 'package:story_app/ui/test2_page.dart';
import 'package:story_app/ui/test3_page.dart';
import 'package:story_app/utils/result_state_helper.dart';

void main() {
  usePathUrlStrategy();

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

String outerMatchedLocation = '/';
bool outerRedirectExecuted = false;

class _MyAppState extends State<MyApp> {
  late final MaterialTheme _materialTheme;
  late final MaterialScheme _materialSchemeCurrentSelected;
  late final ThemeMode _themeMode;
  late final ThemeData _theme;
  late final ThemeData _darkTheme;
  late final MaterialScheme _materialSchemeLight;
  late final MaterialScheme _materialSchemeDark;

  String? _redirectIfIsLogin(BuildContext context) {
    final isLogin = context.read<PreferencesProvider>().isLogin;
    if (isLogin) {
      return '/';
    } else {
      return null;
    }
  }

  String? _redirectIfIsNotLogin(BuildContext context) {
    final isLogin = context.read<PreferencesProvider>().isLogin;
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

  late final _routes = <RouteBase>[
    GoRoute(
      path: '/',
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
        GoRoute(
          path: 'test1',
          builder: (_, __) => const Test1Page(),
          routes: [
            GoRoute(
              name: 'test2-1',
              path: 'test2',
              builder: (_, __) => const Test2Page(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: '/test3',
      builder: (_, __) => const Test3Page(),
      routes: [
        GoRoute(
          name: 'test2-2',
          path: 'test2',
          builder: (_, __) => const Test2Page(),
        ),
      ],
    ),
    GoRoute(
      path: '/login',
      builder: (_, __) => const LoginPage(),
      redirect: (context, __) => _redirectIfIsLogin(context),
      routes: [
        GoRoute(
          path: 'signup',
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
      path: '/loading',
      builder: (context, state) {
        print(
          'main, _routes, /loading, outerMatchedLocation: $outerMatchedLocation',
        );
        return const LoadingPage();
      },
    ),
  ];

  late final _router = GoRouter(
    routes: _routes,
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final stateToken = context.read<PreferencesProvider>().stateToken;

      if (stateToken == ResultState.loading) {
        if (!outerRedirectExecuted) {
          outerMatchedLocation = state.matchedLocation;
          outerRedirectExecuted = true;
          print('outerMatchedLocation: $outerMatchedLocation');
        }
        return '/loading';
      }

      if (state.matchedLocation == '/') {
        return _redirectIfIsNotLogin(context);
      }
      return null;
    },
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
