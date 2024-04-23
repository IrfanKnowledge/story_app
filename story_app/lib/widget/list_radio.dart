
import 'package:flutter/material.dart';

class ListRadio extends StatelessWidget {
  final String label;
  final EdgeInsets padding;
  final ThemeMode? groupValue;
  final ThemeMode value;
  final ValueChanged<ThemeMode> onChanged;

  const ListRadio({super.key, required this.onChanged, required this.label, required this.padding, required this.groupValue, required this.value});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      splashColor: colorScheme.primary.withOpacity(0.10),
      highlightColor: colorScheme.primary.withOpacity(0.10),
      onTap: () {
        if (value != groupValue) {
          onChanged(value);
        }
      },
      child: Padding(
        padding: padding,
        child: Row(
          children: [
            Radio<ThemeMode>(
              groupValue: groupValue,
              value: value,
              onChanged: (value) {
                onChanged(value!);
              },
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}