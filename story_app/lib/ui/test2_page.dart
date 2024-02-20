import 'package:flutter/material.dart';

class Test2Page extends StatelessWidget {
  const Test2Page({super.key});

  final String text = 'Test 2 Page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(text),
      ),
      body: Center(
        child: Text(
          text,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
