import 'package:flutter/material.dart';
import 'package:pikitia/pages/login_page.dart';
import 'package:pikitia/pages/register_page.dart';
import 'package:pikitia/services/routes_service.dart';

class LoggedOutStack {
  LoggedOutStack({required this.route});

  final Routes route;

  List<Page> get stack {
    return [
      RegisterPage(),
      if (route == Routes.login) LoginPage(),
    ];
  }
}
