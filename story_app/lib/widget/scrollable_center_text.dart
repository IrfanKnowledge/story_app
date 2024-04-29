import 'package:flutter/material.dart';

///
/// Berfungsi agar penggunaan [RefreshIndicator] bisa tetap berjalan dengan baik.
/// Walaupun list sedang kosong.
///
class ScrollableCenterText extends StatelessWidget {
  final String _text;

  const ScrollableCenterText({
    super.key,
    required String text,
  }) : _text = text;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
            ),
            child: Center(child: Text(_text)),
          ),
        );
      },
    );
  }
}
