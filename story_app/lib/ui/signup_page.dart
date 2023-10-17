import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/provider/signup_provider.dart';
import 'package:story_app/utils/result_state_helper.dart';
import 'package:story_app/widget/ElevatedButtonInfinityWidget.dart';
import 'package:story_app/widget/center_loading.dart';
import 'package:story_app/widget/text_field_login_widget.dart';

class SignupPage extends StatefulWidget {
  static const path = '/signup';

  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
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
        if (provider.state == ResultState.loading) {
          return const CenterLoading();
        } else if (provider.state == ResultState.hasData) {
          return FutureBuilder(
            future: _autoNavigateBack(context: context),
            builder: (_, __) => const CenterLoading(),
          );
        }

        return _buildSafeAreaWithScrollView();
      },
    );
  }

  Future<String> _autoNavigateBack({required BuildContext context}) async {
    Future.delayed(
      const Duration(
        seconds: 2,
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
        // Navigator.pop(context);
        context.pop();
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
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextFieldLoginWidget(
            labelText: 'Name',
            textEditingController: _controllerName,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFieldLoginWidget(
            labelText: 'Email',
            hintText: '...@..com',
            textEditingController: _controllerEmail,
          ),
          const SizedBox(
            height: 10,
          ),
          TextFieldLoginWidget(
            obscureText: true,
            labelText: 'Password',
            textEditingController: _controllerPassword,
          ),
          const SizedBox(
            height: 10,
          ),
          ElevatedButtonInfinityWidget(
            text: 'Sign Up',
            onTap: () => _signup(context),
          ),
          FutureBuilder(
            future: _snackBarLogin(context),
            builder: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  void _signup(BuildContext context) {
    if (_controllerName.text.isEmpty ||
        _controllerEmail.text.isEmpty ||
        _controllerPassword.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar('Data tidak boleh kosong'),
      );
      return;
    }

    if (_controllerPassword.text.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        snackBar('Password tidak boleh kurang dari 8'),
      );
      return;
    }

    final provider = context.read<SignupProvider>();
    provider.signup(
      name: _controllerName.text,
      email: _controllerEmail.text,
      password: _controllerPassword.text,
    );
  }

  /// delayed because we need to wait until UI building process is done,
  /// to avoiding an error.
  Future<String> _snackBarLogin(BuildContext context) async {
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

  @override
  void dispose() {
    _controllerName.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
