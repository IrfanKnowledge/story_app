import 'package:flutter/material.dart';

///
/// Memberikan text dengan tanda bintang merah,
/// yang biasanya digunakan pada halaman input data
///
class TextWithRedStar extends StatelessWidget {
  final String value;

  const TextWithRedStar({
    super.key,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          color: Theme.of(context).colorScheme.onSurface,
          fontSize: 14,
        ),
        children: <TextSpan>[
          TextSpan(
            text: value,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const TextSpan(
            text: ' *',
            style: TextStyle(color: Colors.red),
          ),
        ],
      ),
    );
  }
}
