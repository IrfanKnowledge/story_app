import 'package:flutter/material.dart';

///
/// Memberikan text dengan tanda bintang merah,
/// yang biasanya digunakan pada halaman input data
///
class TextWithRedStar extends StatelessWidget {
  final String value;
  final TextStyle textStyle;

  const TextWithRedStar({
    super.key,
    required this.value,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: textStyle,
        children: <TextSpan>[
          TextSpan(
            text: value,
            style: textStyle,
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
