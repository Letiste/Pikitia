import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

/// The radius in km in which the Pikis will be displayed
const double circleRadius = 5 * 1000;

/// The minimum distance in meters a device has to travel to update the location
const int distanceFilter = 5;

class PhotosMap extends StatefulWidget {
  const PhotosMap({Key? key}) : super(key: key);

  @override
  State<PhotosMap> createState() => _PhotosMapState();
}

class _PhotosMapState extends State<PhotosMap> {
  late CenterOnLocationUpdate _centerOnLocationUpdate;
  late StreamController<double> _centerCurrentLocationStreamController;
  late Stream<Position> _positionStream;

  @override
  void initState() {
    super.initState();
    _centerOnLocationUpdate = CenterOnLocationUpdate.always;
    _centerCurrentLocationStreamController = StreamController<double>();
    _positionStream = Geolocator.getPositionStream(
      desiredAccuracy: LocationAccuracy.bestForNavigation,
      distanceFilter: distanceFilter
    ).distinct();
  }

  @override
  void dispose() {
    _centerCurrentLocationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: LatLng(0, 0),
            zoom: 15,
            minZoom: 11.5,
            onPositionChanged: (MapPosition position, bool hasGesture) {
              if (hasGesture) {
                setState(() => _centerOnLocationUpdate = CenterOnLocationUpdate.never);
              }
            },
          ),
          children: [
            TileLayerWidget(
              options: TileLayerOptions(
                urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: ['a', 'b', 'c'],
              ),
            ),
            LocationMarkerLayerWidget(
              plugin: LocationMarkerPlugin(
                centerOnLocationUpdate: _centerOnLocationUpdate,
                centerCurrentLocationStream: _centerCurrentLocationStreamController.stream,
                locationOptions: const LocationOptions(
                  accuracy: LocationAccuracy.bestForNavigation,
                  distanceFilter: distanceFilter,
                ),
              ),
              options: LocationMarkerLayerOptions(
                marker: const DefaultLocationMarker(
                  color: Colors.blue,
                ),
              ),
            ),
            StreamBuilder<Position>(
              stream: _positionStream,
              builder: (context, snapshot) {
                if (snapshot.data != null) {
                  return CircleLayerWidget(
                    options: CircleLayerOptions(
                      circles: [
                        CircleMarker(
                          point: LatLng(snapshot.data!.latitude, snapshot.data!.longitude),
                          radius: circleRadius,
                          color: Colors.transparent,
                          borderColor: Colors.red,
                          borderStrokeWidth: 2,
                          useRadiusInMeter: true,
                        )
                      ],
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ],
        ),
        Positioned(
          right: 20,
          bottom: 80,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            onPressed: () {
              setState(() => _centerOnLocationUpdate = CenterOnLocationUpdate.always);
              _centerCurrentLocationStreamController.add(15);
            },
            child: const Icon(
              Icons.my_location,
              color: Colors.black,
              size: 36,
            ),
          ),
        ),
      ],
    );
  }
}
