import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pikitia/locator.dart';
import 'package:pikitia/services/routes_service.dart';
import 'package:pikitia/stacks/logged_in_stack.dart';

class PikitiaRouterDelegate extends RouterDelegate with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  PikitiaRouterDelegate() : _navigatorKey = GlobalKey<NavigatorState>() {
    _routesService = locator<RoutesService>();
    _routesStream = _routesService.watchRoutes();
  }

  final GlobalKey<NavigatorState> _navigatorKey;
  late RoutesService _routesService;
  late Stream<Routes> _routesStream;
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

  @override
  Future<void> setNewRoutePath(configuration) {
    throw UnimplementedError();
  }
}
