import 'dart:async';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/common/color_scheme/theme.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/common/font/roboto_flex.dart';
import 'package:story_app/common/url_strategy.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/preferences/preferences_helper.dart';
import 'package:story_app/data/string/StringData.dart';
import 'package:story_app/provider/list_story_provider.dart';
import 'package:story_app/provider/localizations_provider.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/ui/add_story_page.dart';
import 'package:story_app/ui/bottom_nav_bar.dart';
import 'package:story_app/ui/detail_story_page.dart';
import 'package:story_app/ui/list_story_page.dart';
import 'package:story_app/ui/loading_page.dart';
import 'package:story_app/ui/login_page.dart';
import 'package:story_app/ui/settings_page.dart';
import 'package:story_app/ui/signup_page.dart';
import 'package:story_app/utils/future_helper.dart';

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
  late final Brightness _brightness;
  late final Locale _locale;
  late final bool _isLocaleSystem;

  final GlobalKey<NavigatorState> _rootNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'root');
  final GlobalKey<NavigatorState> _shellNavigatorKey =
      GlobalKey<NavigatorState>(debugLabel: 'shell');

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

    print('_redirectIfIsNotLogin, isLogin: $isLogin');

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
        print('GoRoute LoginPage');
        return const LoginPage();
      },
      redirect: (context, __) => _redirectIfIsLogin(context),
      onExit: (context) async {
        late final bool? result;

        if (LoginPage.isShowDialogTrue) {
          result = await FutureHelper.buildShowAlertDialogTextForExitApp<bool>(
            context: context,
            onFalsePressed: () => context.pop(false),
            onTruePressed: () => context.pop(true),
          );
        } else {
          LoginPage.isShowDialogTrue = true;
          result = true;
        }

        print('LoginPage.isShowDialogTrue: ${LoginPage.isShowDialogTrue}');

        return result ?? false;
      },
      routes: [
        GoRoute(
          path: SignupPage.goRouteName,
          builder: (_, __) => const SignupPage(),
          redirect: (context, __) => _redirectIfIsLogin(context),
          onExit: (context) async {
            late final bool? result;

            if (SignupPage.isShowDialogTrue) {
              result =
                  await FutureHelper.buildShowAlertDialogTextForExitPage<bool>(
                context: context,
                onFalsePressed: () => context.pop(false),
                onTruePressed: () => context.pop(true),
              );
            } else {
              SignupPage.isShowDialogTrue = true;
              result = true;
            }

            return result ?? false;
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
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (BuildContext context, GoRouterState state, Widget child) {
        return BottomNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (_, state) => const ListStoryPage(),
          onExit: (context) async {
            late final bool? result;

            if (ListStoryPage.isShowDialogTrue) {
              result =
                  await FutureHelper.buildShowAlertDialogTextForExitApp<bool>(
                context: context,
                onFalsePressed: () => context.pop(false),
                onTruePressed: () => context.pop(true),
              );
            } else {
              ListStoryPage.isShowDialogTrue = true;
              result = true;
            }

            return result ?? false;
          },
          routes: [
            GoRoute(
              path: DetailStoryPage.goRoutePath,
              parentNavigatorKey: _rootNavigatorKey,
              builder: (_, state) {
                return DetailStoryPage(
                  id: state.pathParameters['id'] ?? '',
                );
              },
              redirect: (context, __) => _redirectIfIsNotLogin(context),
              onExit: (context) => _listStoryPageRefresh(context),
            ),
            GoRoute(
              path: AddStoryPage.goRoutePath,
              parentNavigatorKey: _rootNavigatorKey,
              builder: (_, __) => const AddStoryPage(),
              redirect: (context, __) => _redirectIfIsNotLogin(context),
              onExit: (context) {
                ListStoryPage.isShowDialogTrue = true;
                return _listStoryPageRefresh(context);
              },
            ),
          ],
        ),
        GoRoute(
          path: '/${SettingsPage.goRouteName}',
          builder: (_, __) => const SettingsPage(),
          onExit: (context) async {
            late final bool? result;

            if (SettingsPage.isShowDialogTrue) {
              result =
                  await FutureHelper.buildShowAlertDialogTextForExitApp<bool>(
                context: context,
                onFalsePressed: () => context.pop(false),
                onTruePressed: () => context.pop(true),
              );
            } else {
              SettingsPage.isShowDialogTrue = true;
              result = true;
            }

            return result ?? false;
          },
        ),
      ],
    ),
    ..._routesLoginAndLoading,
  ];

  late final _router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    redirect: redirect,
    routes: _routes,
  );

  FutureOr<String?> redirect(BuildContext context, GoRouterState state) {
    print('GoRouterState: ${state.matchedLocation}');

    final stateToken = context.read<PreferencesProvider>().stateToken;
    final stateThemeMode = context.read<PreferencesProvider>().stateThemeMode;

    print('redirect, stateToken: $stateToken, stateThemeMode: $stateThemeMode');

    String? result;

    result = stateToken.maybeWhen<String?>(
      loading: () {
        if (!MyApp.outerRedirectExecuted) {
          MyApp.outerMatchedLocation = state.matchedLocation;
          MyApp.outerRedirectExecuted = true;
        }
        print('stateTokenLoading');
        return '/${LoadingPage.goRoutePath}';
      },
      orElse: () {
        print('stateTokenOrElse');
        return null;
      },
    );

    if (result != null) return result;

    result = stateThemeMode.maybeWhen<String?>(
      loading: () {
        if (!MyApp.outerRedirectExecuted) {
          MyApp.outerMatchedLocation = state.matchedLocation;
          MyApp.outerRedirectExecuted = true;
        }
        print('stateThemeMode');
        return '/${LoadingPage.goRoutePath}';
      },
      orElse: () {
        print('stateThemeModeOrElse');
        return null;
      },
    );

    if (result != null) return result;

    print('last');

    if (state.matchedLocation == ListStoryPage.goRoutePath) {
      return _redirectIfIsNotLogin(context);
    }

    return null;
  }

  @override
  void initState() {
    _materialTheme = MaterialTheme(RobotoFlex.textTheme);
    _theme = _materialTheme.light();
    _darkTheme = _materialTheme.dark();
    _materialSchemeLight = MaterialTheme.lightScheme();
    _materialSchemeDark = MaterialTheme.darkScheme();
    _materialSchemeCurrentSelected = _materialSchemeLight;
    _themeMode = ThemeMode.system;

    final localeSystemName = !kIsWeb
        ? Platform.localeName
        : PlatformDispatcher.instance.locale.languageCode;

    print(
        'PlatformDispatcher.instance.locale.languageCode;; initState: ${PlatformDispatcher.instance.locale.languageCode}');

    String localeSystemNameSplitFirst = localeSystemName.split('_').first;
    if (localeSystemNameSplitFirst.isEmpty) {
      localeSystemNameSplitFirst = localeSystemName;
    }

    final localeSystem = Locale(localeSystemNameSplitFirst);
    _locale = localeSystem;

    _isLocaleSystem = true;

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _brightness = MediaQuery.of(context).platformBrightness;
    super.didChangeDependencies();
  }

  MultiProvider _buildMultiProvider({
    required Widget Function(BuildContext context) builder,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) {
            return MaterialThemeProvider(
              context: context,
              brightness: _brightness,
              currentSelected: _materialSchemeCurrentSelected,
              themeMode: _themeMode,
              light: _materialSchemeLight,
              dark: _materialSchemeDark,
            );
          },
        ),
        ChangeNotifierProvider(
          create: (context) {
            return LocalizationsProvider(
              locale: _locale,
              isLocaleSystem: _isLocaleSystem,
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
        final themeMode = providerMaterialTheme.themeMode;

        final providerLocalizations = context.watch<LocalizationsProvider>();
        final locale = providerLocalizations.locale;

        const titleApp = StringData.titleApp;

        return MaterialApp.router(
          routerConfig: _router,
          title: titleApp,
          themeMode: themeMode,
          theme: _theme,
          darkTheme: _darkTheme,
          locale: locale,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        );
      },
    );
  }
}
