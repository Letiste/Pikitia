import 'package:flutter/material.dart';
import 'package:pikitia/services/routes_service.dart';

abstract class PagesStack {
  List<Page> get stack;
  bool handlePopPage(Route route, result, RoutesService routesService);
}
