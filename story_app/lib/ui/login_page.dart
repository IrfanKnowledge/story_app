import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:story_app/data/api/api_service.dart';
import 'package:story_app/data/model/login_model.dart';
import 'package:story_app/provider/login_logout_provider.dart';
import 'package:story_app/ui/list_story_page.dart';
import 'package:story_app/utils/result_state_helper.dart';

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
    return Scaffold(
      body: _buildChangeNotifierProvider(),
    );
  }

  Widget _buildChangeNotifierProvider() {
    return ChangeNotifierProvider(
      create: (_) => LoginLogoutProvider(
        apiService: ApiService(),
      ),
      child: _buildLoginProgress(),
    );
  }

  Widget _buildLoginProgress() {
    return Consumer<LoginLogoutProvider>(
      builder: (context, provider, _) {
        if (provider.state == ResultState.loading) {
          print('state loading');
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else if (provider.state == ResultState.hasData) {
          print('state has data');

          /// using FutureBuilder.future to do automatic navigation,
          /// because Navigator.push can't be used inside return Widget(),
          /// Navigator.push not return a Widget(),
          /// that is why Navigator.push almost always used inside Button.onPress: () {} (no need to return a Widget())
          return FutureBuilder(
            future: _autoNavigate(context),
            builder: (_, __) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          );
        } else {
          print('state else...');
          return _buildSafeArea();
        }
      },
    );
  }

  /// automatic navigate if [_buildLoginProgress] == ResultState.hasData
  Future<String> _autoNavigate(BuildContext context) async {
    await Future.delayed(
      const Duration(seconds: 1),
      () {
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
    _controllerEmail.text = 'NPC002@gmail.com';
    _controllerPassword.text = 'npc00001';

    return Consumer<LoginLogoutProvider>(
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
                      Text('This is your First Text'),
                      SizedBox(height: 10),
                      Text('This is your Second Text'),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),
              _buildTextField(
                  labelText: 'Email',
                  hintText: '...@....com',
                  textEditingController: _controllerEmail),
              const SizedBox(height: 10),
              _buildTextField(
                  labelText: 'Password',
                  textEditingController: _controllerPassword),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(
                    double.infinity,
                    40,
                  ),
                ),
                onPressed: () {
                  provider.postLogin(
                    email: _controllerEmail.text,
                    password: _controllerPassword.text,
                  );

                  SnackBar? snackBar;
                  Duration duration = const Duration(seconds: 1);

                  if (provider.state == ResultState.noData || provider.state == ResultState.error) {
                    snackBar = SnackBar(
                      content: Text(provider.message),
                      duration: duration,
                    );
                  }

                  if (snackBar != null) {
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: const Text('Sign In'),
              ),
            ],
          ),
        );
      },
    );
  }

  TextField _buildTextField({
    bool obscureText = false,
    required String labelText,
    String hintText = '',
    required TextEditingController textEditingController,
  }) {
    return TextField(
      controller: textEditingController,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        border: const OutlineInputBorder(),
        filled: true,
        hintText: hintText,
      ),
    );
  }

  /// hapus penggunaan memori yang sudah tidak digunakan ketika halaman ini tertutup
  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }
}
