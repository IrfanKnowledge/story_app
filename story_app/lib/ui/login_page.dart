import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/preferences/preferences_helper.dart';
import 'package:story_app/provider/login_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/ui/list_story_page.dart';
import 'package:story_app/ui/signup_page.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/widget/ElevatedButtonInfinityWidget.dart';
import 'package:story_app/widget/center_loading.dart';
import 'package:story_app/widget/text_field_login_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _buildMultiProvider();
  }

  Widget _buildMultiProvider() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginProvider(
            apiService: ApiService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => PreferencesProvider(
            preferencesHelper: PreferencesHelper(
              sharedPreferences: SharedPreferences.getInstance(),
            ),
          ),
        ),
      ],
      child: _buildScaffold(),
    );
  }

  Widget _buildScaffold() {
    return Scaffold(
      body: _buildIsLogin(),
    );
  }

  /// if login is true, navigate to ListStoryPage,
  /// if login is not true, stay on this page,
  Widget _buildIsLogin() {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, _) {
        // if state is still not started
        if (provider.stateIsLogin == ResultState.notStarted) {
          return const CenterLoading();

          // if state is loading (fetch isLogin from SharedPreference),
          // show loading
        } else if (provider.stateIsLogin == ResultState.loading) {
          return const CenterLoading();

          // if isLogin is true
        } else if (provider.isLogin) {
          //auto navigate to ListStoryPage
          return FutureBuilder(
            future: _autoNavigate(context),
            builder: (_, __) => const CenterLoading(),
          );
        }

        // if isLogin is not true
        return _buildLoginProgress();
      },
    );
  }

  /// delayed because we need to wait until UI building process is done,
  /// to avoiding an error.
  Future<String> _autoNavigate(BuildContext context) async {
    await Future.delayed(
      const Duration(seconds: 1),
      () {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const ListStoryPage(),
          ),
        );
      },
    );
    return 'loading...';
  }

  /// if login process is begin,
  /// then do login progress,
  Widget _buildLoginProgress() {
    return Consumer<LoginProvider>(
      builder: (context, providerLogin, __) {
        if (providerLogin.state == ResultState.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (providerLogin.state == ResultState.hasData) {

          // using FutureBuilder.future to do automatic navigation,
          // because Navigator.push can't be used inside return Widget(),
          // Navigator.push not return a Widget(),
          // that is why Navigator.push almost always used inside Button.onPress: () {} (no need to return a Widget())
          return FutureBuilder(
            future: _autoNavigateSetLoginAndToken(
              context,
              providerLogin.loginWrap.loginResult!
                  .token, // use '!' because it's 100% not null
            ),
            builder: (_, __) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        } else {
          return _buildSafeArea();
        }
      },
    );
  }

  /// automatic navigate if [_buildLoginProgress] == ResultState.hasData
  Future<String> _autoNavigateSetLoginAndToken(
    BuildContext context,
    String token,
  ) async {
    await Future.delayed(
      const Duration(seconds: 1),
      () {
        var providerPrefs =
            Provider.of<PreferencesProvider>(context, listen: false);
        providerPrefs.setLoginStatus(true);
        providerPrefs.setToken(token);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => const ListStoryPage(),
          ),
        );
      },
    );

    return 'loading...';
  }

  SafeArea _buildSafeArea() {
    return SafeArea(
      child: SingleChildScrollView(
        child: _buildContainer(),
      ),
    );
  }

  Widget _buildContainer() {
    _controllerEmail.text = 'NPC001@gmail.com';
    _controllerPassword.text = 'npc00001';

    const textStyle16 = TextStyle(
      fontSize: 16,
    );

    return Consumer<LoginProvider>(
      builder: (context, provider, _) {
        return Container(
          alignment: Alignment.topCenter,
          padding: const EdgeInsets.only(
            top: 32,
            bottom: 8,
            right: 16.0,
            left: 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundColor: const ColorScheme.light().secondary,
                radius: 75,
                child: const Icon(
                  Icons.person,
                  size: 125,
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Selamat datang di Story App',
                        style: textStyle16,
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Bagikan kisah-kisah menarikmu melalui Story App!',
                        style: textStyle16,
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFieldLoginWidget(
                labelText: 'Email',
                hintText: '...@....com',
                textEditingController: _controllerEmail,
              ),
              const SizedBox(height: 10),
              TextFieldLoginWidget(
                obscureText: true,
                labelText: 'Password',
                textEditingController: _controllerPassword,
              ),
              const SizedBox(height: 20),
              ElevatedButtonInfinityWidget(
                text: 'Sign In',
                onTap: () => _postLogin(context),
              ),
              const SizedBox(
                height: 20,
              ),
              ElevatedButtonInfinityWidget(
                text: 'Sign Up',
                onTap: () => _navigateToSignupPage(context),
              ),
              FutureBuilder(
                future: _snackBarLogin(provider.state, provider.message),
                builder: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),
        );
      },
    );
  }

  void _postLogin(BuildContext context) {
    final provider = context.read<LoginProvider>();
    provider.postLogin(
      email: _controllerEmail.text,
      password: _controllerPassword.text,
    );
  }

  void _navigateToSignupPage(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignupPage(),
      ),
    );
  }

  /// show snackBar when [_buildLoginProgress] == ResultState.noData or ResultState.error
  /// delayed because we need to wait until UI building process is done,
  /// to avoiding an error.
  Future<String> _snackBarLogin(ResultState state, String message) async {
    await Future.delayed(
      const Duration(seconds: 1),
      () {
        SnackBar? snackBar;
        Duration duration = const Duration(seconds: 1);

        if (state == ResultState.noData || state == ResultState.error) {
          snackBar = SnackBar(
            content: Text(message),
            duration: duration,
          );
        }

        if (snackBar != null) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
    );
    return 'loading...';
  }

  /// hapus penggunaan memori yang sudah tidak digunakan ketika halaman ini tertutup
  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
