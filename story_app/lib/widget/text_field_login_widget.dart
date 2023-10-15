import 'package:flutter/material.dart';

class TextFieldLoginWidget extends StatelessWidget {
  final bool obscureText;
  final String labelText;
  final String hintText;
  final TextEditingController textEditingController;

  const TextFieldLoginWidget({
    super.key,
    this.obscureText = false,
    required this.labelText,
    this.hintText = '',
    required this.textEditingController,
  });

  @override
  Widget build(BuildContext context) {
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
}
