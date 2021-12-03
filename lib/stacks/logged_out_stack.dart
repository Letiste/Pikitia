import 'package:flutter/material.dart';
import 'package:pikitia/pages/login_page.dart';
import 'package:pikitia/pages/register_page.dart';
import 'package:pikitia/services/routes_service.dart';
import 'package:pikitia/stacks/pages_stack.dart';

class LoggedOutStack extends PagesStack {
  LoggedOutStack({required this.currentRoute});

  final Routes currentRoute;

  @override
  List<Page> get stack {
    return [
      RegisterPage(),
      if (currentRoute == Routes.login) LoginPage(),
    ];
  }

  @override
  bool handlePopPage(Route route, result, RoutesService routesService) {
    if (!route.didPop(result)) return false;
    return true;
  }
}
