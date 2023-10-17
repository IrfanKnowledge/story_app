import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/preferences/preferences_helper.dart';
import 'package:story_app/provider/login_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/ui/list_story_page.dart';
import 'package:story_app/ui/signup_page.dart';
import 'package:story_app/utils/button_style_helper.dart';
import 'package:story_app/utils/form_validate_helper.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/widget/center_loading.dart';

class LoginPage extends StatefulWidget {
  static const String path = '/';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _buildMultiProvider();
  }

  /// build provider more than 1
  /// (provider used for state management)
  Widget _buildMultiProvider() {
    return MultiProvider(
      providers: [
        // provider to use API Service
        ChangeNotifierProvider(
          create: (_) => LoginProvider(
            apiService: ApiService(),
          ),
        ),
        // provider to use SharedPreferences
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
          // show loading
          return const CenterLoading();

          // if state is loading (fetch isLogin from SharedPreference),
        } else if (provider.stateIsLogin == ResultState.loading) {
          // show loading
          return const CenterLoading();

          // if isLogin is true
        } else if (provider.isLogin) {
          // auto navigate to ListStoryPage
          return FutureBuilder(
            future: _autoNavigate(context),
            // show loading while await auto navigate process
            builder: (_, __) => const CenterLoading(),
          );
        }

        // if isLogin is not true
        return _buildLoginProgress();
      },
    );
  }

  /// Auto navigate to ListStoryPage.
  /// Delayed because we need to wait until UI building process is done,
  /// to avoiding an error.
  Future<String> _autoNavigate(BuildContext context) async {
    await Future.delayed(
      const Duration(seconds: 1),
      () {
        context.go(ListStoryPage.path);
      },
    );
    return 'loading...';
  }

  /// if login process is begin, then do login progress.
  /// if login process is finish or not started, stay on this page.
  Widget _buildLoginProgress() {
    return Consumer<LoginProvider>(
      builder: (context, providerLogin, __) {
        // if state is loading (fetching login response from API Service)
        if (providerLogin.state == ResultState.loading) {
          // show loading
          return const Center(
            child: CircularProgressIndicator(),
          );
          // if state is has data
        } else if (providerLogin.state == ResultState.hasData) {

          // auto navigate to ListStoryPage,
          // set login status and set token to SharedPreferences.
          return FutureBuilder(
            future: _autoNavigateSetLoginAndToken(
              context,
              // use '!' because it's 100% not null
              providerLogin.loginWrap.loginResult!.token,
            ),
            builder: (_, __) {
              // show loading while await auto navigate process
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        }
        // if other condition is true then stay on this page
        return _buildSafeArea();
      },
    );
  }

  /// Auto navigate to ListStoryPage,
  /// set login status and set token to SharedPreferences.
  /// Delayed because we need to wait until UI building process is done,
  /// to avoiding an error.
  Future<String> _autoNavigateSetLoginAndToken(
    BuildContext context,
    String token,
  ) async {
    await Future.delayed(
      const Duration(seconds: 1),
      () {
        var provider = context.read<PreferencesProvider>();
        provider.setLoginStatus(true);
        provider.setToken(token);

        context.go(ListStoryPage.path);
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
          child: Form(
            key: _formKey,
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
                const SizedBox(
                  height: 20,
                ),
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
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Bagikan kisah-kisah menarikmu melalui Story App!',
                          style: textStyle16,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: _controllerEmail,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    filled: true,
                    hintText: '...@....com',
                  ),
                  validator: (value) => FormValidateHelper.validateEmailAndDoNotEmpty(value),
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  controller: _controllerPassword,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    filled: true,
                  ),
                  validator: (value) => FormValidateHelper.validatePasswordAndDoNotEmpty(value),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyleHelper.elevatedButtonStyle,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _onLogin(context);
                    }
                  },
                  child: const Text('Sign In'),
                ),
                const SizedBox(
                  height: 20,
                ),
                ElevatedButton(
                  style: ButtonStyleHelper.elevatedButtonStyle,
                  onPressed: () => _navigateToSignupPage(context),
                  child: const Text('Sign Up'),
                ),
                FutureBuilder(
                  future: _snackBarLogin(context),
                  // show nothing while await showing error process (if error is true)
                  builder: (_, __) => const SizedBox.shrink(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// send (post) login data to API Service
  void _onLogin(BuildContext context) {
    final provider = context.read<LoginProvider>();
    provider.postLogin(
      email: _controllerEmail.text,
      password: _controllerPassword.text,
    );
  }

  void _navigateToSignupPage(BuildContext context) {
    kIsWeb ? context.go(SignupPage.path) : context.push(SignupPage.path);
  }

  /// show snackBar when [_buildLoginProgress] == ResultState.noData or ResultState.error
  /// delayed because we need to wait until UI building process is done,
  /// to avoiding an error.
  Future<String> _snackBarLogin(BuildContext context) async {
    await Future.delayed(
      const Duration(seconds: 1),
      () {
        final provider = context.read<LoginProvider>();
        final state = provider.state;
        final message = provider.message;

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
