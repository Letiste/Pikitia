import 'dart:async';

enum Routes { home, camera, register, login, userPikits }

class RoutesService {
  RoutesService() {
    _routesStreamController = StreamController<Routes>();
    _routesStream = _routesStreamController.stream;
    _routesStreamController.sink.add(Routes.home);
  }

  late final StreamController<Routes> _routesStreamController;
  late final Stream<Routes> _routesStream;

  Stream<Routes> watchRoutes() {
    return _routesStream;
  }

  void goToHome() {
    _routesStreamController.sink.add(Routes.home);
  }

  void goToCamera() {
    _routesStreamController.sink.add(Routes.camera);
  }

  void goToRegister() {
    _routesStreamController.sink.add(Routes.register);
  }

  void goToLogin() {
    _routesStreamController.sink.add(Routes.login);
  }

  void goToUserPikits() {
    _routesStreamController.sink.add(Routes.userPikits);
  }
}
