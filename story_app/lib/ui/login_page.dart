import 'package:flutter/material.dart';
import 'package:story_app/ui/list_story_page.dart';

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
      body: SafeArea(
        child: SingleChildScrollView(
          child: _buildContainer(),
        ),
      ),
    );
  }

  Widget _buildContainer() {
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
              labelText: 'Password', textEditingController: _controllerEmail),
          const SizedBox(height: 20),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 40)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ListStoryPage(),
                ),
              );
            },
            child: const Text('Sign In'),
          ),
        ],
      ),
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
