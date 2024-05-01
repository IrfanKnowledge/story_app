import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/common/color_scheme/theme.dart';
import 'package:story_app/common/common.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:story_app/provider/signup_provider.dart';
import 'package:story_app/utils/button_style_helper.dart';
import 'package:story_app/utils/form_validate_helper.dart';
import 'package:story_app/widget/center_loading.dart';
import 'package:story_app/widget/text_with_red_star.dart';

class SignupPage extends StatefulWidget {
  static const String goRouteName = 'signup';
  static bool isShowDialogTrue = true;

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  TextStyle? _textStyleSubTitle;

  MaterialScheme? _colorSchemeCustom;
  TextTheme? _textTheme;

  bool _isPasswordHide = true;
  bool _isErrorMaybeShow = false;

  AppLocalizations? _appLocalizations;

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  void _initStyle(BuildContext context) {
    _textStyleSubTitle = _textTheme!.titleSmall?.copyWith(
      color: _colorSchemeCustom!.onSurface,
      fontWeight: FontWeight.bold,
    );
  }


  @override
  void initState() {
    SignupPage.isShowDialogTrue = true;
    super.initState();
  }

  Widget _buildMultiProvider({
    required Widget Function(BuildContext context) builder,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => SignupProvider(apiService: ApiService()),
        )
      ],
      builder: (context, _) => builder(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(context),
      body: _buildSafeAreaWithScrollView(
        child: _buildContainer(context),
      ),
    );
  }

  AppBar _buildAppBar(BuildContext context) {
    final colorSchemeCustom =
        context.watch<MaterialThemeProvider>().currentSelected;

    return AppBar(
      title: Text(_appLocalizations!.signUp),
      backgroundColor: colorSchemeCustom.surfaceContainer,
      surfaceTintColor: colorSchemeCustom.surfaceContainer,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSafeAreaWithScrollView({
    required Widget child,
  }) {
    return SafeArea(
      child: SingleChildScrollView(
        child: child,
      ),
    );
  }

  Widget _buildContainer(BuildContext context) {
    _checkAndShowError(context);

    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ..._buildName(),
            const Gap(10),
            ..._buildEmail(),
            const Gap(10),
            ..._buildPassword(),
            const Gap(20),
            _buildButtonSignUp(context),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildName() {
    return [
      TextWithRedStar(
        value: _appLocalizations!.fillInYourXForm(
          _appLocalizations!.name.toLowerCase(),
        ),
        textStyle: _textStyleSubTitle!,
      ),
      const Gap(10),
      TextFormField(
        controller: _controllerName,
        decoration: InputDecoration(
          labelText: _appLocalizations!.name,
          border: const OutlineInputBorder(),
          filled: true,
        ),
        validator: (value) => FormValidateHelper.validateDoNotEmpty(value),
      )
    ];
  }

  List<Widget> _buildEmail() {
    return [
      TextWithRedStar(
        value: _appLocalizations!.fillInYourXForm(
          _appLocalizations!.email.toLowerCase(),
        ),
        textStyle: _textStyleSubTitle!,
      ),
      const Gap(10),
      TextFormField(
        controller: _controllerEmail,
        decoration: InputDecoration(
          labelText: _appLocalizations!.email,
          border: const OutlineInputBorder(),
          filled: true,
          hintText: '...@....com',
        ),
        validator: (value) =>
            FormValidateHelper.validateEmailAndDoNotEmpty(value),
      )
    ];
  }

  List<Widget> _buildPassword() {
    return [
      TextWithRedStar(
        value: _appLocalizations!.fillInYourXForm(
          _appLocalizations!.password.toLowerCase(),
        ),
        textStyle: _textStyleSubTitle!,
      ),
      const Gap(10),
      TextFormField(
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
      )
    ];
  }

  Widget _buildButtonSignUp(BuildContext context) {
    final state = context.watch<SignupProvider>().state;

    Widget loading() => const CenterLoading();

    Widget filledButton() {
      return FilledButton(
        style: ButtonStyleHelper.filledButtonStyle,
        onPressed: () {
          if (_formKey.currentState!.validate()) {
            _signup(context);
            // _autoNavigateBack(context: context);
          }
        },
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

    final Widget result = state.maybeWhen(
      loading: () => loading(),
      loaded: (data) {
        _autoNavigateBack(context: context);

        return loading();
      },
      orElse: () => filledButton(),
    );

    return result;
  }

  ///
  /// Jika proses mendaftar berhasil, maka memberikan pesan,
  /// kemudian berpindah halaman
  ///
  void _autoNavigateBack({required BuildContext context}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_appLocalizations!.succeed),
        duration: const Duration(seconds: 1),
      ));

      Future.delayed(
        const Duration(seconds: 2),
        () {
          SignupPage.isShowDialogTrue = false;
          context.pop();
        },
      );
    });
  }

  void _checkAndShowError(BuildContext context) {
    final provider = context.read<SignupProvider>();
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
        error: (message) => showError(message),
        orElse: () {},
      );
    }
  }

  void _signup(BuildContext context) {
    final provider = context.read<SignupProvider>();
    _isErrorMaybeShow = true;

    provider.signup(
      name: _controllerName.text,
      email: _controllerEmail.text,
      password: _controllerPassword.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    _colorSchemeCustom = context.read<MaterialThemeProvider>().currentSelected;
    _textTheme = Theme.of(context).textTheme;

    _initStyle(context);

    return _buildMultiProvider(
      builder: (context) {
        _appLocalizations = AppLocalizations.of(context);
        return _buildScaffold(context);
      },
    );
  }
}
