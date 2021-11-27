import 'package:flutter/material.dart';
import 'package:pikitia/pages/camera_page.dart';
import 'package:pikitia/pages/home_page.dart';
import 'package:pikitia/services/routes_service.dart';

class LoggedInStack {
  LoggedInStack({required this.route});

  final Routes route;

  List<Page> get stack {
    return [
      HomePage(),
      if (route == Routes.camera) CameraPage(),
    ];
  }
}
