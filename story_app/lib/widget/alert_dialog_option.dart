import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:story_app/widget/list_radio.dart';

class AlertDialogOption<T> extends StatefulWidget {
  final String titleAlertDialog;
  final double height;
  final T groupedValue;
  final List<T> listValue;
  final List<String> listLabel;
  final String textCancel;
  final void Function(BuildContext context, T value)? onTruePressed;

  const AlertDialogOption({
    super.key,
    required this.titleAlertDialog,
    required this.height,
    required this.groupedValue,
    required this.listValue,
    required this.listLabel,
    required this.textCancel,
    this.onTruePressed,
  });

  @override
  State<AlertDialogOption<T>> createState() => _AlertDialogOptionState<T>();
}

class _AlertDialogOptionState<T> extends State<AlertDialogOption<T>> {
  late T _groupedValue;

  @override
  void initState() {
    _groupedValue = widget.groupedValue;
    print('_groupedValue = $_groupedValue');
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.titleAlertDialog),
      content: SizedBox(
        height: widget.height,
        width: 100,
        child: ListView.builder(
          itemBuilder: (context, index) {
            return ListRadio<T>(
              onChanged: (value) {
                setState(() {
                  _groupedValue = value;
                });
              },
              label: widget.listLabel[index],
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              groupValue: _groupedValue,
              value: widget.listValue[index],
            );
          },
          itemCount: widget.listValue.length,
        ),
      ),
      contentPadding:
          const EdgeInsets.symmetric(horizontal: 0.0, vertical: 16.0),
      actions: [
        TextButton(
          onPressed: () => context.pop(),
          child: Text(widget.textCancel),
        ),
        TextButton(
          onPressed: () {
            if (widget.onTruePressed != null) {
              widget.onTruePressed!(context, _groupedValue);
            }
          },
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
