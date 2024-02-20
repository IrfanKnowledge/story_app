import 'package:flutter/material.dart';

class Test1Page extends StatelessWidget {
  const Test1Page({super.key});

  final String _text = 'Test 1 Page';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_text),
      ),
      body: Center(
        child: Text(
          _text,
          style: const TextStyle(
            fontSize: 24.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
