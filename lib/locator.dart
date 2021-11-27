import 'package:get_it/get_it.dart';
import 'package:pikitia/services/pikit_service.dart';
import 'package:pikitia/services/position_service.dart';
import 'package:pikitia/services/routes_service.dart';


GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => PositionService());
  locator.registerLazySingleton(() => PikitService());
  locator.registerLazySingleton(() => RoutesService());
}
