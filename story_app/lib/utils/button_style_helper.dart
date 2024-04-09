import 'package:flutter/material.dart';

class ButtonStyleHelper {
  static ButtonStyle elevatedButtonStyle = ElevatedButton.styleFrom(
    minimumSize: const Size(
      double.infinity,
      40,
    ),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}
