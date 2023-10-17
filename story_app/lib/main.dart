import 'package:flutter/material.dart';
import 'package:story_app/ui/login_page.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/ui/signup_page.dart';

void main() {
  runApp(const MyApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const LoginPage(),
    ),
    GoRoute(
      path: '/signup',
      builder: (_, __) => const SignupPage(),
    ),
  ],
);

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Story App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}
