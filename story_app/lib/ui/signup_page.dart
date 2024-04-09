import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/provider/material_theme_provider.dart';
import 'package:story_app/provider/signup_provider.dart';
import 'package:story_app/ui/login_page.dart';
import 'package:story_app/utils/form_validate_helper.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/widget/center_loading.dart';

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

  bool _isButtonSignUpExecuted = false;
  bool _isPasswordHide = true;
  bool _isCanPop = false;

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
          create: (context) => SignupProvider(ApiService()),
        )
      ],
      builder: (context, _) => builder(context),
    );
  }

  Widget _buildScaffold(BuildContext context) {
    final colorScheme = context.watch<MaterialThemeProvider>().currentSelected;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
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
      ),
      body: _buildSafeAreaWithScrollView(
        child: _buildContainer(context),
      ),
    );
  }

  Widget _buildSafeAreaWithScrollView({required Widget child}) {
    return SafeArea(
      child: SingleChildScrollView(
        child: child,
      ),
    );
  }

  Widget _buildContainer(BuildContext context) {
    _snackBarSignup(context);
    // _test1();

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
            _buildButton(context),
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
          suffix: IconButton(
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

  ///
  /// Menampilkan button atau proses loading jika pengguna menekannya
  ///
  Widget _buildButton(BuildContext context) {
    Widget result;

    final filledButton = FilledButton(
      style: FilledButton.styleFrom(
        minimumSize: const Size(
          double.infinity,
          40,
        ),
      ),
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
          Text('Sign Up'),
        ],
      ),
    );

    final state = context.watch<SignupProvider>().state;
    const loading = CenterLoading();

    if (state == ResultState.loading) {
      result = loading;
    } else if (state == ResultState.hasData) {
      _autoNavigateBack(context: context);

      result = loading;
    } else {
      result = filledButton;
    }

    return result;
  }

  ///
  /// Mengirimkan data pendaftaran ke server
  ///
  void _signup(BuildContext context) {
    final provider = context.read<SignupProvider>();
    _isButtonSignUpExecuted = true;

    provider.signup(
      name: _controllerName.text,
      email: _controllerEmail.text,
      password: _controllerPassword.text,
    );
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
          _goToOtherPage(context);
        },
      );
    });
  }

  ///
  /// Pergi ke halaman tertentu.
  /// Sebelum pergi, status [_isCanPop] diubah menjadi true
  /// untuk menghindari pemanggilan showDialog pada PopScope di bagian [build]
  ///
  void _goToOtherPage(BuildContext context) {
    _isCanPop = true;
    context.go('/${LoginPage.goRoutePath}');
  }

  ///
  /// Memberikan pesan ketika terjadi error
  ///
  void _snackBarSignup(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final provider = context.read<SignupProvider>();
      final state = provider.state;
      final message = provider.message;

      if (_isButtonSignUpExecuted == true && state == ResultState.error) {
        _isButtonSignUpExecuted = false;

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(message),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvoked: (didPop) {
        const title = 'Keluar dari Halaman Ini';
        const content = 'Apakah Anda yakin ingin keluar dari halaman ini?';
        const textOnFalse = 'Tidak';
        const textOnTrue = 'Ya, keluar dari halaman ini';

        if (!didPop) {
          showDialog(
            context: context,
            builder: (context) {
              return AlertDialog(
                title: const Text(
                  title,
                  textAlign: TextAlign.center,
                ),
                content: const Text(content, textAlign: TextAlign.center),
                actionsAlignment: MainAxisAlignment.center,
                actions: [
                  TextButton(
                    onPressed: () => context.pop(),
                    child: const Text(textOnFalse),
                  ),
                  TextButton(
                    onPressed: () {
                      _goToOtherPage(context);
                    },
                    child: const Text(textOnTrue),
                  ),
                ],
              );
            },
          );
        }
      },
      canPop: _isCanPop,
      child: _buildMultiProvider(
        builder: (context) {
          return _buildScaffold(context);
        },
      ),
    );
  }

  void _test1() {
    _controllerName.text = 'npc5';
    _controllerEmail.text = 'npc5@gmail.com';
    _controllerPassword.text = '1234567890';
  }
}

///
/// Memberikan text dengan tanda bintang merah,
/// yang biasanya digunakan pada halaman input data
///
class TextWithRedStar extends StatelessWidget {
  final String value;

  const TextWithRedStar({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 14,
        ),
        children: <TextSpan>[
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(text: ' *', style: TextStyle(color: Colors.red)),
        ],
      ),
    );
  }
}
