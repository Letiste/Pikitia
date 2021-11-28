import 'package:flutter/material.dart';

class ButtonActionPrimary extends StatelessWidget {
  const ButtonActionPrimary({required this.text, required this.handlePressed, Key? key}) : super(key: key);

  final String text;
  final void Function() handlePressed;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Theme.of(context).primaryColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(8),
        ),
      ),
      child: Text(
        text.toUpperCase(),
        style: const TextStyle(
          color: Colors.white,
          letterSpacing: 1,
          fontWeight: FontWeight.w700,
          fontSize: 16,
        ),
      ),
      onPressed: handlePressed,
    );
  }
}
