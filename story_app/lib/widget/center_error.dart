import 'package:flutter/material.dart';

class CenterError extends StatelessWidget {
  const CenterError({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(description),
    );
  }
}
