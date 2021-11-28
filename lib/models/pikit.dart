import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Pikit {
  Pikit({required this.pikitImage, required this.position});

  final PikitImage pikitImage;
  final GeoFirePoint position;

  static Pikit fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    var htmlUrl = doc.data()!["htmlUrl"];
        var htmlUrlPreview = doc.data()!["htmlUrlPreview"];
        var isLandscape = doc.data()!["isLandscape"];
        var position = doc.data()!["position"]["geopoint"];
        return Pikit(
          pikitImage: PikitImage(
            htmlUrl: htmlUrl,
            htmlUrlPreview: htmlUrlPreview,
            isLandscape: isLandscape,
          ),
          position: Geoflutterfire().point(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
  }
}

class PikitImage {
  PikitImage({required this.htmlUrl, required this.htmlUrlPreview, required this.isLandscape});

  final String htmlUrl;
  final String htmlUrlPreview;
  final bool isLandscape;
}
