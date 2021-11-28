import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart' as firebase_firestore;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:geolocator/geolocator.dart';
import 'package:pikitia/locator.dart';
import 'package:pikitia/models/pikit.dart';
import 'package:pikitia/services/position_service.dart';
import 'package:uuid/uuid.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:image/image.dart' as img;

class PikitService {
  PikitService() {
    _storage = firebase_storage.FirebaseStorage.instance;
    _firestore = firebase_firestore.FirebaseFirestore.instance;
    _geo = Geoflutterfire();
  }

  late firebase_storage.FirebaseStorage _storage;
  late firebase_firestore.FirebaseFirestore _firestore;
  late Geoflutterfire _geo;

  Future<void> createPikit(String filePath) async {
    PikitImage pikitImage = await _uploadFile(filePath);
    Position currentPosition = await locator<PositionService>().getCurrentPosition();
    GeoFirePoint position = _geo.point(latitude: currentPosition.latitude, longitude: currentPosition.longitude);
    firebase_firestore.FirebaseFirestore.instance.collection('pikits').add(<String, dynamic>{
      'htmlUrl': pikitImage.htmlUrl,
      'htmlUrlPreview': pikitImage.htmlUrlPreview,
      'position': position.data,
    });
  }

  Stream<List<Pikit>> watchPikits(Position position) {
    firebase_firestore.CollectionReference collectionReference = _firestore.collection('pikits');
    GeoFirePoint center = _geo.point(latitude: position.latitude, longitude: position.longitude);
    return _geo
        .collection(collectionRef: collectionReference)
        .within(center: center, radius: 5, field: 'position')
        .distinct()
        .map((docs) {
      return docs.map((doc) {
        var htmlUrl = doc.data()!["htmlUrl"];
        var htmlUrlPreview = doc.data()!["htmlUrlPreview"];
        var position = doc.data()!["position"]["geopoint"];
        return Pikit(
          pikitImage: PikitImage(
            htmlUrl: htmlUrl,
            htmlUrlPreview: htmlUrlPreview,
          ),
          position: _geo.point(
            latitude: position.latitude,
            longitude: position.longitude,
          ),
        );
      }).toList();
    });
  }

  Future<PikitImage> _uploadFile(String filePath) async {
    File file = File(filePath);
    img.Image image = img.decodeJpg(file.readAsBytesSync());
    img.Image preview;
    if (image.height > image.width) {
      preview = img.copyResize(image, height: 120);
    } else {
      preview = img.copyResize(image, width: 120);
    }
    String fileName = const Uuid().v4();
    late String htmlUrl;
    late String htmlUrlPreview;
    var uploadedImage = _storage
        .ref('pikits/$fileName.jpeg')
        .putFile(file)
        .then((file) => _getHtmlUrl(file))
        .then((url) => htmlUrl = url);
    var uploadedImagePreview = _storage
        .ref('pikits/$fileName-preview.jpeg')
        .putData(img.encodeJpg(preview) as Uint8List)
        .then((file) => _getHtmlUrl(file))
        .then((url) => htmlUrlPreview = url);
    await Future.wait([uploadedImage, uploadedImagePreview]);
    return PikitImage(htmlUrl: htmlUrl, htmlUrlPreview: htmlUrlPreview);
  }

  Future<String> _getHtmlUrl(firebase_storage.TaskSnapshot snapshot) {
    return _storage.ref(snapshot.ref.fullPath.toString()).getDownloadURL();
  }
}
