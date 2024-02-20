import 'package:flutter/material.dart';

class Test3Page extends StatelessWidget {
  const Test3Page({super.key});

  final String text = 'Test 3 Page';

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
