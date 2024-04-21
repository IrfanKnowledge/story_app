
import 'package:flutter/material.dart';

class SettingsPage extends StatefulWidget {
  static const String goRouteName = 'settings_page';
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {

  Scaffold _buildScaffold() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setelan'),
      ),
      body: const Center(child: Text('Halamana Setelan'),),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildScaffold();
  }
}