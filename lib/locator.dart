import 'package:get_it/get_it.dart';
import 'package:pikitia/services/piki_service.dart';
import 'package:pikitia/services/position_service.dart';


GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerLazySingleton(() => PositionService());
  locator.registerLazySingleton(() => PikiService());
}
