import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Pikit {
  Pikit({required this.pikitImage, required this.position, required this.pikitId});

  final PikitImage pikitImage;
  final GeoFirePoint position;
  final String pikitId;

  factory Pikit.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    var htmlUrl = doc.data()!["htmlUrl"];
    var htmlUrlPreview = doc.data()!["htmlUrlPreview"];
    var isLandscape = doc.data()!["isLandscape"];
    var position = doc.data()!["position"]["geopoint"];
    var pikitId = doc.id;

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
      pikitId: pikitId,
    );
  }
}

class PikitImage {
  PikitImage({required this.htmlUrl, required this.htmlUrlPreview, required this.isLandscape});

  final String htmlUrl;
  final String htmlUrlPreview;
  final bool isLandscape;
}
