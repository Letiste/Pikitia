import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:pikitia/models/pikit.dart';
import 'package:pikitia/services/pikit_service.dart';
import 'package:pikitia/services/position_service.dart';
import 'package:pikitia/widgets/pikit_preview.dart';
import '../locator.dart';

/// The radius in km in which the Pikits will be displayed
const double circleRadius = 5 * 1000;

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
    _positionStream = locator<PositionService>().watchCurrentPosition();
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
                  var pikitsStream = locator<PikitService>().watchPikits(snapshot.data!);
                  return Stack(
                    children: [
                      CircleLayerWidget(
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
                      ),
                      StreamBuilder<List<Pikit>>(
                        stream: pikitsStream,
                        builder: (context, snapshot) {
                          if (snapshot.data != null) {
                            var pikitMarkers = snapshot.data!.map(buildPikitMarker).toList();
                            return MarkerClusterLayerWidget(
                                options: MarkerClusterLayerOptions(
                              maxClusterRadius: 120,
                              size: const Size(40, 40),
                              fitBoundsOptions: const FitBoundsOptions(
                                padding: EdgeInsets.all(50),
                              ),
                              markers: pikitMarkers,
                              polygonOptions: const PolygonOptions(
                                  borderColor: Colors.blueAccent, color: Colors.black12, borderStrokeWidth: 3),
                              builder: (context, markers) {
                                return FloatingActionButton(
                                  child: Text(markers.length.toString()),
                                  onPressed: null,
                                );
                              },
                            ));
                          } else {
                            return Container();
                          }
                        },
                      )
                    ],
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

  Marker buildPikitMarker(Pikit pikit) {
    double height = pikit.pikitImage.isLandscape ? 36 : 64;
    double width = pikit.pikitImage.isLandscape ? 64 : 36;
    double offsetHeight = 8 + 2 + 2; // height of triangle + padding top + padding bottom
    double offsetWidth = 2 + 2; // padding right + padding left
    return Marker(
        point: LatLng(pikit.position.latitude, pikit.position.longitude),
        height: height + offsetHeight,
        width: width + offsetWidth,
        builder: (context) {
          return PikitPreview(pikit: pikit, height: height, width: width);
        });
  }
}
