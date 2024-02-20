// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/provider/login2_provider.dart';
import 'package:story_app/ui/test1_page.dart';

// This scenario demonstrates how to use redirect to handle a sign-in flow.
//
// The GoRouter.redirect method is called before the app is navigate to a
// new page. You can choose to redirect to a different page by returning a
// non-null URL string.

/// The login information.
class LoginInfo extends ChangeNotifier {
  /// The username of login.
  String get userName => _userName;
  String _userName = '';

  /// Whether a user has logged in.
  bool get loggedIn => _userName.isNotEmpty;

  /// Logs in a user.
  void login(String userName) {
    _userName = userName;
    notifyListeners();
  }

  /// Logs out the current user.
  void logout() {
    _userName = '';
    notifyListeners();
  }
}

void main() => runApp(App());

/// The main app.
class App extends StatefulWidget {
  /// Creates an [App].
  App({super.key});

  /// The title of the app.
  static const String title = 'GoRouter Example: Redirection';

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  final LoginInfo _loginInfo = LoginInfo();

  final login2Provider = Login2Provider();

  @override
  void initState() {
    print('Redirection');
    super.initState();
  }

  // add the login info into the tree as app state that can change over time
  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<Login2Provider>.value(
        value: login2Provider,
        child: MaterialApp.router(
          routerConfig: _router,
          title: App.title,
          debugShowCheckedModeBanner: false,
        ),
      );

  late final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: <GoRoute>[
      GoRoute(
        path: '/',
        builder: (BuildContext context, GoRouterState state) =>
            const HomeScreen(),
      ),
      GoRoute(
        path: '/login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginScreen(),
      ),
      GoRoute(
        path: '/test1',
        builder: (BuildContext context, GoRouterState state) =>
            const Test1Page(),
      ),
    ],

    // redirect to the login page if the user is not logged in
    redirect: (BuildContext context, GoRouterState state) {
      // print('logedIn = ${_loginInfo.loggedIn}');
      print('logedIn = ${login2Provider.isLogin}');

      // if the user is not logged in, they need to login
      // final bool loggedIn = _loginInfo.loggedIn;
      // final bool loggingIn = state.matchedLocation == '/login';
      // if (!loggedIn) {
      //   return '/login';
      // }

      // if the user is logged in but still on the login page, send them to
      // the home page
      // if (loggingIn) {
      //   return '/';
      // }

      // no need to redirect at all
      return null;
    },

    // changes on the listenable will cause the router to refresh it's route
    // refreshListenable: _loginInfo,
    refreshListenable: login2Provider,
    debugLogDiagnostics: true,
  );
}

/// The login screen.
class LoginScreen extends StatelessWidget {
  /// Creates a [LoginScreen].
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text(App.title)),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              // log a user in, letting all the listeners know
              // context.read<LoginInfo>().login('test-user');
              context.read<Login2Provider>().login();

              // router will automatically redirect from /login to / using
              // refreshListenable
            },
            child: const Text('Login'),
          ),
        ),
      );
}

/// The home screen.
class HomeScreen extends StatelessWidget {
  /// Creates a [HomeScreen].
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // final LoginInfo info = context.read<LoginInfo>();
    final login2 = context.read<Login2Provider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(App.title),
        actions: <Widget>[
          IconButton(
            // onPressed: info.logout,
            onPressed: () {
              login2.logout();
            },
            // tooltip: 'Logout: ${info.userName}',
            icon: const Icon(Icons.logout),
          )
        ],
      ),
      body: const Center(
        child: Text('HomeScreen'),
      ),
    );
  }
}
