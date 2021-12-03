import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pikitia/locator.dart';
import 'package:pikitia/services/routes_service.dart';
import 'package:pikitia/services/user_service.dart';
import 'package:pikitia/stacks/logged_in_stack.dart';
import 'package:pikitia/stacks/logged_out_stack.dart';
import 'package:pikitia/stacks/pages_stack.dart';

class PikitiaRouterDelegate extends RouterDelegate with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  PikitiaRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>() {
    _routesService = locator<RoutesService>();
    _routesStream = _routesService.watchRoutes();
    _isLoggedInStream = locator<UserService>().isLoggedIn();
  }

  final GlobalKey<NavigatorState> _navigatorKey;
  late RoutesService _routesService;
  late Stream<Routes> _routesStream;
  late Stream<bool> _isLoggedInStream;
  late Routes _currentRoute;

  @override
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: _isLoggedInStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data!) {
            return loggedInRoutes();
          } else {
            return loggedOutRoutes();
          }
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

// TODO: #46 replace with a routes builder with passing class construtor in function argument (coming in Dart 2.15)
  Widget loggedInRoutes() {
    return StreamBuilder<Routes>(
      stream: _routesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _currentRoute = snapshot.data!;
          PagesStack pagesStack = LoggedInStack(currentRoute: _currentRoute);
          return Navigator(
            key: navigatorKey,
            pages: pagesStack.stack,
            onPopPage: (route, result) => pagesStack.handlePopPage(route, result, _routesService),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  Widget loggedOutRoutes() {
    return StreamBuilder<Routes>(
      stream: _routesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _currentRoute = snapshot.data!;
          PagesStack pagesStack = LoggedOutStack(currentRoute: _currentRoute);
          return Navigator(
            key: navigatorKey,
            pages: pagesStack.stack,
            onPopPage: (route, result) => pagesStack.handlePopPage(route, result, _routesService),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }
}
