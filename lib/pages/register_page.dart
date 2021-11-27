import 'package:flutter/material.dart';
import 'package:pikitia/screens/register_screen.dart';

class RegisterPage extends Page {
  const RegisterPage() : super(key: const ValueKey('RegisterPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(settings: this, builder: (context) => RegisterScreen());
  }
}
