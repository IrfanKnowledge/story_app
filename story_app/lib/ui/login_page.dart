import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/main.dart';
import 'package:story_app/provider/login2_provider.dart';
import 'package:story_app/provider/login_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/ui/list_story_page.dart';
import 'package:story_app/ui/signup_page.dart';
import 'package:story_app/utils/button_style_helper.dart';
import 'package:story_app/utils/form_validate_helper.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/widget/center_loading.dart';

class LoginPage extends StatefulWidget {
  static const String path = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  Widget _buildMultiProvider({
    required Widget Function(BuildContext context) builder,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => LoginProvider(apiService: ApiService()),
        )
      ],
      builder: (context, _) => builder(context),
    );
  }

  Widget _buildScaffold() {
    return Scaffold(
      body: _buildIsLogin(),
    );
  }

  Widget _buildIsLogin() {
    return Consumer<PreferencesProvider>(
      builder: (context, provider, _) {
        final stateIsLogin = provider.stateIsLogin;
        final stateToken = provider.stateToken;
        final vIsLogin = provider.isLogin;
        final token = provider.token;

        print(
          'login_page, _buildIsLogin(), stateIsLogin: $stateIsLogin | stateToken: $stateToken | vIsLogin: $vIsLogin | token: $token',
        );

        if (stateIsLogin == ResultState.loading ||
            stateToken == ResultState.loading) {
          return const CenterLoading();
        } else if (vIsLogin && token.isNotEmpty) {
          _navigateIfLoginIsTrue();
          return const CenterLoading();
        }

        return _buildLoginProgress();
      },
    );
  }

  void _navigateIfLoginIsTrue() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.go('/');
    });
  }

  Widget _buildLoginProgress() {
    return Consumer<LoginProvider>(
      builder: (context, providerLogin, __) {
        if (providerLogin.state == ResultState.loading) {
          return const CenterLoading();
        } else if (providerLogin.state == ResultState.hasData) {
          _autoNavigateSetLoginAndToken(
            context,
            providerLogin.loginWrap.loginResult!.token,
          );

          return const CenterLoading();
        }

        return _buildSafeAreaAndScroll(context);
      },
    );
  }

  void _autoNavigateSetLoginAndToken(
    BuildContext context,
    String token,
  ) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = context.read<PreferencesProvider>();

      provider.setAndFetchToken(token);
      provider.setAndFetchLoginStatus(true);
    });
  }

  SafeArea _buildSafeAreaAndScroll(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: _buildContainer(context),
      ),
    );
  }

  Widget _buildContainer(BuildContext context) {
    _autoFill();
    _checkAndShowError(context);

    return Form(
      key: _formKey,
      child: Container(
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
            const CircleAvatar(
              radius: 75,
              child: Icon(
                Icons.person,
                size: 125,
              ),
            ),
            const Gap(20),
            ..._buildTextHeadLine(),
            const Gap(20),
            ..._buildFormEmailAndPassword(),
            const Gap(20),
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
          ],
        ),
      ),
    );
  }

  void _autoFill() {
    _controllerEmail.text = 'NPC001@gmail.com';
    _controllerPassword.text = 'npc00001';
  }

  List<Widget> _buildTextHeadLine() {
    const textStyle16 = TextStyle(fontSize: 16);

    return [
      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Selamat datang di Story App',
          style: textStyle16,
        ),
      ),
      const Gap(10),
      const Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Bagikan kisah-kisah menarikmu melalui Story App!',
          style: textStyle16,
        ),
      ),
    ];
  }

  List<Widget> _buildFormEmailAndPassword() {
    return [
      TextFormField(
        controller: _controllerEmail,
        decoration: const InputDecoration(
          labelText: 'Email',
          border: OutlineInputBorder(),
          filled: true,
          hintText: '...@....com',
        ),
        validator: (value) =>
            FormValidateHelper.validateEmailAndDoNotEmpty(value),
      ),
      const Gap(10),
      TextFormField(
        controller: _controllerPassword,
        obscureText: true,
        decoration: const InputDecoration(
          labelText: 'Password',
          border: OutlineInputBorder(),
          filled: true,
        ),
        validator: (value) =>
            FormValidateHelper.validatePasswordAndDoNotEmpty(value),
      ),
    ];
  }

  ///
  /// Mengirim data ke server
  ///
  void _onLogin(BuildContext context) {
    final provider = context.read<LoginProvider>();
    provider.postLogin(
      email: _controllerEmail.text,
      password: _controllerPassword.text,
    );
  }

  void _navigateToSignupPage(BuildContext context) {
    context.go('/login/signup');
  }

  void _checkAndShowError(BuildContext context) {
    final provider = context.read<LoginProvider>();
    final state = provider.state;
    final message = provider.message;

    if (state == ResultState.noData || state == ResultState.error) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final snackBar = SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        provider.setStateToNotStartedWithoutNotify();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildMultiProvider(builder: (_) => _buildScaffold());
  }
}
