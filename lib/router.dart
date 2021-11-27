import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pikitia/locator.dart';
import 'package:pikitia/services/routes_service.dart';
import 'package:pikitia/services/user_service.dart';
import 'package:pikitia/stacks/logged_in_stack.dart';
import 'package:pikitia/stacks/logged_out_stack.dart';

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

  bool handlePopPage(Route route, result) {
    if (!route.didPop(result)) return false;
    if (_currentRoute == Routes.camera) _routesService.goToHome();
    return true;
  }

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

  Widget loggedInRoutes() {
    return StreamBuilder<Routes>(
      stream: _routesStream,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          _currentRoute = snapshot.data!;
          List<Page> stack = LoggedInStack(route: _currentRoute).stack;
          return Navigator(
            key: navigatorKey,
            pages: stack,
            onPopPage: handlePopPage,
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
          List<Page> stack = LoggedOutStack(route: _currentRoute).stack;
          return Navigator(
            key: navigatorKey,
            pages: stack,
            onPopPage: handlePopPage,
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
