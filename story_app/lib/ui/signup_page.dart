import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:story_app/provider/signup_provider.dart';
import 'package:story_app/ui/login_page.dart';
import 'package:story_app/utils/button_style_helper.dart';
import 'package:story_app/utils/form_validate_helper.dart';
import 'package:story_app/utils/future_helper.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/widget/center_loading.dart';
import 'package:story_app/widget/text_with_red_star.dart';

class SignupPage extends StatefulWidget {
  static const String goRouteName = 'signup';

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  bool _isCanPop = false;
  bool _isPasswordHide = true;
  bool _isErrorMaybeShow = false;

  @override
  void dispose() {
    _controllerName.dispose();
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
    final colorScheme = context.watch<MaterialThemeProvider>().currentSelected;

    return AppBar(
      title: const Text('Mendaftar'),
      backgroundColor: colorScheme.surfaceContainer,
      surfaceTintColor: colorScheme.surfaceContainer,
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
      const TextWithRedStar(value: 'Isi nama Anda'),
      const Gap(10),
      TextFormField(
        controller: _controllerName,
        decoration: const InputDecoration(
          labelText: 'Name',
          border: OutlineInputBorder(),
          filled: true,
        ),
        validator: (value) => FormValidateHelper.validateDoNotEmpty(value),
      )
    ];
  }

  List<Widget> _buildEmail() {
    return [
      const TextWithRedStar(value: 'Isi email Anda'),
      const Gap(10),
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
      )
    ];
  }

  List<Widget> _buildPassword() {
    return [
      const TextWithRedStar(value: 'Isi password Anda'),
      const Gap(10),
      TextFormField(
        controller: _controllerPassword,
        obscureText: _isPasswordHide,
        decoration: InputDecoration(
          labelText: 'Password',
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
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.app_registration),
            Gap(5),
            Text('Mendaftar'),
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

  void _onPopInvoked(BuildContext context, bool didPop) {
    if (!didPop) {
      FutureHelper.buildShowDialog1Auto(
        context: context,
        onFalsePressed: () => context.pop(),
        onTruePressed: () => _goToPreviousPage(context),
      );
    }
  }

  ///
  /// Jika proses mendaftar berhasil, maka memberikan pesan,
  /// kemudian berpindah halaman
  ///
  void _autoNavigateBack({required BuildContext context}) async {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Berhasil'),
        duration: Duration(seconds: 1),
      ));

      Future.delayed(
        const Duration(seconds: 2),
        () {
          _goToPreviousPage(context);
        },
      );
    });
  }

  ///
  /// Pergi ke halaman sebelumnya (dianggap melakukan aksi pop).
  /// Sebelum melakukan aksi pop, status [_isCanPop] diubah menjadi true
  /// untuk menghindari pemanggilan showDialog pada PopScope di bagian [build]
  ///
  void _goToPreviousPage(BuildContext context) {
    _isCanPop = true;
    context.go('/${LoginPage.goRoutePath}');
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
    return PopScope(
      onPopInvoked: (didPop) => _onPopInvoked(context, didPop),
      canPop: _isCanPop,
      child: _buildMultiProvider(
        builder: (context) {
          return _buildScaffold(context);
        },
      ),
    );
  }
}
