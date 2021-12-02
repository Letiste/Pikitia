import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';

class Pikit {
  Pikit({required this.pikitImage, required this.position, required this.pikitId});

  final PikitImage pikitImage;
  final GeoFirePoint position;
  final String pikitId;

  factory Pikit.fromDocument(DocumentSnapshot<Map<String, dynamic>> doc) {
    var htmlUrl = doc.data()?["htmlUrl"] ?? "null";
    var htmlUrlPreview = doc.data()?["htmlUrlPreview"] ?? "null";
    var isLandscape = doc.data()?["isLandscape"] ?? false;
    var position = doc.data()?["position"]["geopoint"] ?? {"position": 0, "longitude": 0};
    var pikitId = doc.id;
    var imageId = doc.data()?["imageId"] ?? "null";
    var imagePreviewId = doc.data()?["imagePreviewId"] ?? "null";

    return Pikit(
      pikitImage: PikitImage(
        imageId: imageId,
        imagePreviewId: imagePreviewId,
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
  PikitImage({required this.imageId, required this.imagePreviewId, required this.htmlUrl, required this.htmlUrlPreview, required this.isLandscape});

  final String imageId;
  final String imagePreviewId;
  final String htmlUrl;
  final String htmlUrlPreview;
  final bool isLandscape;
}
