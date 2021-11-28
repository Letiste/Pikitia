import 'package:flutter/material.dart';

class ButtonActionSecondary extends StatelessWidget {
  const ButtonActionSecondary({required this.text, required this.handleOnPressed, Key? key}) : super(key: key);

  final String text;
  final void Function() handleOnPressed;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: handleOnPressed,
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(letterSpacing: 1),
      ),
    );
  }
}
