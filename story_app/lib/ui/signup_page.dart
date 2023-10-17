import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/provider/signup_provider.dart';
import 'package:story_app/ui/login_page.dart';
import 'package:story_app/utils/button_style_helper.dart';
import 'package:story_app/utils/form_validate_helper.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/widget/center_loading.dart';

class SignupPage extends StatefulWidget {
  static const path = '/signup';

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _controllerName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _buildChangeNotifierProvider();
  }

  Widget _buildChangeNotifierProvider() {
    return ChangeNotifierProvider(
      create: (context) => SignupProvider(
        ApiService(),
      ),
      child: _buildScaffold(),
    );
  }

  Widget _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
      ),
      body: _buildSignupProgress(),
    );
  }

  Widget _buildSignupProgress() {
    return Consumer<SignupProvider>(
      builder: (context, provider, _) {
        // if state is loading (fetching signup response from API Service)
        if (provider.state == ResultState.loading) {
          // show loading
          return const CenterLoading();
          // if state is has data
        } else if (provider.state == ResultState.hasData) {
          // auto navigate back to previous page
          return FutureBuilder(
            future: _autoNavigateBack(context: context),
            // show loading while await auto navigate back process
            builder: (_, __) => const CenterLoading(),
          );
        }

        return _buildSafeAreaWithScrollView();
      },
    );
  }

  /// Auto navigate back to previous page,
  /// show 'success' message.
  /// Delayed because we need to wait until UI building process is done,
  /// to avoiding an error.
  Future<String> _autoNavigateBack({required BuildContext context}) async {
    Future.delayed(
      const Duration(
        seconds: 1,
      ),
      () {
        ScaffoldMessenger.of(context).showSnackBar(
          snackBar('Berhasil'),
        );
      },
    );
    Future.delayed(
      const Duration(
        seconds: 3,
      ),
      () {
        kIsWeb ? context.go(LoginPage.path) : context.pop();
      },
    );
    return 'loading...';
  }

  SnackBar snackBar(String message) {
    return SnackBar(
      content: Text(message),
      duration: const Duration(
        seconds: 1,
      ),
    );
  }

  Widget _buildSafeAreaWithScrollView() {
    return SafeArea(
      child: SingleChildScrollView(
        child: _buildConsumer(),
      ),
    );
  }

  Widget _buildConsumer() {
    return Consumer<SignupProvider>(
      builder: (context, _, __) => _buildContainer(context),
    );
  }

  Widget _buildContainer(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              controller: _controllerName,
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
                filled: true,
              ),
              validator: (value) => FormValidateHelper.validateDoNotEmpty(value),
            ),
            const SizedBox(
              height: 10,
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
              height: 10,
            ),
            ElevatedButton(
              style: ButtonStyleHelper.elevatedButtonStyle,
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _signup(context);
                }
              },
              child: const Text('Sign Up'),
            ),
            FutureBuilder(
              future: _snackBarSignup(context),
              builder: (_, __) => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }

  void _signup(BuildContext context) {
    final provider = context.read<SignupProvider>();
    provider.signup(
      name: _controllerName.text,
      email: _controllerEmail.text,
      password: _controllerPassword.text,
    );
  }

  /// show message if signup response is error
  /// delayed because we need to wait until UI building process is done,
  /// to avoiding an error.
  Future<String> _snackBarSignup(BuildContext context) async {
    await Future.delayed(
      const Duration(seconds: 1),
      () {
        final provider = context.read<SignupProvider>();
        final state = provider.state;
        final message = provider.message;

        if (state == ResultState.error) {
          ScaffoldMessenger.of(context).showSnackBar(
            snackBar(message),
          );
        }
      },
    );
    return 'loading...';
  }

  /// hapus penggunaan memori yang sudah tidak digunakan ketika halaman ini tertutup
  @override
  void dispose() {
    _controllerName.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
