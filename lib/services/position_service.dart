import 'package:geolocator/geolocator.dart';

/// The minimum distance in meters a device has to travel to update the location
const int distanceFilter = 5;

const LocationAccuracy locationAccuracy = LocationAccuracy.bestForNavigation;

class PositionService {
  PositionService() {
    _positionStream =
        Geolocator.getPositionStream(desiredAccuracy: locationAccuracy, distanceFilter: distanceFilter)
            .distinct()
            .asBroadcastStream();
  }

  late Stream<Position> _positionStream;

  Stream<Position> watchCurrentPosition() {
    return _positionStream;
  }

  Future<Position> getCurrentPosition() async {
    return await Geolocator.getCurrentPosition(desiredAccuracy: locationAccuracy);
  }
}
