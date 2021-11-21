import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PhotosMap extends StatefulWidget {
  const PhotosMap({Key? key}) : super(key: key);

  @override
  State<PhotosMap> createState() => _PhotosMapState();
}

class _PhotosMapState extends State<PhotosMap> {
  @override
  Widget build(BuildContext context) {
    return FlutterMap(
      options: MapOptions(
        center: LatLng(51.5, -0.09),
        zoom: 15,
        minZoom: 11.5,
        // maxZoom: 25
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
          subdomains: ['a', 'b', 'c'],
        ),
        MarkerLayerOptions(
          markers: [
            Marker(
              width: 80.0,
              height: 80.0,
              point: LatLng(51.5, -0.09),
              builder: (ctx) => const Icon(Icons.person_pin_circle_sharp),
            ),
          ],
        ),
        CircleLayerOptions(
          circles: [
            CircleMarker(
              point: LatLng(51.5, -0.09),
              radius: 5000,
              color: Colors.transparent,
              borderColor: Colors.red,
              borderStrokeWidth: 2,
              useRadiusInMeter: true,
            )
          ],
        ),
      ],
    );
  }
}
