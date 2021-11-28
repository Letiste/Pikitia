import 'package:geoflutterfire/geoflutterfire.dart';

class Pikit {
  Pikit({required this.pikitImage, required this.position});

  final PikitImage pikitImage;
  final GeoFirePoint position;
}

class PikitImage {
  PikitImage({required this.htmlUrl, required this.htmlUrlPreview});

  final String htmlUrl;
  final String htmlUrlPreview;
}
