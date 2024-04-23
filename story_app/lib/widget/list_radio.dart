
import 'package:flutter/material.dart';

// class ListRadio<T> extends StatelessWidget {
//   final String label;
//   final EdgeInsets padding;
//   final T groupValue;
//   final T value;
//   final ValueChanged<T> onChanged;
//
//   const ListRadio({super.key, required this.onChanged, required this.label, required this.padding, required this.groupValue, required this.value});
//
//   @override
//   Widget build(BuildContext context) {
//     final colorScheme = Theme.of(context).colorScheme;
//
//     return InkWell(
//       splashColor: colorScheme.primary.withOpacity(0.10),
//       highlightColor: colorScheme.primary.withOpacity(0.10),
//       onTap: () {
//         if (value != groupValue) {
//           onChanged(value);
//         }
//       },
//       child: Padding(
//         padding: padding,
//         child: Row(
//           children: [
//             Radio<T>(
//               groupValue: groupValue,
//               value: value,
//               onChanged: (value) {
//                 onChanged(value as T);
//               },
//             ),
//             Text(label),
//           ],
//         ),
//       ),
//     );
//   }
// }

class ListRadio<T> extends StatelessWidget {
  final String label;
  final EdgeInsets padding;
  final T groupValue;
  final T value;
  final ValueChanged<T> onChanged;

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
            Radio<T>(
              groupValue: groupValue,
              value: value,
              onChanged: (value) {
                onChanged(value as T);
              },
            ),
            Text(label),
          ],
        ),
      ),
    );
  }
}