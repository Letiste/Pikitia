import 'package:flutter/material.dart';
import 'package:pikitia/screens/login_screen.dart';

class LoginPage extends Page {
  const LoginPage() : super(key: const ValueKey('LoginPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(settings: this, builder: (context) => LoginScreen());
  }
}
