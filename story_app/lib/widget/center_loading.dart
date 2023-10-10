import 'package:flutter/material.dart';

class CenterLoading extends StatelessWidget {
  const CenterLoading({super.key});

  @override
  Widget build(BuildContext context) {
    /// show loading
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
