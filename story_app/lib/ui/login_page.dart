import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/string/string_data.dart';
import 'package:story_app/provider/login_provider.dart';
import 'package:story_app/provider/preferences_provider.dart';
import 'package:story_app/ui/signup_page.dart';
import 'package:story_app/utils/button_style_helper.dart';
import 'package:story_app/utils/form_validate_helper.dart';
import 'package:story_app/widget/center_loading.dart';

class LoginPage extends StatefulWidget {
  static const String goRoutePath = 'login';
  static bool isShowDialogTrue = true;

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _isPasswordHide = true;
  bool _isErrorMaybeShow = false;

  AppLocalizations? _appLocalizations;

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  void initState() {
    LoginPage.isShowDialogTrue = true;
    super.initState();
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
        final stateToken = provider.stateToken;
        final stateIsLogin = provider.stateIsLogin;

        bool isTokenNotEmpty = false;
        bool isLogin = false;

        Widget? result = stateToken.maybeWhen(
          loading: () => const CenterLoading(),
          loaded: (data) {
            if (data.isNotEmpty) {
              isTokenNotEmpty = true;
            }
            return null;
          },
          orElse: () => _buildLoginProgress(),
        );

        if (result != null) {
          return result;
        }

        result = stateIsLogin.maybeWhen(
          loading: () => const CenterLoading(),
          loaded: (data) {
            if (data) {
              isLogin = true;
            }
            return null;
          },
          orElse: () => _buildLoginProgress(),
        );

        if (result != null) {
          return result;
        }

        if (isTokenNotEmpty && isLogin) {
          _navigateIfLoginIsTrue();

          result = const CenterLoading();
        } else {
          result = _buildLoginProgress();
        }

        return result;
      },
    );
  }

  Widget _buildLoginProgress() {
    return Consumer<LoginProvider>(
      builder: (context, providerLogin, __) {
        final state = providerLogin.state;

        Widget result = state.maybeWhen(
          loading: () => const CenterLoading(),
          loaded: (data) {
            if (data.loginResult != null) {
              _autoNavigateSetLoginAndToken(
                context,
                data.loginResult!.token,
              );

              return const CenterLoading();
            }

            return _buildSafeAreaAndScrollView(
              child: _buildContainer(context),
            );
          },
          orElse: () {
            return _buildSafeAreaAndScrollView(
              child: _buildContainer(context),
            );
          },
        );

        return result;
      },
    );
  }

  SafeArea _buildSafeAreaAndScrollView({
    required Widget child,
  }) {
    return SafeArea(
      child: SingleChildScrollView(
        child: child,
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
            _buildIcon(),
            const Gap(20),
            ..._buildTextHeadLine(),
            const Gap(20),
            ..._buildForms(),
            const Gap(20),
            ..._buildButtons(context),
          ],
        ),
      ),
    );
  }

  CircleAvatar _buildIcon() {
    return const CircleAvatar(
      radius: 75,
      child: Icon(
        Icons.person,
        size: 125,
      ),
    );
  }

  List<Widget> _buildTextHeadLine() {
    const textStyle16 = TextStyle(fontSize: 16);

    Widget text1(String text) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: textStyle16,
        ),
      );
    }

    return [
      text1(_appLocalizations!.appSubtitle1(StringData.titleApp)),
      const Gap(10),
      text1(_appLocalizations!.appSubtitle2(StringData.titleApp)),
    ];
  }

  List<Widget> _buildForms() {
    return [
      _buildTextFormFieldEmail(),
      const Gap(10),
      _buildTextFormFieldPassword(),
    ];
  }

  TextFormField _buildTextFormFieldPassword() {
    return TextFormField(
      controller: _controllerPassword,
      obscureText: _isPasswordHide,
      decoration: InputDecoration(
        labelText: _appLocalizations!.password,
        border: const OutlineInputBorder(),
        filled: true,
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _isPasswordHide = !_isPasswordHide;
            });
          },
          icon: _isPasswordHide
              ? const Icon(Icons.visibility)
              : const Icon(Icons.visibility_off),
        ),
      ),
      validator: (value) =>
          FormValidateHelper.validatePasswordAndDoNotEmpty(value),
    );
  }

  TextFormField _buildTextFormFieldEmail() {
    return TextFormField(
      controller: _controllerEmail,
      decoration: InputDecoration(
        labelText: _appLocalizations!.email,
        border: const OutlineInputBorder(),
        filled: true,
        hintText: '...@....com',
      ),
      validator: (value) =>
          FormValidateHelper.validateEmailAndDoNotEmpty(value),
    );
  }

  List<Widget> _buildButtons(BuildContext context) {
    return [
      _buildButtonSignIn(context),
      const Gap(10),
      _buildRowTextOr(),
      const Gap(10),
      _buildButtonSignUp(context),
    ];
  }

  Row _buildRowTextOr() {
    return Row(
      children: [
        const Expanded(
          flex: 2,
          child: Divider(),
        ),
        Expanded(
          child: Text(
            _appLocalizations!.or,
            textAlign: TextAlign.center,
          ),
        ),
        const Expanded(
          flex: 2,
          child: Divider(),
        ),
      ],
    );
  }

  FilledButton _buildButtonSignIn(BuildContext context) {
    return FilledButton(
      style: ButtonStyleHelper.filledButtonStyle,
      onPressed: () {
        if (_formKey.currentState!.validate()) {
          _onLogin(context);
        }
      },
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.login),
          const Gap(5),
          Text(_appLocalizations!.signIn),
        ],
      ),
    );
  }

  ElevatedButton _buildButtonSignUp(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyleHelper.elevatedButtonStyle,
      onPressed: () => _navigateToSignupPage(context),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.app_registration),
          const Gap(5),
          Text(_appLocalizations!.signUp),
        ],
      ),
    );
  }

  void _navigateIfLoginIsTrue() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      LoginPage.isShowDialogTrue = false;
      context.go('/');
    });
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

  void _navigateToSignupPage(BuildContext context) {
    context.go('/${LoginPage.goRoutePath}/${SignupPage.goRouteName}');
  }

  void _autoFill() {
    _controllerEmail.text = 'NPC001@gmail.com';
    _controllerPassword.text = 'npc00001';
  }

  void _onLogin(BuildContext context) {
    final provider = context.read<LoginProvider>();

    _isErrorMaybeShow = true;

    provider.login(
      email: _controllerEmail.text,
      password: _controllerPassword.text,
    );
  }

  void _checkAndShowError(BuildContext context) {
    final provider = context.read<LoginProvider>();
    final state = provider.state;

    void showError(String message) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final snackBar = SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 1),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
    }

    if (_isErrorMaybeShow) {
      _isErrorMaybeShow = false;
      state.maybeWhen(
        loaded: (data) {
          data.loginResult == null ? showError(data.message) : null;
        },
        error: (message) => showError(message),
        orElse: () {},
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return _buildMultiProvider(
      builder: (context) {
        _appLocalizations = AppLocalizations.of(context);
        return _buildScaffold();
      },
    );
  }
}
