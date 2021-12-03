import 'package:flutter/material.dart';
import 'package:pikitia/pages/camera_page.dart';
import 'package:pikitia/pages/home_page.dart';
import 'package:pikitia/pages/user_liked_pikits_page.dart';
import 'package:pikitia/pages/user_pikits_page.dart';
import 'package:pikitia/services/routes_service.dart';
import 'package:pikitia/stacks/pages_stack.dart';

class LoggedInStack extends PagesStack {
  LoggedInStack({required this.currentRoute});

  final Routes currentRoute;

  @override
  List<Page> get stack {
    return [
      HomePage(),
      if (currentRoute == Routes.camera) CameraPage(),
      if (currentRoute == Routes.userPikits) UserPikitsPage(),
      if (currentRoute == Routes.userLikedPikits) UserLikedPikitsPage(),
    ];
  }

  @override
  bool handlePopPage(Route route, result, RoutesService routesService) {
    if (!route.didPop(result)) return false;
    if (currentRoute == Routes.camera) routesService.goToHome();
    if (currentRoute == Routes.userPikits) routesService.goToHome();
    if (currentRoute == Routes.userLikedPikits) routesService.goToHome();
    return true;
  }
}
