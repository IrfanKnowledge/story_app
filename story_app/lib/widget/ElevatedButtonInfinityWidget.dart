import 'package:flutter/material.dart';

class ElevatedButtonInfinityWidget extends StatelessWidget {
  final String text;
  final void Function() onTap;

  const ElevatedButtonInfinityWidget({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(
          double.infinity,
          40,
        ),
      ),
      onPressed: onTap,
      child: Text(text),
    );
  }
}
