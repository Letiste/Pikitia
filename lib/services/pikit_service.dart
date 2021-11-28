import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart' as firebase_firestore;
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:geolocator/geolocator.dart';
import 'package:pikitia/locator.dart';
import 'package:pikitia/models/pikit.dart';
import 'package:pikitia/services/position_service.dart';
import 'package:pikitia/services/user_service.dart';
import 'package:uuid/uuid.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:image/image.dart' as img;

class PikitService {
  PikitService() {
    _storage = firebase_storage.FirebaseStorage.instance;
    _firestore = firebase_firestore.FirebaseFirestore.instance;
    _pikitsCollection = _firestore.collection('pikits');
    _geo = Geoflutterfire();
  }

  late firebase_storage.FirebaseStorage _storage;
  late firebase_firestore.FirebaseFirestore _firestore;
  late firebase_firestore.CollectionReference _pikitsCollection;
  late Geoflutterfire _geo;

  Future<void> createPikit(String filePath) async {
    late PikitImage pikitImage;
    late Position currentPosition;
    Future<void> pikitImageFuture = _uploadFile(filePath).then((pikitImg) => pikitImage = pikitImg);
    Future<void> currentPositionFuture =
        locator<PositionService>().getCurrentPosition().then((pos) => currentPosition = pos);
    await Future.wait([pikitImageFuture, currentPositionFuture]);
    GeoFirePoint position = _geo.point(latitude: currentPosition.latitude, longitude: currentPosition.longitude);
    _pikitsCollection.add(<String, dynamic>{
      'htmlUrl': pikitImage.htmlUrl,
      'htmlUrlPreview': pikitImage.htmlUrlPreview,
      'isLandscape': pikitImage.isLandscape,
      'position': position.data,
      'userId': locator<UserService>().getCurrentUser()!.uid,
    });
  }

  Future<List<Pikit>> getUserPikits() async {
    String currentUserId = locator<UserService>().getCurrentUser()!.uid;
    var query = await _pikitsCollection.where('userId', isEqualTo: currentUserId).get();
    return query.docs
        .map((doc) => Pikit.fromDocument(doc as firebase_firestore.QueryDocumentSnapshot<Map<String, dynamic>>))
        .toList();
  }

  Stream<List<Pikit>> watchPikits(Position position) {
    GeoFirePoint center = _geo.point(latitude: position.latitude, longitude: position.longitude);
    return _geo
        .collection(collectionRef: _pikitsCollection)
        .within(center: center, radius: 5, field: 'position')
        .distinct()
        .map((docs) {
      return docs.map(Pikit.fromDocument).toList();
    });
  }

  Future<PikitImage> _uploadFile(String filePath) async {
    File file = File(filePath);
    img.Image image = img.decodeJpg(file.readAsBytesSync());
    img.Image preview;
    bool isLandscape = image.width > image.height;
    if (isLandscape) {
      preview = img.copyResize(image, width: 120);
    } else {
      preview = img.copyResize(image, height: 120);
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
    return PikitImage(htmlUrl: htmlUrl, htmlUrlPreview: htmlUrlPreview, isLandscape: isLandscape);
  }

  Future<String> _getHtmlUrl(firebase_storage.TaskSnapshot snapshot) {
    return _storage.ref(snapshot.ref.fullPath.toString()).getDownloadURL();
  }
}
